const wasm = @import("std").wasm;
const State = @import("State.zig");
const Result = State.Result;

pub const Opcode = u8;
pub const Memo: type = [256][:0]const u8;
pub const Operation: type = *const fn(state: State) Result;
pub const Dtable: type = [256]Operation;

pub inline fn END(state: State) Result {
    var new = state;
    new.ip = @ptrFromInt(@intFromPtr(new.ip + @sizeOf(Opcode)));
    const opcode = new.ip.*;
    const op = state.static.dtable[opcode];
    return @call(.always_tail, op, .{new});
}
