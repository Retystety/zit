const std = @import("std");
const print = std.debug.print;


pub fn main() void {
    var len = @typeInfo(std.wasm.Opcode).@"enum".fields.len;
    print("{d} \n", .{len});

    len = @typeInfo(std.wasm.SimdOpcode).@"enum".fields.len;
    print("{d} \n", .{len});

    len = @typeInfo(std.wasm.MiscOpcode).@"enum".fields.len;
    print("{d} \n", .{len});
    
}


