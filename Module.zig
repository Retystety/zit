const Module = @This();

const inst = @import("inst.zig");
const Opcode = inst.Opcode;
const Memo = inst.Memo;
const Operation = inst.Operation;
const DTable = inst.DTable; 

prefix: []const u8,

len: u8 = 0,
memo: Memo = undefined,
dtable: DTable = undefined,

pub const Err = error {
    len,
}

pub fn fmt(comptime prefix []const u8, comptime ins: [:0]const u8) [:0]u8 {
    return prefix ++ ins;
}

pub fn append(self: *Module, ins: [:0]const u8, op: Operation) !void {
    if (self.len >= 256) return Err.len;
    self.memo[self.len] = ins;
    self.dtable[self.len] = op;
}
