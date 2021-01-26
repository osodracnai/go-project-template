package server

import ep "gitlab.com/ip-guiabolso/events-protocol-go"

func (s Server) DefaultHandler() *ep.Handler {
	return &ep.Handler{
		Name:    "default:test:event",
		Version: 1,
		Handle:  s.HandlerFunc(),
	}
}
