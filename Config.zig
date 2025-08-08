const Config = @This();

const width = @import("width.zig");
const Width = width.Width;

width: Width = .x32,
float: bool = false,
simd: bool = false,
atomic: bool = false,

min_mem_size: u16 = 1,
max_mem_size: u16 = 0, // 0 == inf

pub fn UWord(config: *const Config) type {
    return width.UInt(config.width);    
}

pub fn SWord(config: *const Config) type {
    return width.SInt(config.width);
}

pub fn Float(config: *const Config) type {
    if (config.float) f32 else void;
}

pub fn Double(config: *const Config) type {
    return if (config.float)
        switch (config.width) {
            .x32 => void,
            .x64 => f64,  
        }
    else void;
}


