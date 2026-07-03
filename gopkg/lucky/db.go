package lucky

import (
	"database/sql"
	"fmt"
	"sort"
	"time"

	"github.com/google/uuid"
)

// Store wraps database operations for lucky codes.
// An in-memory mode (DB==nil) is used for development / when PostgreSQL is unavailable.
type Store struct {
	DB *sql.DB
	// In-memory fallback fields
	memCodes   []*LuckyCode
	memRecords []*CopyRecord
}

// NewMemStore returns a Store backed by process memory (dev / no-DB mode).
func NewMemStore() *Store {
	return &Store{}
}

// NewDBStore returns a Store backed by a PostgreSQL connection.
func NewDBStore(db *sql.DB) (*Store, error) {
	if err := db.Ping(); err != nil {
		return nil, fmt.Errorf("db ping: %w", err)
	}
	return &Store{DB: db}, nil
}

// InitSchema creates tables if they do not exist.
func (s *Store) InitSchema() error {
	if s.DB == nil {
		return nil // nothing to migrate in mem mode
	}
	ddl := `
	CREATE TABLE IF NOT EXISTS lucky_codes (
		id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
		user_id    UUID NOT NULL,
		code_text  TEXT NOT NULL,
		status     VARCHAR(16) NOT NULL DEFAULT 'active',
		copy_count INT NOT NULL DEFAULT 0,
		created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
		updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
		expired_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() + interval '24 hours')
	);

	CREATE INDEX IF NOT EXISTS idx_lucky_codes_status_created
		ON lucky_codes (status, created_at DESC);

	CREATE INDEX IF NOT EXISTS idx_lucky_codes_user_id
		ON lucky_codes (user_id);

	CREATE INDEX IF NOT EXISTS idx_lucky_codes_expired_at
		ON lucky_codes (expired_at) WHERE status = 'active';

	CREATE TABLE IF NOT EXISTS copy_records (
		id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
		code_id   UUID NOT NULL REFERENCES lucky_codes(id) ON DELETE CASCADE,
		copied_by UUID NOT NULL,
		copied_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
		UNIQUE (code_id, copied_by)
	);

	CREATE INDEX IF NOT EXISTS idx_copy_records_copied_by
		ON copy_records (copied_by);
	`
	_, err := s.DB.Exec(ddl)
	return err
}

// CreateCode inserts a new lucky code and returns it.
func (s *Store) CreateCode(userID, codeText string) (*LuckyCode, error) {
	if s.DB != nil {
		return s.createCodeDB(userID, codeText)
	}
	return s.createCodeMem(userID, codeText)
}

func (s *Store) createCodeDB(userID, codeText string) (*LuckyCode, error) {
	c := &LuckyCode{}
	err := s.DB.QueryRow(
		`INSERT INTO lucky_codes (user_id, code_text) VALUES ($1, $2)
		 RETURNING id, user_id, code_text, status, copy_count, created_at, updated_at, expired_at`,
		userID, codeText,
	).Scan(&c.ID, &c.UserID, &c.CodeText, &c.Status, &c.CopyCount, &c.CreatedAt, &c.UpdatedAt, &c.ExpiredAt)
	if err != nil {
		return nil, fmt.Errorf("insert lucky_code: %w", err)
	}
	c.ExpiresIn = expiresIn(c.ExpiredAt)
	return c, nil
}

func (s *Store) createCodeMem(userID, codeText string) (*LuckyCode, error) {
	now := time.Now().UTC()
	c := &LuckyCode{
		ID:        uuid.NewString(),
		UserID:    userID,
		CodeText:  codeText,
		Status:    StatusActive,
		CopyCount: 0,
		CreatedAt: now,
		UpdatedAt: now,
		ExpiredAt: now.Add(24 * time.Hour),
		ExpiresIn: 86400,
	}
	s.memCodes = append(s.memCodes, c)
	return c, nil
}

