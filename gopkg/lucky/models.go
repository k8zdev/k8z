package lucky

import (
	"time"
)

// Code status constants.
const (
	StatusActive  = "active"
	StatusCopied  = "copied"
	StatusExpired = "expired"
)

// LuckyCode represents a shared code in the platform.
type LuckyCode struct {
	ID         string     `json:"id"`
	UserID     string     `json:"user_id"`
	CodeText   string     `json:"code_text"`
	Status     string     `json:"status"`
	CopyCount  int        `json:"copy_count"`
	CreatedAt  time.Time  `json:"created_at"`
	UpdatedAt  time.Time  `json:"updated_at"`
	ExpiredAt  time.Time  `json:"expired_at"`
	// ExpiresIn returns seconds until expiration; only populated in API responses, not stored.
	ExpiresIn  int64      `json:"expires_in,omitempty"`
}

// CopyRecord tracks who copied which code.
type CopyRecord struct {
	ID       string    `json:"id"`
	CodeID   string    `json:"code_id"`
	CopiedBy string    `json:"copied_by"`
	CopiedAt time.Time `json:"copied_at"`
}

// CreateCodeRequest is the body for POST /api/v1/codes.
type CreateCodeRequest struct {
	CodeText string `json:"code_text" binding:"required"`
}

// ListResponse wraps a paginated list.
type ListResponse struct {
	Data     interface{} `json:"data"`
	Total    int         `json:"total"`
	Page     int         `json:"page"`
	PageSize int         `json:"page_size"`
}

// Role constants for MineItem.
const (
	RolePublisher = "publisher"
	RoleCopier    = "copier"
)

// MineItem is a unified item returned by GET /api/v1/codes/mine.
// The Role field distinguishes "我发布的" (publisher) from "我复制的" (copier).
type MineItem struct {
	ID        string    `json:"id"`
	CodeID    string    `json:"code_id,omitempty"`
	UserID    string    `json:"user_id,omitempty"`
	CodeText  string    `json:"code_text"`
	Status    string    `json:"status"`
	Role      string    `json:"role"` // "publisher" or "copier"
	CopyCount int       `json:"copy_count,omitempty"`
	CreatedAt time.Time `json:"created_at,omitempty"`
	CopiedAt  time.Time `json:"copied_at,omitempty"`
	ExpiresIn int64     `json:"expires_in,omitempty"`
}

// CopyCode joins a copy record with the code that was copied.
type CopyCode struct {
	CopyRecord
	CodeText string `json:"code_text"`
	Status   string `json:"code_status"`
}
