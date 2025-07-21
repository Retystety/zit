const wasm = @import("std").wasm;
pub const Opcode = @typeInfo(wasm.Opcode).tag_type;
pub const eoc = wasm.Opcode.@"unreachable";

pub inline fn END_INST(state: State) Result {
    var new = state;
    new.ip = @ptrFromInt(@intFromPtr(new.ip + @sizeOf(Opcode)));
    const opcode = new.ip.*;
    const op = state.static.*.dtable[opcode];
    return @call(.always_tail, op, .{new});
}
