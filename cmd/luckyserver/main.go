package main

import (
	"os"

	"github.com/k8zdev/k8z/gopkg/lucky"
	"github.com/sirupsen/logrus"
)

func main() {
	addr := os.Getenv("LISTEN_ADDR")
	if addr == "" {
		addr = ":8080"
	}
	logrus.SetFormatter(&logrus.JSONFormatter{})
	logrus.Info("starting lucky-code server (in-memory dev mode)")

	if err := lucky.RunMem(addr); err != nil {
		logrus.WithError(err).Fatal("server stopped")
	}
}
