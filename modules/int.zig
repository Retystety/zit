const Config = @import("../Config.zig");
const inst = @import("inst.zig");
const Opcode = inst.Opcode;
const END = inst.END;

pub fn Int(config: Config, Int: type) type {
    const State = @import("../state.zig").State(Config);
    const Result = State.Result;

    pub fn _imd(state: State) Result {
        var new = state;
        const ip = @intFromPtr(new.ip);
        new.rr = @intCast(@ptrFromInt(ip + @sizeOf(Opcode)));
        new.ip = @ptrFromInt(ip + @sizeOf(Int));
        return END(new);
    }

    pub fn _lGetA(state: State) Result {
        var new = state;
        new.ra = @intCast(@bitCast(new.lGet(new.rr, Int)));
        return END(new);
    }
    
    pub fn _lGetB(state: State) Result {
        var new = state;
        new.rb = @intCast(@bitCast(new.lGet(new.rr, Int)));
        return END(new);
    }

    pub fn _lGetR(state: State) Result {
        var new = state;
        new.rr = @intCast(@bitCast(new.lGet(new.rr, Int)));
        return END(new);
    }

    pub fn _lSet(state: State) Result {
        const val: Int = @turnc(state.ra));
        state.lSet(state.rr, val);
        return END(state);
    }

    pub fn _gGetA(state: State) Result {
        var new = state;
        new.ra = @intCast(@bitCast(new.lGet(new.rr, Int)));
        return END(new);
    }
    
    pub fn _gGetB(state: State) Result {
        var new = state;
        new.rb = @intCast(@bitCast(new.lGet(new.rr, Int)));
        return END(new);
    }

    pub fn _gGetR(state: State) Result {
        var new = state;
        new.rr = @intCast(@bitCast(new.lGet(new.rr, Int)));
        return END(new);
    }

    pub fn _gSet(state: State) Result {
        const val: Int = @turnc(state.ra));
        state.lSet(state.rr, val);
    }
}