// ListActive returns active codes ordered by newest first.
func (s *Store) ListActive(page, pageSize int) (*ListResponse, error) {
	if s.DB != nil {
		return s.listActiveDB(page, pageSize)
	}
	return s.listActiveMem(page, pageSize)
}

func (s *Store) listActiveDB(page, pageSize int) (*ListResponse, error) {
	var total int
	if err := s.DB.QueryRow(
		"SELECT count(*) FROM lucky_codes WHERE status = $1", StatusActive,
	).Scan(&total); err != nil {
		return nil, fmt.Errorf("count active: %w", err)
	}

	offset := (page - 1) * pageSize
	rows, err := s.DB.Query(
		`SELECT id, user_id, code_text, status, copy_count, created_at, updated_at, expired_at
		 FROM lucky_codes WHERE status = $1
		 ORDER BY created_at DESC LIMIT $2 OFFSET $3`,
		StatusActive, pageSize, offset,
	)
	if err != nil {
		return nil, fmt.Errorf("list active: %w", err)
	}
	defer rows.Close()

	codes := make([]LuckyCode, 0, pageSize)
	for rows.Next() {
		var c LuckyCode
		if err := rows.Scan(&c.ID, &c.UserID, &c.CodeText, &c.Status, &c.CopyCount, &c.CreatedAt, &c.UpdatedAt, &c.ExpiredAt); err != nil {
			return nil, fmt.Errorf("scan code: %w", err)
		}
		c.ExpiresIn = expiresIn(c.ExpiredAt)
		codes = append(codes, c)
	}
	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("rows: %w", err)
	}
	if codes == nil {
		codes = []LuckyCode{}
	}

	return &ListResponse{Data: codes, Total: total, Page: page, PageSize: pageSize}, nil
}

func (s *Store) listActiveMem(page, pageSize int) (*ListResponse, error) {
	active := make([]LuckyCode, 0)
	for _, c := range s.memCodes {
		if c.Status == StatusActive {
			cp := *c
			cp.ExpiresIn = expiresIn(cp.ExpiredAt)
			active = append(active, cp)
		}
	}
	// Already in insertion order (newest last), reverse for newest-first.
	for i, j := 0, len(active)-1; i < j; i, j = i+1, j-1 {
		active[i], active[j] = active[j], active[i]
	}
	total := len(active)
	start := (page - 1) * pageSize
	if start >= total {
		return &ListResponse{Data: []LuckyCode{}, Total: total, Page: page, PageSize: pageSize}, nil
	}
	end := start + pageSize
	if end > total {
		end = total
	}
	return &ListResponse{Data: active[start:end], Total: total, Page: page, PageSize: pageSize}, nil
}

// CopyCode atomically marks a code as copied and records the copy.
// Returns the code text and whether the operation succeeded.
func (s *Store) CopyCode(codeID, copiedBy string) (string, bool, error) {
	if s.DB != nil {
		return s.copyCodeDB(codeID, copiedBy)
	}
	return s.copyCodeMem(codeID, copiedBy)
}

func (s *Store) copyCodeDB(codeID, copiedBy string) (string, bool, error) {
	tx, err := s.DB.Begin()
	if err != nil {
		return "", false, fmt.Errorf("begin tx: %w", err)
	}
	defer tx.Rollback()

	// Atomically swap status active→copied. If the code was already copied or expired this
	// returns no rows and we bail out.
	var codeText string
	err = tx.QueryRow(
		`UPDATE lucky_codes SET status = $1, copy_count = copy_count + 1, updated_at = now()
		 WHERE id = $2 AND status = $3
		 RETURNING code_text`,
		StatusCopied, codeID, StatusActive,
	).Scan(&codeText)
	if err == sql.ErrNoRows {
		return "", false, nil
	}
	if err != nil {
		return "", false, fmt.Errorf("atomic update: %w", err)
	}

	// Insert copy record (ignore duplicate silently).
	_, err = tx.Exec(
		`INSERT INTO copy_records (code_id, copied_by) VALUES ($1, $2) ON CONFLICT DO NOTHING`,
		codeID, copiedBy,
	)
	if err != nil {
		return "", false, fmt.Errorf("insert copy_record: %w", err)
	}

	if err := tx.Commit(); err != nil {
		return "", false, fmt.Errorf("commit: %w", err)
	}
	return codeText, true, nil
}

