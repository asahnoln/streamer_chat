package main

import mu "vendor:microui"
import rl "vendor:raylib"

main :: proc() {
	rl.InitWindow(800, 600, "Streamer Chat")
	defer rl.CloseWindow()

	ctx := new(mu.Context)
	mu.init(ctx)

	ctx.text_width = mu.default_atlas_text_width
	ctx.text_height = mu.default_atlas_text_height

	// Loop start
	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		defer rl.EndDrawing()

		// TODO: Handle input

		mu.begin(ctx)
		defer mu.end(ctx)

		if !mu.window(ctx, "Streamer Chat", mu.Rect{10, 10, 200, 400}) {
			continue
		}

		cmd := new(mu.Command)

		for variant in mu.next_command_iterator(ctx, &cmd) {
			switch v in variant {
			case ^mu.Command_Text:
			case ^mu.Command_Rect:
			case ^mu.Command_Jump:
			case ^mu.Command_Clip:
			case ^mu.Command_Icon:
			}
		}

		mu.text(ctx, "This is a test")
	}
}
