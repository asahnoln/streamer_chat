package core_test

import "core:c"
import "core:io"
import "core:log"
import "core:net"
import "core:sort"
import "core:sync"
import "core:testing"
import "core:thread"
import "core:time"
import "src:core"

SSL :: distinct struct {}
SSL_CTX :: distinct struct {}
SSL_METHOD :: distinct struct {}

SSL_Error :: enum c.int {
	Error_None                 = 0,
	Error_Ssl                  = 1,
	Error_Want_Read            = 2,
	Error_Want_Write           = 3,
	Error_Want_X509_Lookup     = 4,
	Error_Syscall              = 5, /* look at error stack/return,
                                       * =value/errno */
	Error_Zero_Return          = 6,
	Error_Want_Connect         = 7,
	Error_Want_Accept          = 8,
	Error_Want_Async           = 9,
	Error_Want_Async_Job       = 10,
	Error_Want_Client_Hello_Cb = 11,
	Error_Want_Retry_Verify    = 12,
}

foreign import libssl "system:ssl"
foreign libssl {
	TLS_method :: proc() -> ^SSL_METHOD ---
	SSL_new :: proc(ctx: ^SSL_CTX) -> ^SSL ---
}

@(link_prefix = "SSL_")
foreign libssl {
	CTX_new :: proc(method: ^SSL_METHOD) -> ^SSL_CTX ---
	set_fd :: proc(ssl: ^SSL, fd: c.int) -> c.int ---
	connect :: proc(ssl: ^SSL) -> c.int ---
	get_error :: proc(ssl: ^SSL, ret: c.int) -> SSL_Error ---
	shutdown :: proc(ssl: ^SSL) -> c.int ---
}

@(test)
learning_request_https :: proc(t: ^testing.T) {
	// srv, thr := create_https_test_server(t)
	// defer {
	// 	net.close(srv)
	// 	thread.destroy(thr)
	// }
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

	m := TLS_method()
	log.infof("tls: %v", m)

	ctx := CTX_new(m)
	log.infof("ssl ctx: %v", ctx)

	s := SSL_new(ctx)
	log.infof("ssl: %v", s)

	r := set_fd(s, cast(c.int)sock)
	log.infof("ssl set fd: %v", r)

	r = connect(s)
	log.infof("ssl connect: %v", r)
	defer shutdown(s)

	r2 := get_error(s, r)
	log.infof("ssl error: %v", r2)
}

create_https_test_server :: proc(t: ^testing.T) -> (net.TCP_Socket, ^thread.Thread) {
	// FIX: Use random port?
	ep, _, err := net.resolve("localhost:8888")
	if !testing.expectf(t, err == nil, "want srv resolve err nil, got %v", err) {
		return -1, nil
	}

	srv: net.TCP_Socket
	srv, err = net.listen_tcp(ep)
	if !testing.expectf(t, err == nil, "want srv listen err nil, got %v", err) {
		return srv, nil
	}

	thr := thread.create_and_start_with_poly_data2(
		t,
		srv,
		proc(t: ^testing.T, srv: net.TCP_Socket) {
			// cli, _, err := net.accept_tcp(srv)
			// if !testing.expectf(t, err == nil, "want srv accept err nil, got %v", err) {
			// 	return
			// }
			// defer net.close(cli)
			//
			// // TODO: Test proper http text from client
			//
			// d := "test data"
			// bw: int
			// bw, err = net.send(cli, transmute([]byte)d)
			// testing.expectf(t, err == nil, "want srv send err nil, got %v", err)
		},
		context,
	)

	return srv, thr
}
