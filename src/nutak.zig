const std = @import("std");
const testing = std.testing;

const atak = @import("atak");
//const nuklear = @import("nuklear");

pub fn sayHello() void {
    std.debug.print("Saying hello", .{});
    const parser = atak.efus.Parser.init(std.heap.page_allocator, "<string>", "Window title=\"Hello Window\"");
    std.debug.print("Done {any}", .{parser});
}

pub fn main() void {
    sayHello();
}
