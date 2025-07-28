const Config = @import("../Config.zig");
const inst = @import("inst.zig");
const END = inst.END;

pub fn Base(config: Config) type {
    const State = @import("../state.zig").State(Config);
    const Result = State.Result;

    pub fn _sentinel(state: State) Result {
        return state.result(._sentinel);
    }

    pub fn _breakepoint(state: State) Result {
        return state.result(._breakpoint);
    }

    pub fn _mvRA(state: State) Result {
        var new = state;
        new.ra = new.rr;
        return END(new);
    }

    pub fn _mvRB(state: State) Result {
        var new = state;
        new.rb = new.rr;
        return END(new);
    }

    pub fn _swp(state: State) Result {
        var new = state;
        const t = new.ra;
        new.ra = new.rb;
        new.rb = t;
        return END(new);
    }

    pub fn _mvAR(state: State) Result {
        var new = state;
        new.rr = new.ra;
        return END(new);
    }

    pub fn _mvBR(state: State) Result {
        var new = state;
        new.rr = new.rb;
        return END(new);
    }
}
