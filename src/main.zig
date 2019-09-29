const std = @import("std");
const testing = std.testing;

pub const Mat2 = @import("mat2.zig").Mat2;
pub const Vec2 = @import("vec2.zig").Vec2;

test "zig_matrix" {
    _ = @import("mat2.zig");
    _ = @import("vec2.zig");
}
