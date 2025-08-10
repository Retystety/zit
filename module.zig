const Config = @import("Config.zig");
const EnumField = @import("std").builtin.Type.EnumField;

pub fn Module(config: Config) type { return struct {
    const Self = @This();

    const inst = @import("inst.zig").inst(config);
    const Inst = inst.Inst;
    const Opcode = inst.Opcode;
    const dt_size = inst.dt_size;
    const DTable = inst.DTable;

    prefix: []const u8,
    len: usize = 0,
    instrs: []const Inst = [0]Inst { }, 

    pub const Err = error {
        ModuleToBig,
    };

    pub fn init(prefix: []const u8, instrs: []const Inst) !Module {
        if (instrs.len > dt_size) return Err.ModuleToBig;
        return Self { .prefix = prefix, .instrs = instrs, };    
    }

    pub fn opcodes(comptime self: *const Self) []const EnumField {
        var fields: [self.len]EnumField = undefined; 
        for (self.instrs, 0..) |instruction, i| {
            fields[i] = EnumField { .name = self.prefix ++ instruction.name, .value = i, };
        }
        return fields;
    }

    pub fn dtable(comptime self: *const Self) DTable {
        var dt: DTable = undefined;
        for (self.instrs, 0..) |instruction, i| {
            dt[i] = instruction.operation;
        }
        return dt;
    }
};}
