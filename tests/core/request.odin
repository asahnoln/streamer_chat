package core_test

import "core:log"
import "core:net"
import "core:testing"
import "core:thread"
import "src:core"

@(test)
request :: proc(t: ^testing.T) {
	rp: core.Req_Proc = core.http_req_proc
	got, want := rp("http://localhost/test"), "test data"
	testing.expect_value(t, got, want)
}
