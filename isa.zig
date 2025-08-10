const Config = @import("Config.zig");
const Module = @import("Module.zig");
const Width = @import("width.zig").Width;

const inst = @import("inst.zig");
const Opcode = inst.Opcode;
const maxOpcode = inst.maxOpcode;

const Type = @import("std").builtin.Type;
const EnumField = Type.EnumField;
const Enum = Type.Enum;

fn module(mod: Module.Err!Module) Module {
    return mod catch @compileError("module to big");
}

pub fn ISA(config: Config) type {
    const modules = [_]Module {
        module("base", void),
        module("int", .{ config, Width.x32, }),         
    };

    return modules;
}

test "base module" {
    _ = module(@import("modules/base.zig").module());
}

test "int module" {
    _ = module(@import("modules/int.zig").module(Config {}, Width.x32));
}

