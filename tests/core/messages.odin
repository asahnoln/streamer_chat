package core_test

import "core:testing"
import "src:core"

@(test)
get_messages :: proc(t: ^testing.T) {
	ss := []core.Service_Proc {
		// Format
		proc(_: core.Rec_P) -> []core.Message {
			ms := make([]core.Message, 1)
			ms[0] = {
				text = "Hello",
			}

			return ms
		},
		proc(_: core.Rec_P) -> []core.Message {
			ms := make([]core.Message, 1)
			ms[0] = {
				text = "Bye",
			}

			return ms
		},
	}

	got := core.get_last_messages(ss)
	defer delete(got)

	testing.expect_value(t, len(got), 2)
	testing.expect_value(t, got[0].text, "Hello")
	testing.expect_value(t, got[1].text, "Bye")
}

@(test)
no_messages_from_no_services :: proc(t: ^testing.T) {
	got := core.get_last_messages(nil)
	testing.expect_value(t, len(got), 0)
}
