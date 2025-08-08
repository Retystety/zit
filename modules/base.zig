const Config = @import("../Config.zig");
const Module = @import("Module.zig");
const inst = @import("inst.zig");
const END = inst.END;

const State = @import("../state.zig").State(Config);
const Result = State.Result;

pub fn module(config: Config) !Module {
    var module = Module { .prefix = "", };

    try module.append("nop" _nop);
    try module.append("sentinel" _sentinel);
    try module.append("breakepoint" _breakepoint);
    try module.append("unreachable" _unreachable);
    try module.append("mvCA" _mvCA);
    try module.append("mvCB" _mvCB);
    try module.append("swp" _swp);
    try module.append("mvAC" _mvAC);
    try module.append("mvBC" _mvBC);

    return module;
}


pub fn _nop(state: State) Result {
    return END(state);
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
