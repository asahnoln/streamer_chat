package core_test

import "core:io"
import "core:log"
import "core:net"
import "core:sort"
import "core:sync"
import "core:testing"
import "core:thread"
import "core:time"
import "src:core"

create_test_server :: proc(t: ^testing.T) -> (net.Any_Socket, ^thread.Thread) {
	// FIX: Use random port?
	ep, _, _ := net.resolve("localhost:8080")
	srv, err := net.listen_tcp(ep)
	if !testing.expectf(t, err == nil, "want srv listen err nil, got %v", err) {
		return nil, nil
	}

	thr := thread.create_and_start_with_poly_data2(
		t,
		srv,
		proc(t: ^testing.T, srv: net.TCP_Socket) {
			cli, _, err := net.accept_tcp(srv)
			if !testing.expectf(t, err == nil, "want srv accept err nil, got %v", err) {
				return
			}
			defer net.close(cli)

			// TODO: Test proper http text from client

			d := "test data"
			bw: int
			bw, err = net.send(cli, transmute([]byte)d)
			testing.expectf(t, err == nil, "want srv send err nil, got %v", err)
		},
		context,
	)

	return srv, thr
}

// TODO: test http and https without port (they should be 80 and 443 by default)
@(test)
request :: proc(t: ^testing.T) {
	srv, thr := create_test_server(t)
	defer {
		net.close(srv)
		thread.destroy(thr)
	}

	rp: core.Req_Proc = core.http_req_proc
	got, want := rp("http://localhost:8080/test"), "test data"
	testing.expect_value(t, got, want)
}

// TODO: Remove after learning https and websocket
// @(test)
learning_sockets :: proc(t: ^testing.T) {
	e, _, err := net.resolve("dummyjson.com:80")
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

	net.set_option(sock, .Receive_Timeout, time.Duration(1 * time.Second))

	N :: 1024
	rd := N
	data := [N]byte{}
	i := 0
	for rd == N {
		data = [N]byte{}
		rd, err = net.recv_tcp(sock, data[:])
		if !testing.expectf(t, err == nil, "want client err nil, got %v", err) {
			return
		}
		i += rd
		log.infof("rcvd bytes: %v", rd)
		log.infof("rcvd data: %s", data)
	}

	log.info("finished test learning_sockets")
	testing.expect(t, i > 0)
}
