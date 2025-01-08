package core

Message :: struct {
	text: string,
}

Service_Proc :: #type proc(rec_p: Req_Proc) -> []Message

Req_Proc :: #type proc(url: string) -> string

empty_req_p :: proc(url: string) -> string {return ""}

// FIX: Remove empty_req_p
get_last_messages :: proc(procs: []Service_Proc, req_p := empty_req_p) -> []Message {
	if len(procs) == 0 {
		return nil
	}

	res := make([dynamic]Message)

	for p in procs {
		ms := p(req_p)
		defer delete(ms)

		append(&res, ..ms)
	}

	return res[:]
}
