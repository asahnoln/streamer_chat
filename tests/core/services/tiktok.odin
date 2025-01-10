package services_test

import "core:net"
import "core:testing"
import "src:core"
import "src:core/services"

@(test)
tiktok_implements_Service_Proc :: proc(t: ^testing.T) {
	p: core.Service_Proc = services.tiktok_get_messages
}

// FIX: Have to find source of a real data instead of html scraping
@(test)
tiktok_messages :: proc(t: ^testing.T) {
	@(static) test: ^testing.T
	test = t
	req_p := proc(url: string) -> string {
		testing.expect_value(test, url, "https://tiktok.com/@asahnoln/live")
		html := #load("./testdata/tiktoklive.html")
		return cast(string)html
	}

	srv_p: core.Service_Proc = services.tiktok_get_messages
	got := srv_p(req_p)
	defer delete(got)

	testing.expect_value(t, len(got), 1)
	testing.expect_value(t, got[0].text, "tiktok reply!")
	delete(got[0].text)
}
