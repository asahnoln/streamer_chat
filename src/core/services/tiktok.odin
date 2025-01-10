package services

import "core:encoding/xml"
import "core:log"
import "src:core"

tiktok_get_messages :: proc(rec_p: core.Req_Proc) -> []core.Message {
	resp := rec_p("https://tiktok.com/@asahnoln/live")

	error_handler := proc(pos: xml.Pos, msg: string, args: ..any) {
		log.errorf("%s(%d:%d) ", pos.file, pos.line, pos.column)
		log.errorf(msg, ..args)
	}
	d, err := xml.parse_string(resp, error_handler = error_handler)
	if err != nil {
		// log.errorf("error parsing: %v, doc: %v", err, d.tokenizer.err)
		defer xml.destroy(d)
		return nil
	}
	defer xml.destroy(d)

	ms := make([]core.Message, 1)
	ms[0].text = "tiktok reply!"

	return ms
}
