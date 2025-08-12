const Config = @import("Config.zig");
const Width = @import("width.zig").Width;

const Type = @import("std").builtin.Type;
const EnumField = Type.EnumField;
const Enum = Type.Enum;

pub fn ISA(comptime config: Config) type { return struct {
    const Self = @This();

    const Module = @import("module.zig").Module(config);

    const State = @import("state.zig").State(config);
    const Opcode = State.Opcode;
    const dt_size = State.dt_size;
    const DTable = State.DTable;

    const Inst = @import("inst.zig").Inst(State);

    modules: []const Module,

    //pub fn init(config: Config) Self {}

    pub fn module(comptime mod: Module.Err!Module) Module {
        return mod catch @compileError("module to big");
    }
};}

test "base module" {
    _ = ISA(Config {}).module(@import("modules/base.zig").Make(Config {}).module());
}

//test "int module" {
//    _ = module(@import("modules/int.zig").module(Config {}, Width.x32));
//}
