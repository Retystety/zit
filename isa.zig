const Config = @import("Config.zig");
const Width = @import("width.zig").Width;

const Type = @import("std").builtin.Type;
const EnumField = Type.EnumField;
const Enum = Type.Enum;

pub fn ISA(comptime config: Config) type { return struct {
    const Self = @This();

    const Module = @import("module.zig").Module(config);

    const inst = @import("inst.zig").inst(config);
    const Inst = inst.Inst;
    const Opcode = inst.Opcode;
    const dt_size = inst.dt_size;
    const DTable = inst.DTable;

    modules: []const Module,

    //pub fn init() Self {}

    pub fn module(mod: Module.Err!Module) Module {
        return mod catch @compileError("module to big");
    }
};}

test "base module" {
    _ = ISA(Config {}).module(@import("modules/base.zig").make.module(Config {}));
}

//test "int module" {
//    _ = module(@import("modules/int.zig").module(Config {}, Width.x32));
//}