func (s *Store) copyCodeMem(codeID, copiedBy string) (string, bool, error) {
	// Check duplicate in memory.
	for _, r := range s.memRecords {
		if r.CodeID == codeID && r.CopiedBy == copiedBy {
			return "", false, nil
		}
	}
	for _, c := range s.memCodes {
		if c.ID == codeID {
			if c.Status != StatusActive {
				return "", false, nil
			}
			c.Status = StatusCopied
			c.CopyCount++
			c.UpdatedAt = time.Now().UTC()
			s.memRecords = append(s.memRecords, &CopyRecord{
				ID:       uuid.NewString(),
				CodeID:   codeID,
				CopiedBy: copiedBy,
				CopiedAt: time.Now().UTC(),
			})
			return c.CodeText, true, nil
		}
	}
	return "", false, nil
}

// ListMine returns a unified, paginated list of codes the user published or copied.
// Each item carries a "role" field ("publisher" or "copier") for front-end tab splitting.
func (s *Store) ListMine(userID string, page, pageSize int) (*ListResponse, error) {
	if s.DB != nil {
		return s.listMineDB(userID, page, pageSize)
	}
	return s.listMineMem(userID, page, pageSize)
}

func (s *Store) listMineDB(userID string, page, pageSize int) (*ListResponse, error) {
	// Use a UNION query to get both published and copied in one result set,
	// ordered by creation time descending.
	query := `
		SELECT id, code_text, status, role, created_at
		FROM (
			SELECT id, code_text, status, 'publisher' AS role, created_at
			FROM lucky_codes
			WHERE user_id = $1
			UNION ALL
			SELECT lc.id, lc.code_text, lc.status, 'copier' AS role, cr.copied_at AS created_at
			FROM lucky_codes lc
			JOIN copy_records cr ON cr.code_id = lc.id
			WHERE cr.copied_by = $1
		) AS combined
		ORDER BY created_at DESC
		LIMIT $2 OFFSET $3
	`

	// Total count (separate query for simplicity).
	var totalPub, totalCop int
	if err := s.DB.QueryRow("SELECT count(*) FROM lucky_codes WHERE user_id = $1", userID).Scan(&totalPub); err != nil {
		return nil, fmt.Errorf("count published: %w", err)
	}
	if err := s.DB.QueryRow("SELECT count(*) FROM copy_records WHERE copied_by = $1", userID).Scan(&totalCop); err != nil {
		return nil, fmt.Errorf("count copied: %w", err)
	}
	total := totalPub + totalCop

	offset := (page - 1) * pageSize
	rows, err := s.DB.Query(query, userID, pageSize, offset)
	if err != nil {
		return nil, fmt.Errorf("list mine: %w", err)
	}
	defer rows.Close()

	items := make([]MineItem, 0, pageSize)
	for rows.Next() {
		var item MineItem
		if err := rows.Scan(&item.ID, &item.CodeText, &item.Status, &item.Role, &item.CreatedAt); err != nil {
			return nil, fmt.Errorf("scan mine item: %w", err)
		}
		items = append(items, item)
	}
	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("rows: %w", err)
	}
	if items == nil {
		items = []MineItem{}
	}

	return &ListResponse{Data: items, Total: total, Page: page, PageSize: pageSize}, nil
}

