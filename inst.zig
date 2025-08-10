const Config = @import("Config.zig");
const wasm = @import("std").wasm;

pub fn inst(comptime config: Config) type { return struct {
    const State = @import("state.zig").State(config);
    const Result = State.Result;

    pub const Opcode = u8;
    pub const dt_size: usize = 256;
    pub const DTable: type = [dt_size]Operation;

    pub const Inst = struct {
        name: []const u8,
        operation: Operation,

        pub fn init(name: []const u8, operation: Operation) Inst {
            return Inst { .name = name, .operation = operation, };
        }
    };
};}
