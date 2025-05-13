const std = @import("std");
//const nk = @cImport({
//    @cDefine("NK_IMPLEMENTATION", "1");
//    @cInclude("/home/engon/atak/nutak/libs/nuklear/nuklear.h");
//});
const nk = @import("nuklear.zig");
//nk

pub fn main() !void {
    // Initialize Nuklear context
    var ctx: nk.nk_context = undefined;
    var buf: [1024 * 64]u8 = undefined;

    _ = nk.nk_init_fixed(&ctx, &buf, buf.len, null);

    // Main loop simulation
    var running = true;
    while (running) {
        // Handle window begin return value explicitly
        const win_open = nk.nk_begin(&ctx, "Demo Window", nk.nk_rect(50, 50, 200, 200), nk.NK_WINDOW_BORDER | nk.NK_WINDOW_MOVABLE | nk.NK_WINDOW_SCALABLE);

        if (win_open != 0) {
            // UI elements
            nk.nk_layout_row_static(&ctx, 30, 150, 1);
            if (nk.nk_button_label(&ctx, "Click me!") != 0) {
                std.debug.print("Button clicked!\n", .{});
            }

            var value: f32 = 0.5;
            nk.nk_layout_row_dynamic(&ctx, 30, 1);
            _ = nk.nk_slider_float(&ctx, 0, &value, 1.0, 0.01);
        }

        // Explicitly handle end call
        _ = nk.nk_end(&ctx);

        running = false; // Remove this in real application
    }

    nk.nk_free(&ctx);
}
