const std = @import("std");
const Config = @import("Config.zig");
const wasm = std.wasm;
const Allocator = std.mem.Allocator;

pub fn Memory(comptime config: Config) type { return struct {
    const Self = @This();
    
    pub const Page = [wasm.page_size] u8;

    pages: std.SegmentedList(Page, config.min_mem_size),
    allocator: Allocator,

//     pub fn init() Self {}
//     pub fn dinit() void {}
// 
//     pub fn ld() T {}
//     pub fn st() !void {}
// 
//     pub fn grow() !void {}
//     pub fn shrink() !void {}
// 
//     pub fn memset() !void {}
//     pub fn memcpy() !void {}
};}
