package core

import "core:net"
import "core:strings"

// TODO: Handle errors
http_req_proc :: proc(url: string) -> string {
	_, h, _, _, _ := net.split_url(url)
	sok, _ := net.dial_tcp(h)
	defer net.close(sok)

	// TODO: Send HTTP headers and body

	// FIX: Optimize?
	data := [1]u8{}
	sb := strings.builder_make()
	defer strings.builder_destroy(&sb)
	for {
		br, _ := net.recv(sok, data[:])
		if br == 0 {
			break
		}

		strings.write_byte(&sb, data[0])
	}

	return strings.to_string(sb)
}
