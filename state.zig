const Config = @import("Config.zig");
const width = @import("width.zig");

pub fn State(comptime config: Config) type {
    return struct {
        const Self  = @This();

        const UWord = config.UWord();
        const Float = config.Float();
        const Double = config.Double();

        const inst = @import("inst.zig").inst(config);
        const Opcode = inst.Opcode;
        const DTable = inst.DTable;
        
        const Memory =  @import("memory.zig").Memory(config);

        pub const Operation: type = *const fn(state: Self) Self.Result;

        pub inline fn END(state: State) Result {
            var new = state;
            new.ip = @ptrFromInt(@intFromPtr(new.ip + @sizeOf(Opcode)));
            const opcode = new.ip.*;
            const op = state.static.dtable[opcode];
            return @call(.always_tail, op, .{new});
        }
            
        pub const Static = struct {
            globals: []align(config.alignOf()) u8,
            stack_bgn: usize,
            stack_end: usize,
            memory: Memory,
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
            
            ip: *const Opcode,
            
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
        
        pub fn result(self: Self, r_type: ResultType) Result {
            return Result { 
                .r_type = r_type,
                .ip = self.ip,
                
                .ra = self.ra,
                .rb = self.rb,
                .rc = self.rc,

                .fa = self.fa,
                .fb = self.fb,
                .fc = self.fc,

                
                .da = self.da,
                .db = self.db,
                .dc = self.dc,   
            };
        }

        // pub fn init(code: []const Opcode, stack: []align(config.alignOf()) u8, memory: Memory(config), dtable: [*]usize) Self {
        //     return Self {};
        // }

        pub inline fn ld(self: *const Self, ptr: UWord, T: type) T {
            return self.static.memory.ld(ptr, T);
        }
        
        pub inline fn st(self: *const Self, ptr: UWord, val: UWord) void {
            return self.static.memory.st(ptr, val);
        }

        pub const stackErr = error {
            undeflow,
            overflow,
        };

        pub inline fn pop(self: *Self, len: usize) stackErr!void {
            const sp = self.sp -| len;
            if (sp <= self.static.stack_bgn) return stackErr.underflow;
            self.sp = sp;
        }

        pub inline fn push(self: *Self, len: usize) stackErr!void {
            const sp = self.sp +| len;
            if (sp >= self.static.stack_endlow) return stackErr.overflow;
            self.sp = sp;
        }

        pub inline fn get(self: *const Self, ptr: UWord, T: type) T {
            const _ptr: *const T = @ptrFromInt(self.sp - ptr); 
            return _ptr.*;
        }

        pub inline fn set(self: *const Self, ptr: UWord, val: anyopaque) void {
            const _ptr: *val = @ptrFromInt(self.sp - ptr);
            _ptr.* = val;
        }
        
        pub inline fn lGet(self: *const Self, off: UWord, T: type) T {
            return self.get(self.sp - off, T); 
        }
        
        pub inline fn lSet(self: *const Self, off: UWord, val: anyopaque) void {
            self.set(self.sp - off, val);
        }

        pub inline fn gGet(self: *const Self, ptr: UWord, T: type) T {
            return self.static.memory.ld(ptr, T);
        }
        
        pub inline fn gSet(self: *const Self, ptr: UWord, val: anyopaque) void {
            return self.static.memory.st(ptr, val);
        }
    };
}
