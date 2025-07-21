const Config = @import("Config.zig");
const inst = @import("inst.zig");
const Opcode = inst.Opcode;
const eoc = inst.Opcode;
const Memory =  @import("memory.zig").Memory;

pub fn State(config: Config = Config .{}) type {
    return struct {
        const State = @This();

        const Float = config.Float();
        const Double = config.Double();

        pub const Op = *const fn (state: State) Result;
        
        
        pub const Static = struct {
            globals: []u8,
            stack_low: usize,
            stack_high: usize,
            memory: Memory(config),
            dtable: [*]usize,
        };
        
        ra: UInt = 0,
        rb: UInt = 0,
        rc: UInt = 0,

        fa: Float = 0,
        fb: Float = 0,
        fc: Float = 0,

        da: Double = 0,
        db: Double = 0,
        dc: Double = 0,

        ip: *const Opcode,
        sp: usize,
        
        static: *Static,
        
        pub const ResultType = enum {
            sentinel,
            halt,
            breakpoint,

            stack_underflow,
            stack_overflow,
        
            div_by_zero,
        };
        
        pub const Result = struct {
            r_type: ResultType,
            payload: usize,
            
            ip: IPtr,
            
            ra: UInt,
            rb: UInt,
            rc: UInt,

            fa: Float,
            fb: Float,
            fc: Float,

            da: Double,
            db: Double,
            dc: Double,
        };
        
        pub fn result(state: State, r_type: ResultType) Result {
            return Result { 
                .r_type = r_type,
                .ip = state.ip,
                
                .ra = state.ra,
                .rb = state.rb,
                .rc = state.rc,

                .fa = state.fa,
                .fb = state.fb,
                .fc = state.fc,

                
                .da = state.da,
                .db = state.db,
                .dc = state.dc,   
            };
        }

        pub fn init(code: [:eoc]const Opcode, stack: []align(config.alignOf() u8), memory: Memory(Config), dtable: [*]usize) State {};

        pub inline fn ld(state: *const State, ptr: UInt, T: type) T {
            return state.static.memory.ld(ptr, T);
        }
        
        pub inline fn st(state: *const State, ptr: UInt, val: UInt) void {
            return state.static.memory.st(ptr, val);
        }

        pub const stackErr = error {
            undeflow,
            overflow,
        };

        pub inline fn pop(state: *State, len: usize) stackErr!void {
            const sp = state.sp -| len;
            if (sp <= state.static.stack_low) return stackErr.underflow;
            state.sp = sp;
        }

        pub inline fn push(state: *State, len: usize) stackErr!void {
            const sp = state.sp +| len;
            if (sp >= state.static.stack_high) return stackErr.overflow;
            state.sp = sp;
        }

        pub inline fn lGet(state: *const State, ptr: UInt, T: type) T {
            return state.static.memory.ld(ptr, T);
        }
        
        pub inline fn lSet(state: *const State, ptr: UInt, val: UInt) void {
            return state.static.memory.st(ptr, val);
        }

        pub inline fn gGet(state: *const State, ptr: UInt, T: type) T {
            return state.static.memory.ld(ptr, T);
        }
        
        pub inline fn gSet(state: *const State, ptr: UInt, val: UInt) void {
            return state.static.memory.st(ptr, val);
        }
    };
}
