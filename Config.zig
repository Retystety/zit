const Config = @This();

const width_ns = @import("width.zig");
const Width = width_ns.Width;

width: Width = .x32,
float: bool = false,
simd: bool = false,
atomic: bool = false,

min_mem_size: u16 = 1,
max_mem_size: u16 = 0, // 0 == inf

pub fn UWord(self: *const Config) type {
    return width_ns.UInt(self.width);    
}

pub fn SWord(self: *const Config) type {
    return width_ns.SInt(self.width);
}

pub fn Float(self: *const Config) type {
    return if (self.float) f32 else void;
}

pub fn Double(self: *const Config) type {
    return if (self.float)
        switch (self.width) {
            .x32 => void,
            .x64 => f64,  
        }
    else void;
}

pub fn alignOf(self: *const Config) usize {
    return width_ns.alignOf(self.width);
}
