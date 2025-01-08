package services

import "core:encoding/json"
import "core:log"
import "src:core"

tiktok_get_messages :: proc(rec_p: core.Rec_P) -> []core.Message {
	resp := rec_p("")
	j: struct {
		data: []core.Message,
	}

	err := json.unmarshal_string(resp, &j)
	if err != nil {
		log.errorf("Unmarshal error %v", err)
	}

	ms := make([]core.Message, 1)
	copy(ms, j.data)
	delete(j.data)

	return ms
}
