const Module = @This();

const inst = @import("inst.zig");
const Inst = inst.Inst;
const Opcode = inst.Opcode;
const dt_size = inst.dt_size;
const Operation = inst.Operation;
const DTable = inst.DTable;
const EnumField = @import("std").builtin.Type.EnumField;

prefix: []const u8,
instrs: []const Inst,

pub const Err = error {
    ModuleToBig,
};

pub fn init(prefix: []const u8, instrs: []const Inst) !Module {
    if (instrs.len > maxOpcode) return 
    return Module { .prefix = prefix, .instrs = instrs, };
}

pub fn enumFields(self: *const Module) []const EnumField {
    
}
