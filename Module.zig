const Module = @This();

const inst = @import("inst.zig");
const Inst = inst.Inst;
const Opcode = inst.Opcode;
const maxOpcode = inst.maxOpcode;
const Memo = inst.Memo;
const Operation = inst.Operation;
const DTable = inst.DTable; 

prefix: []const u8,
instrs: []const Inst,

pub fn fmt(comptime prefix []const u8, comptime name: []const u8) []u8 {
    return prefix ++ ins;
}
