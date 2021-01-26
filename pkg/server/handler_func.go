package server

import (
	ep "gitlab.com/ip-guiabolso/events-protocol-go"
)

func (s *Server) HandlerFunc() ep.Handle {
	return func(event *ep.Event) (*ep.Event, error) {
		return event.BuildResponseEvent(nil), nil
	}
}
