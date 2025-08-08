const wasm = @import("std").wasm;
const State = @import("State.zig");
const Result = State.Result;

pub const Opcode = u8;
pub const maxOpcode: Opcode = 256;
pub const Operation: type = *const fn(state: State) Result;
pub const Dtable: type = [maxOpcode]Operation;

pub const Inst = struct {
    name: []const u8,
    operation: Operation,

    pub fn init(name: []const u8, operation: Operation) Inst {
        return Inst { .name = name, .operation = oeration, };
    }
}

pub inline fn END(state: State) Result {
    var new = state;
    new.ip = @ptrFromInt(@intFromPtr(new.ip + @sizeOf(Opcode)));
    const opcode = new.ip.*;
    const op = state.static.dtable[opcode];
    return @call(.always_tail, op, .{new});
}
