package services_test

import "core:net"
import "core:testing"
import "src:core"
import "src:core/services"

@(test)
twitch_implements_Service_Proc :: proc(t: ^testing.T) {
	p: core.Service_Proc = services.twitch_get_messages
}

// FIX: Test is not actual, need to use WebScoket and return proper answer
// @(test)
twitch_messages :: proc(t: ^testing.T) {
	p := proc(url: string) -> string {
		// TODO: Expect proper url and return mock data
		return `{data: [{text: "OY!"}]}`
	}

	got := services.twitch_get_messages(p)
	defer delete(got)

	testing.expect_value(t, len(got), 1)
	testing.expect_value(t, got[0].text, "has to be real twitch connection!")
	delete(got[0].text)
}
