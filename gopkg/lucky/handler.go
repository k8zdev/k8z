package lucky

import (
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"github.com/sirupsen/logrus"
)

// UserIDKey is the gin context key where authentication middleware stores the user id.
const UserIDKey = "user_id"

// RegisterRoutes mounts lucky-code endpoints onto the given router group.
func (s *Store) RegisterRoutes(r *gin.RouterGroup) {
	v1 := r.Group("/api/v1/codes")
	{
		v1.POST("", s.handleCreate)
		v1.GET("", s.handleList)
		v1.POST("/:id/copy", s.handleCopy)
		v1.GET("/mine", s.handleMine)
		v1.DELETE("/:id", s.handleDelete)
	}
}

func (s *Store) handleCreate(c *gin.Context) {
	userID := c.GetString(UserIDKey)
	if userID == "" {
		// In dev / no-auth mode accept an anonymous user.
		userID = c.GetHeader("X-User-ID")
		if userID == "" {
			userID = "anon"
		}
	}

	var req CreateCodeRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"code": "BAD_REQUEST", "message": err.Error()})
		return
	}
	if req.CodeText == "" {
		c.JSON(http.StatusBadRequest, gin.H{"code": "BAD_REQUEST", "message": "code_text is required"})
		return
	}

	code, err := s.CreateCode(userID, req.CodeText)
	if err != nil {
		logrus.WithError(err).Error("create code failed")
		c.JSON(http.StatusInternalServerError, gin.H{"code": "INTERNAL_ERROR", "message": "create code failed"})
		return
	}
	c.JSON(http.StatusCreated, gin.H{"data": code})
}

func (s *Store) handleList(c *gin.Context) {
	page, pageSize := parsePagination(c)

	resp, err := s.ListActive(page, pageSize)
	if err != nil {
		logrus.WithError(err).Error("list codes failed")
		c.JSON(http.StatusInternalServerError, gin.H{"code": "INTERNAL_ERROR", "message": "list codes failed"})
		return
	}
	c.JSON(http.StatusOK, resp)
}

func (s *Store) handleCopy(c *gin.Context) {
	codeID := c.Param("id")
	if codeID == "" {
		c.JSON(http.StatusBadRequest, gin.H{"code": "BAD_REQUEST", "message": "id is required"})
		return
	}

	copiedBy := c.GetString(UserIDKey)
	if copiedBy == "" {
		copiedBy = c.GetHeader("X-User-ID")
		if copiedBy == "" {
			copiedBy = "anon"
		}
	}

	codeText, ok, err := s.CopyCode(codeID, copiedBy)
	if err != nil {
		logrus.WithError(err).Error("copy code failed")
		c.JSON(http.StatusInternalServerError, gin.H{"code": "INTERNAL_ERROR", "message": "copy code failed"})
		return
	}
	if !ok {
		c.JSON(http.StatusConflict, gin.H{"code": "ALREADY_COPIED", "message": "该口令已被使用或不存在"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"success": true, "code_text": codeText})
}

func (s *Store) handleMine(c *gin.Context) {
	userID := c.GetString(UserIDKey)
	if userID == "" {
		userID = c.GetHeader("X-User-ID")
		if userID == "" {
			userID = "anon"
		}
	}
	page, pageSize := parsePagination(c)

	resp, err := s.ListMine(userID, page, pageSize)
	if err != nil {
		logrus.WithError(err).Error("list mine failed")
		c.JSON(http.StatusInternalServerError, gin.H{"code": "INTERNAL_ERROR", "message": "list mine failed"})
		return
	}
	// resp is *ListResponse{Data: []MineItem, Total: N, Page: P, PageSize: S}
	c.JSON(http.StatusOK, resp)
}

func (s *Store) handleDelete(c *gin.Context) {
	codeID := c.Param("id")
	if codeID == "" {
		c.JSON(http.StatusBadRequest, gin.H{"code": "BAD_REQUEST", "message": "id is required"})
		return
	}

	userID := c.GetString(UserIDKey)
	if userID == "" {
		userID = c.GetHeader("X-User-ID")
		if userID == "" {
			c.JSON(http.StatusUnauthorized, gin.H{"code": "UNAUTHORIZED", "message": "user identity required"})
			return
		}
	}

	deleted, err := s.DeleteCode(codeID, userID)
	if err != nil {
		logrus.WithError(err).Error("delete code failed")
		c.JSON(http.StatusInternalServerError, gin.H{"code": "INTERNAL_ERROR", "message": "delete code failed"})
		return
	}
	if !deleted {
		c.JSON(http.StatusNotFound, gin.H{"code": "NOT_FOUND", "message": "口令不存在或无权操作"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"success": true})
}

func parsePagination(c *gin.Context) (page, pageSize int) {
	page, _ = strconv.Atoi(c.DefaultQuery("page", "1"))
	pageSize, _ = strconv.Atoi(c.DefaultQuery("page_size", "20"))
	if page < 1 {
		page = 1
	}
	if pageSize < 1 || pageSize > 100 {
		pageSize = 20
	}
	return
}
