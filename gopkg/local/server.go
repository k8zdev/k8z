package local

import (
	"github.com/gin-gonic/gin"
)

var router = gin.New()

func Server() {
	router.GET("/ping", func(c *gin.Context) {
		c.JSON(200, gin.H{"message": "pong"})
	})
	router.Run(":19257")
}
