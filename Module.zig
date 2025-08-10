const Module = @This();

const inst = @import("inst.zig");
const Inst = inst.Inst;
const Opcode = inst.Opcode;
const dt_size = inst.dt_size;
const Operation = inst.Operation;
const EnumField = @import("std").builtin.Type.EnumField;

prefix: []const u8,
len: usize = 0,
instrs: []const Inst = [0]Inst { }, 

pub const Err = error {
    ModuleToBig,
};

pub fn init(perfix: []const u8, instrs: []const Inst) !Module {
    if (instrs.len > dt_size) return Err.ModuleToBig;
    return Module { .prefix = prefix, .instrs = instrs, };    
}

pub fn opcodes(comptime self: *const Module) []const EnumField {
    var fields: [self.len]EnumField = undefined; 
    for (module.instrs) |inst, i| {
        fields[i] = EnumField { .name = prefix ++ inst.name, .value = i, };
    }
    return fields;
}

pub fn dTable(comptime self: *const Module) DTable {
    var dtable: [self.len]Operation = undefined;
    for (module.instrs) |inst, i| {
        dtable[i] = inst.operation;
    }
}
