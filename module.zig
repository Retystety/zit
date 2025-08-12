const Config = @import("Config.zig");
const EnumField = @import("std").builtin.Type.EnumField;

pub fn Module(config: Config) type { return struct {
    const Self = @This();

    //const inst = @import("inst.zig").inst(@import("state.zig").State(config));
    const State = @import("state.zig").State(config);
    const Inst = @import("inst.zig").Inst(State);
    const Opcode = State.Opcode;
    const dt_size = State.dt_size;
    const DTable = State.DTable;

    prefix: []const u8,
    instrs: []const Inst, 

    pub const Err = error {
        ModuleToBig,
    };

    pub fn init(prefix: []const u8, instrs: []const Inst) !Self {
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
