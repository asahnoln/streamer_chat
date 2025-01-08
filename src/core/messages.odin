package core

Message :: struct {
	text: string,
}

Service_Proc :: #type proc(rec_p: Rec_P) -> []Message

Rec_P :: #type proc(url: string) -> string

empty_rec_p :: proc(url: string) -> string {return ""}

// FIX: Remove empty_rec_p
get_last_messages :: proc(procs: []Service_Proc, rec_p := empty_rec_p) -> []Message {
	if len(procs) == 0 {
		return nil
	}

	res := make([dynamic]Message)

	for p in procs {
		ms := p(rec_p)
		defer delete(ms)

		append(&res, ..ms)
	}

	return res[:]
}
