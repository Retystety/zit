const std = @import("std");
const Config = @import("Config.zig");
const wasm = std.wasm;
const Allocator = std.mem.Allocator;

pub fn Memory(config: Config = Config .{}) type {
    return struct {
        pub const Page = [wasm.page_size] align(config.alignOf()) u8;

        pages: std.SegmentedList(Page, config.min_mem_size),
    };
}
