const Config = @This();

const Width = enum {
    x32,
    x64,    
}

width: Width = .x32,
float: bool = false,
simd: bool = false,
atomic: bool = false,

min_mem_size: u16 = 1,
max_mem_size: u16 = 0,
   
pub fn UInt(config: *const Config) type {
    return switch (config.width) {
        .x32 => u32,
        .x64 => u64,  
    };
}

pub fn alignOf(config: *const Config) type {
    return switch (config.width) {
        .x32 => @alignOf(u32),
        .x64 => @alignOf(u64),  
    };
}

pub fn SInt(config: *const Config) type {
    return switch (config.width) {
        .x32 => i32,
        .x64 => i64,  
    };
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
