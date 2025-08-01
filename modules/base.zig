const Config = @import("../Config.zig");
const inst = @import("inst.zig");
const END = inst.END;

pub fn Base(config: Config) type { return struct {
    const State = @import("../state.zig").State(Config);
    const Result = State.Result;

    pub fn _sentinel(state: State) Result {
        return state.result(._sentinel);
    }

    pub fn _breakepoint(state: State) Result {
        return state.result(._breakpoint);
    }

    pub fn _unreachable(state: State) Result {
            return state.result(._unreachable);
    }

    pub fn _mvCA(state: State) Result {
        var new = state;
        new.ra = new.rc;
        return END(new);
    }

    pub fn _mvCB(state: State) Result {
        var new = state;
        new.rb = new.rc;
        return END(new);
    }

    pub fn _swp(state: State) Result {
        var new = state;
        const t = new.ra;
        new.ra = new.rb;
        new.rb = t;
        return END(new);
    }

    pub fn _mvAC(state: State) Result {
        var new = state;
        new.rc = new.ra;
        return END(new);
    }

    pub fn _mvBC(state: State) Result {
        var new = state;
        new.rc = new.rb;
        return END(new);
    }
};}
