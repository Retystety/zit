const Config = @import("Config.zig");
const Width = @import("width.zig").Width;
const maxOpcode = @import("inst.zig").maxOpcode;

pub const Err = error {
    size,  
};

pub fn ISA(config: Config = Config {}) !type {
    const modules = [_]Module {
        @import("base.zig").module,
        @import("int.zig").Int(config, .x32).module;         
    };

    const size: usize = 0;
    for (modules) |module| {
        size += module.len;
    }
    if (size > maxOpcode) return Err.size;

      
}
