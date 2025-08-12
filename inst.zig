const Config = @import("Config.zig");
const wasm = @import("std").wasm;

pub fn Inst(comptime State: type) type { return struct {
    const Self = @This();

    const Result = State.Result;
    const Opcode = State.Opcode;

    pub const Operation = *const fn(state: State) Result;

    name: []const u8,
    operation: Operation,

    pub fn init(name: []const u8, operation: Operation) Self {
        return Self { .name = name, .operation = operation, };
    }

    pub inline fn END(state: State) Result {
        var new = state;
        new.ip = new.ip + @sizeOf(Opcode);
        const opcode_ptr: *const Opcode = @ptrFromInt(new.ip);
        const opcode = opcode_ptr.*;
        const op: Operation = @ptrFromInt(state.static.dtable[opcode]);
        //compiler bug
        return @call(.auto, op, .{new});
    }
};}
