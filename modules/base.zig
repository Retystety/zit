const Config = @import("../Config.zig");

pub fn Make(comptime config: Config) type { return struct {
    const Module = @import("../module.zig").Module(config);

    const State = @import("../state.zig").State(config);
    const Result = State.Result;

    const Inst = @import("../inst.zig").Inst(State);
    const END = Inst.END;

    pub fn module() !Module {
        return Module.init("", &[_]Inst {             
            Inst.init("nop", _nop),
            
            Inst.init("illegal", _illegal),
            Inst.init("sentinel", _sentinel),
            
            Inst.init("breakepoint", _breakepoint),
            Inst.init("unreachable", _unreachable),
            
            Inst.init("mvCA", _mvCA),
            Inst.init("mvCB", _mvCB),

            Inst.init("mvAC", _mvAC),
            Inst.init("mvBC", _mvBC),
            
            Inst.init("mvAB", _mvAB),
            Inst.init("mvBA", _mvBA),
            Inst.init("swp", _swp),
            
        });
    }

    pub fn _nop(state: State) Result {
        return END(state);
    }

    pub fn _illegal(state: State) Result {
        return state.result(._illegal);
    }

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

    pub fn _mvAB(state: State) Result {
        var new = state;
        new.ra = new.rb;
        return END(new);
    }
    
    pub fn _mvBA(state: State) Result {
        var new = state;
        new.ra = new.rb;
        return END(new);
    }
    
    pub fn _swp(state: State) Result {
        var new = state;
        const t = new.ra;
        new.ra = new.rb;
        new.rb = t;
        return END(new);
    }
    
};}
