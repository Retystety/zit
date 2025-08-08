const Config = @import("Config.zig");
const Width = @import("width.zig").Width;

const inst = @import("inst.zig");
const Opcode = inst.Opcode;
const maxOpcode = inst.maxOpcode;

const Type = @import("std").builtin.Type;
const EnumField = Type.EnumField;
const Enum = Type.Enum;

pub const Err = error {
    size,  
};

pub fn ISA(config: Config = Config {}) !type {
    const modules = [_]Module {
        @import("base.zig").module,
        @import("int.zig").Int(config, .x32).module;         
    };

    const size: usize = 0;
    for (modules) |module| { size += module.instrs.len; }
    if (size > maxOpcode) return Err.size;

    
}
