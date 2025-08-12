const Config = @import("../Config.zig");
const width = @import("../width.zig");

pub fn module(comptime config: Config, comptime size: width.Width) anytype {
    return Int(config, size).mkModule();
}

pub fn Make(comptime config: Config, comptime size: width.Width) type { return struct {
    const Module = @import("../module.zig").Module(config);

    const Word = Config.UInt(config.width);
    const UInt = Config.UInt(size);
    const SInt = Config.SInt(size);
    const ShInt = Config.ShInt(size);

    const State = @import("../state.zig").State(Config);
    const Result = State.Result;
    const Opcode = State.Opcode;

    const Inst = @import().Inst;
    const END = State.END;

    pub fn module() !Module { 
        return Module.init("i" ++ width.prefix(size) ++ "_", [_]Inst {
            Inst.init("const", _const),

            Inst.init("getA", _getA),
            Inst.init("getA", _getB),
            Inst.init("getC", _getC),
            Inst.init("set", _set),

            Inst.init("lGetA", _lGetA),
            Inst.init("lGetB", _lGetB),
            Inst.init("lGetC", _lGetC),
            Inst.init("lSet", _lSet),

            Inst.init("gGetA", _gGetA),
            Inst.init("gGetB", _gGetB),
            Inst.init("gGetC", _gGetC),
            Inst.init("gSet", _gSet),

            Inst.init("and", _and),
            Inst.init("or", _or),
            Inst.init("xor", _xor),

            Inst.init("shl", _shl),
            Inst.init("shr_u", _shr_u),
            Inst.init("shr_s", _shr_s),

            Inst.init("clz", _clz),
            Inst.init("ctz", _ctz),

            Inst.init("rotl", _rotl),
            Inst.init("rotr", _rotr),

            Inst.init("add", _add),
            Inst.init("sub", _sub),
            Inst.init("mul", _mul),

            Inst.init("div_u", _div_u),
            Inst.init("div_s", _div_s),

            Inst.init("rem_u", _rem_u),
            Inst.init("rem_s", _rem_s),
        });

    inline fn fromWord(word: Word) UInt {
            return @turncate(word);
    }
    
    inline fn toWord(int: UInt) Word {
            return @intCast(int);
    }

    pub fn _const(state: State) Result {
        var new = state;
        const ip = @intFromPtr(new.ip);
        new.rc = toWord(@ptrFromInt(ip + @sizeOf(Opcode)));
        new.ip = @ptrFromInt(ip + @sizeOf(UInt));
        return END(new);
    }

    pub fn _getA(state: State) Result {
        var new = state;
        new.ra = fromWord(new.get(new.rc, UInt));
        return END(new);
    }
        
    pub fn _getB(state: State) Result {
        var new = state;
        new.rb = toWord(new.get(new.rc, UInt));
        return END(new);
    }
    
    pub fn _getC(state: State) Result {
        var new = state;
        new.rc = toWord(new.get(new.rc, UInt));
        return END(new);
    }
    
    pub fn _set(state: State) Result {
        const val: UInt = fromWord(state.ra);
        state.set(state.rc, val);
        return END(state);
    }

    pub fn _lGetA(state: State) Result {
        var new = state;
        new.ra = toWord(new.lGet(new.rc, UInt));
        return END(new);
    }
    
    pub fn _lGetB(state: State) Result {
        var new = state;
        new.rb = toWord(new.lGet(new.rc, UInt));
        return END(new);
    }

    pub fn _lGetC(state: State) Result {
        var new = state;
        new.rc = toWord(new.lGet(new.rc, UInt));
        return END(new);
    }

    pub fn _lSet(state: State) Result {
        const val: UInt = fromWord(state.ra);
        state.lSet(state.rc, val);
        return END(state);
    }

    pub fn _gGetA(state: State) Result {
        var new = state;
        new.ra = toWord(new.gGet(new.rc, UInt));
        return END(new);
    }
    
    pub fn _gGetB(state: State) Result {
        var new = state;
        new.rb = toWord(new.gGet(new.rc, UInt));
        return END(new);
    }

    pub fn _gGetC(state: State) Result {
        var new = state;
        new.rc = toWord(new.gGet(new.rc, UInt));
        return END(new);
    }

    pub fn _gSet(state: State) Result {
        const val: UInt = formWord(state.ra);
        state.lSet(state.rc, val);
        return END(state);
        
    }

    inline fn operator(state: State, op: *const fn (a: UInt, b: UInt) UInt) Result {
        var new = state;
        new.rc = toWord(op(fromWord(new.ra), fromWord(new.rb)));
        return END(new);
    }

    inline fn sgnOperator(state: State, op: *const fn (a: SInt, b: SInt) SInt) Result {
        var new = state;
        new.rc = toWord(@bitCast(op(@bitCast(fromWord(new.ra)), @bitCast(fromWord(new.rb)))));
        return END(new);
    }

    inline fn op_and(a: UInt, b: UInt) UInt {return a & b;}
    pub fn _and(state: State) Result {
        return operator(state, op_and);
    }

    inline fn op_or(a: UInt, b: UInt) UInt {return a | b;}
    pub fn _or(state: State) Result {
        return operator(state, op_or);
    }

    inline fn op_xor(a: UInt, b: UInt) UInt {return a ^ b;}
    pub fn _xor(state: State) Result {
        return operator(state, op_xor);
    }

    inline fn shift(state: State, op: *const fn (a: UInt b: ShInt) UInt) Result {
        var new = state;
        const a: UInt = fromWord(new.ra);
        const b: ShInt = @turncate(new.rb);
        new.rc = toWord(op(a, b));
        return END(new);
    }
    

    inline fn op_shl(a: UInt, b: ShInt) UInt {return a << b;}
    pub fn _shl(state: State) Result {
        return shift(state, op_shl);
    }
    
    inline fn op_shr_u(a: UInt, b: ShInt) UInt {return a >> b;}
    pub fn _shr_u(state: State) Result {
        return shift(state, op_shr_u);
    }

    inline fn op_shr_s(a: UInt, b: ShInt) SInt {
        const mask: SInt = width.sgnMask(UInt);
        const sgn = a & mask;
        var r = a >> b;
        r |= mask
        return r;
    }
    pub fn _shr_s(state: State) Result {
        return sgnOperator(state, op_shr_s);
    }
    
    pub fn _clz(state: State) Result {
        var new = state;
        new.rc = @clz(new.ra);
        return END(new);
    }

    pub fn _ctz(state: State) Result {
        var new = state;
        new.rc = @ctz(new.ra);
        return END(new);
    }

    pub fn _rotl(state: State) Result {
        var new = state;
        new.rc = @import("std").math.rotl(new.ra, new.rb);
    }

    pub fn _rotr(state: State) Result {
        var new = state;
        new.rc = @import("std").math.rotr(new.ra, new.rb);
    }

    inline fn op_add(a: UInt, b: UInt) UInt {return a + b;}
    pub fn _add(state: State) Result {
        return operator(state, op_add);
    }

    inline fn op_sub(a: UInt, b: UInt) UInt {return a - b;}
    pub fn _sub(state: State) Result {
        return operator(state, op_sub);
    }

    inline fn op_mul(a: UInt, b: UInt) UInt {return a * b;}
    pub fn _mul(state: State) Result {
        return operator(state, op_mul);
    }

    inline fn op_div_u(a: UInt, b: UInt) UInt {return a / b;}
    pub fn _div_u(state: State) Result {
        return operator(state, op_div_u);
    }
    
    inline fn op_div_s(a: SInt, b: SInt) SInt {return a / b;}
    pub fn _div_s(state: State) Result {
        return sgnOperator(state, op_div_s);
    }

    inline fn op_rem_u(a: UInt, b: UInt) UInt {return a % b;}
    pub fn _rem_u(state: State) Result {
        return operator(state, op_rem_u);
    }

    inline fn op_rem_s(a: SInt, b: SInt) SInt {return a % b;}
    pub fn _rem_s(state: State) Result {
        return sgnOperator(state, op_rem_s);
    } 
    
};}
