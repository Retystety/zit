const Config = @import("Config.zig");
const inst = @import("inst.zig");
const Opcode = inst.Opcode;
const DTable = inst.DTable;
const Memory =  @import("memory.zig").Memory;

pub fn State(config: Config) type {
    return struct {
        const State = @This();

        const UWord = Config.UWord(config.width);
        const Float = Config.Float(config.float);
        const Double = Config.Double(config.float, config.width);

        pub const Op = *const fn (state: State) Result;
           
        pub const Static = struct {
            globals: []u8,
            stack_bgn: usize,
            stack_end: usize,
            memory: Memory(config),
            dtable: DTable,
            fn_table: []UWord,
            jmp_table: []UWord,
        };
        
        ra: UWord = 0,
        rb: UWord = 0,
        rc: UWord = 0,

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
            _illegal,
            _sentinel,
            
            _breakpoint,
            _unreachable,

            _stack_underflow,
            _stack_overflow,
        
            _div_by_zero,
        };
        
        pub const Result = struct {
            r_type: ResultType,
            payload: usize,
            
            ip: IPtr,
            
            ra: UWord,
            rb: UWord,
            rc: UWord,

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

        pub fn init(code: []const Opcode, stack: []align(config.alignOf(UWord) u8), memory: Memory(Config), dtable: [*]usize) State {};

        pub inline fn ld(state: *const State, ptr: UWord, T: type) T {
            return state.static.memory.ld(ptr, T);
        }
        
        pub inline fn st(state: *const State, ptr: UWord, val: UWord) void {
            return state.static.memory.st(ptr, val);
        }

        pub const stackErr = error {
            undeflow,
            overflow,
        };

        pub inline fn pop(state: *State, len: usize) stackErr!void {
            const sp = state.sp -| len;
            if (sp <= state.static.stack_bgn) return stackErr.underflow;
            state.sp = sp;
        }

        pub inline fn push(state: *State, len: usize) stackErr!void {
            const sp = state.sp +| len;
            if (sp >= state.static.stack_endlow) return stackErr.overflow;
            state.sp = sp;
        }

        pub inline fn get(state: *const State, ptr: UWord, T: type) T {
            const ptr: *const T = @ptrFromInt(ptr); 
            return ptr.*;
        }

        pub inline fn set(state: *const State, ptr: UWord, val: anyopaque) void {
            const ptr: *T = @ptrFromInt(ptr);
            ptr.* = val;
        }
        
        pub inline fn lGet(state: *const State, off: UWord, T: type) T {
            return state.get(state.sp - off, T); 
        }
        
        pub inline fn lSet(state: *const State, off: UWord, val: anyopaque) void {
            state.set(state.sp - off, val);
        }

        pub inline fn gGet(state: *const State, ptr: UWord, T: type) T {
            return state.static.memory.ld(ptr, T);
        }
        
        pub inline fn gSet(state: *const State, ptr: UWord, val: anyopaque) void {
            return state.static.memory.st(ptr, val);
        }
    };
}
