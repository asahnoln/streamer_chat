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

	// TODO: Handle input

	mu.begin(ctx)
	defer mu.end(ctx)

	mu.window(ctx, "Streamer Chat", mu.Rect{10, 10, 200, 400})
	mu.text(ctx, "This is a test")

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		defer rl.EndDrawing()
	}
}
