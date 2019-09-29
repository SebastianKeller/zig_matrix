const std = @import("std");
const testing = std.testing;

pub const Mat2 = @import("mat2.zig").Mat2;
pub const Vec2 = @import("vec2.zig").Vec2;
pub const Vec3 = @import("vec3.zig").Vec3;

test "zig_matrix" {
    _ = @import("mat2.zig").Mat2;
    _ = @import("vec2.zig").Vec2;
    _ = @import("vec3.zig").Vec3;
}
