package server

import (
	"bytes"
	"github.com/gin-gonic/gin"
	"github.com/go-playground/validator/v10"
	"github.com/sirupsen/logrus"
	ep "gitlab.com/ip-guiabolso/events-protocol-go"
	"gitlab.com/ip-guiabolso/go-toolkit"
	"net/http"
)

type Server struct {
	validate       *validator.Validate
	EventProcessor *ep.EventProcessor
}

// New is method to get a new server instance
func New() (*Server, error) {
	s := Server{
		validate: validator.New(),
	}
	eventProcessor := ep.NewEventProcessor()
	eventProcessor.AddHandler(s.DefaultHandler())
	s.EventProcessor = &eventProcessor
	return &s, nil
}

//Create New Engine
func (s *Server) NewEngine() *gin.Engine {

	r := toolkit.NewGinServer(true)
	gin.SetMode(gin.ReleaseMode)
	if logrus.GetLevel() == logrus.DebugLevel || logrus.GetLevel() == logrus.TraceLevel {
		gin.SetMode(gin.DebugMode)
	}

	r.POST("/events", s.Router)

	return r
}

func (s *Server) Router(c *gin.Context) {
	buf := new(bytes.Buffer)
	_, _ = buf.ReadFrom(c.Request.Body)
	str := buf.String()
	event := s.EventProcessor.ProcessEvent(str, c.Request.Context())
	c.JSON(http.StatusOK, event)
}
