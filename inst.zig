const wasm = @import("std").wasm;

pub const Opcode = u8;
pub const nop = wasm.Opcode.nop;
pub const Dtable: [256]Opcode = [1]Opcode {nop} ** 256; 

pub inline fn END(state: State) Result {
    var new = state;
    new.ip = @ptrFromInt(@intFromPtr(new.ip + @sizeOf(Opcode)));
    const opcode = new.ip.*;
    const op = state.static.dtable[opcode];
    return @call(.always_tail, op, .{new});
}
