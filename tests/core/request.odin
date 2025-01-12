package core_test

import "core:log"
import "core:net"
import "core:testing"
import "core:thread"
import "core:time"
import "src:core"

// @(test)
request :: proc(t: ^testing.T) {
	rp: core.Req_Proc = core.http_req_proc
	got, want := rp("http://localhost/test"), "test data"
	testing.expect_value(t, got, want)
}

// TODO: Remove after learning https and websocket
@(test)
learning_sockets :: proc(t: ^testing.T) {
	e, _, err := net.resolve("dummyjson.com:443")
	if !testing.expectf(t, err == nil, "want resolve err nil, got %v", err) {
		return
	}

	sock: net.TCP_Socket
	sock, err = net.dial_tcp(e)
	defer net.close(sock)
	if !testing.expectf(t, err == nil, "want dial err nil, got %v", err) {
		return
	}

	buf :=
		"GET /test HTTP/1.1\r\n" +
		"Host: dummyjson.com\r\n" +
		"User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:134.0) Gecko/20100101 Firefox/134.0\r\n" +
		"Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\r\n" +
		"Accept-Language: en-US,en;q=0.5\r\n" +
		"Accept-Encoding: gzip, deflate, br, zstd\r\n" +
		"Connection: keep-alive\r\n" +
		"Upgrade-Insecure-Requests: 1\r\n" +
		"Sec-Fetch-Dest: document\r\n" +
		"Sec-Fetch-Mode: navigate\r\n" +
		"Sec-Fetch-Site: cross-site\r\n" +
		"Priority: u=0, i\r\n" +
		"\r\n"


	wrt: int
	wrt, err = net.send_tcp(sock, transmute([]byte)buf)
	log.infof("send bytes %v", wrt)
	if !testing.expectf(t, err == nil, "want send err nil, got %v", err) {
		return
	}

	net.set_option(sock, .Receive_Timeout, time.Duration(10 * time.Second))

	N :: 1024
	rd := N
	data := [N]byte{}
	for rd == N {
		data = [N]byte{}
		rd, err = net.recv_tcp(sock, data[:])
		if !testing.expectf(t, err == nil, "want client err nil, got %v", err) {
			return
		}
		log.infof("rcvd bytes: %v", rd)
		log.infof("rcvd data: %s", data)
	}
}

@(test)
num :: proc(t: ^testing.T) {
	ig := 1
	log.infof("num: %v, %b", ig, ig)

	i: f32 = 1
	log.infof("num: %v", i)

	p := rawptr(&i)
	t := cast(^i32)p
	log.infof("num: %v, %b", t^, t^)

	log.infof("num: %v", transmute([4]u8)i)
}