func (s *Store) listMineMem(userID string, page, pageSize int) (*ListResponse, error) {
	// Collect published items.
	items := make([]MineItem, 0)
	for _, c := range s.memCodes {
		if c.UserID == userID {
			items = append(items, MineItem{
				ID:        c.ID,
				UserID:    c.UserID,
				CodeText:  c.CodeText,
				Status:    c.Status,
				Role:      RolePublisher,
				CopyCount: c.CopyCount,
				CreatedAt: c.CreatedAt,
				ExpiresIn: expiresIn(c.ExpiredAt),
			})
		}
	}

	// Collect copied items.
	for _, r := range s.memRecords {
		if r.CopiedBy == userID {
			for _, c := range s.memCodes {
				if c.ID == r.CodeID {
					items = append(items, MineItem{
						ID:       c.ID,
						CodeText: c.CodeText,
						Status:   c.Status,
						Role:     RoleCopier,
						CopiedAt: r.CopiedAt,
					})
					break
				}
			}
		}
	}

	// Sort by time descending (CreatedAt for publisher, CopiedAt for copier).
	// We reuse the already-built slice; sort by whichever time is available.
	sort.Slice(items, func(i, j int) bool {
		ti := items[i].CreatedAt
		if items[i].Role == RoleCopier {
			ti = items[i].CopiedAt
		}
		tj := items[j].CreatedAt
		if items[j].Role == RoleCopier {
			tj = items[j].CopiedAt
		}
		return ti.After(tj)
	})

	total := len(items)
	offset := (page - 1) * pageSize
	if offset >= total {
		return &ListResponse{Data: []MineItem{}, Total: total, Page: page, PageSize: pageSize}, nil
	}
	end := offset + pageSize
	if end > total {
		end = total
	}
	items = items[offset:end]
	if items == nil {
		items = []MineItem{}
	}

	return &ListResponse{Data: items, Total: total, Page: page, PageSize: pageSize}, nil
}

// DeleteCode deletes a code owned by the given user. Returns whether a row was removed.
func (s *Store) DeleteCode(codeID, userID string) (bool, error) {
	if s.DB != nil {
		return s.deleteCodeDB(codeID, userID)
	}
	return s.deleteCodeMem(codeID, userID)
}

func (s *Store) deleteCodeDB(codeID, userID string) (bool, error) {
	res, err := s.DB.Exec(
		"DELETE FROM lucky_codes WHERE id = $1 AND user_id = $2",
		codeID, userID,
	)
	if err != nil {
		return false, fmt.Errorf("delete code: %w", err)
	}
	n, _ := res.RowsAffected()
	return n > 0, nil
}

func (s *Store) deleteCodeMem(codeID, userID string) (bool, error) {
	for i, c := range s.memCodes {
		if c.ID == codeID && c.UserID == userID {
			s.memCodes = append(s.memCodes[:i], s.memCodes[i+1:]...)
			// Also remove associated copy records.
			kept := s.memRecords[:0]
			for _, r := range s.memRecords {
				if r.CodeID != codeID {
					kept = append(kept, r)
				}
			}
			s.memRecords = kept
			return true, nil
		}
	}
	return false, nil
}

// ExpireCodes marks active codes whose expired_at has passed as expired.
func (s *Store) ExpireCodes() (int64, error) {
	if s.DB != nil {
		return s.expireCodesDB()
	}
	return s.expireCodesMem()
}

func (s *Store) expireCodesDB() (int64, error) {
	res, err := s.DB.Exec(
		`UPDATE lucky_codes SET status = $1, updated_at = now()
		 WHERE status = $2 AND expired_at <= now()`,
		StatusExpired, StatusActive,
	)
	if err != nil {
		return 0, fmt.Errorf("expire codes: %w", err)
	}
	n, _ := res.RowsAffected()
	return n, nil
}

func (s *Store) expireCodesMem() (int64, error) {
	now := time.Now().UTC()
	var n int64
	for _, c := range s.memCodes {
		if c.Status == StatusActive && !c.ExpiredAt.After(now) {
			c.Status = StatusExpired
			c.UpdatedAt = now
			n++
		}
	}
	return n, nil
}

func expiresIn(expiredAt time.Time) int64 {
	s := int64(time.Until(expiredAt).Seconds())
	if s < 0 {
		return 0
	}
	return s
}
