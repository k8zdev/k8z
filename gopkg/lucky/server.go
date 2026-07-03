package lucky

import (
	"database/sql"
	"fmt"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/sirupsen/logrus"
)

// Config holds the server configuration.
type Config struct {
	Addr          string        // Listen address, defaults to ":8080".
	DB            *sql.DB       // Optional PostgreSQL connection; nil runs in-memory.
	ExpireTick    time.Duration // Interval for the expired-code cleanup ticker; 0 disables.
	AuthSkipper   bool          // If true, no auth middleware is applied (dev mode).
}

// Run starts the lucky-code HTTP server. It blocks until the server stops.
func Run(cfg Config) error {
	if cfg.Addr == "" {
		cfg.Addr = ":8080"
	}
	if cfg.ExpireTick == 0 {
		cfg.ExpireTick = 1 * time.Hour
	}

	var store *Store
	var err error
	if cfg.DB != nil {
		store, err = NewDBStore(cfg.DB)
		if err != nil {
			return fmt.Errorf("db store: %w", err)
		}
		if err := store.InitSchema(); err != nil {
			return fmt.Errorf("init schema: %w", err)
		}
	} else {
		store = NewMemStore()
		logrus.Warn("no PostgreSQL configured — running with in-memory store (data lost on restart)")
	}

	// Start expiration ticker in background.
	if cfg.ExpireTick > 0 {
		go store.startExpirationLoop(cfg.ExpireTick)
	}

	r := gin.New()
	r.Use(gin.Logger(), gin.Recovery())

	if !cfg.AuthSkipper {
		r.Use(authMiddleware)
	}

	store.RegisterRoutes(&r.RouterGroup)
	return r.Run(cfg.Addr)
}

func (s *Store) startExpirationLoop(tick time.Duration) {
	ticker := time.NewTicker(tick)
	defer ticker.Stop()
	for range ticker.C {
		n, err := s.ExpireCodes()
		if err != nil {
			logrus.WithError(err).Error("expire-codes tick failed")
			continue
		}
		if n > 0 {
			logrus.WithField("count", n).Info("expired codes cleaned up")
		}
	}
}

func authMiddleware(c *gin.Context) {
	// Placeholder: extract user id from Authorization header / JWT.
	// For now, fall through to X-User-ID header (handled in each handler).
	if uid := c.GetHeader("X-User-ID"); uid != "" {
		c.Set(UserIDKey, uid)
	}
	c.Next()
}

// RunMem starts a development server backed by process memory.
// Equivalent to Run(Config{Addr: addr, AuthSkipper: true}).
func RunMem(addr string) error {
	return Run(Config{Addr: addr, AuthSkipper: true})
}
