pub const Width = enum {
    x32,
    x64,    
};

pub fn prefix(width: Width) []u8 {
    return switch (width) {
        .x32 => "32",
        .x64 => "64",  
    };
}

pub fn UInt(width: Width) type {
    return switch (width) {
        .x32 => u32,
        .x64 => u64,  
    };
}

pub fn SInt(width: Width) type {
    return switch (width) {
        .x32 => i32,
        .x64 => i64,  
    };
}  

pub fn alignOf(width: Width) usize {
    return @alignOf(UInt(width));
}

pub fn ShInt(width: Width) type {
    return switch (width) {
        .x32 => u5,
        .x64 => u6,  
    };
}

pub fn sgnMask(Int: type) Int {
    var mask: Int = 1;
    mask <<= @sizeOf(Int) - 1;
    return mask;
} 

