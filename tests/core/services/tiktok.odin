package services_test

import "core:net"
import "core:testing"
import "src:core"
import "src:core/services"

@(test)
tiktok_implements_Service_Proc :: proc(t: ^testing.T) {
	p: core.Service_Proc = services.tiktok_get_messages
}

// FIX: Make real tiktok connection
@(test)
tiktok_messages :: proc(t: ^testing.T) {
	p := proc(url: string) -> string {
		return `{data: [{text: "VEY!"}]}`
	}

	got := services.tiktok_get_messages(p)
	defer delete(got)

	testing.expect_value(t, len(got), 1)
	testing.expect_value(t, got[0].text, "has to be real tik tok connection!")
	delete(got[0].text)
}
