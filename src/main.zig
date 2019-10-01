const std = @import("std");
const testing = std.testing;

pub const Mat2 = @import("mat2.zig").Mat2;
pub const Mat3 = @import("mat3.zig").Mat2;
pub const Vec2 = @import("vec2.zig").Vec2;
pub const Vec3 = @import("vec3.zig").Vec3;
pub const Vec4 = @import("vec4.zig").Vec4;

test "zig_matrix" {
    _ = @import("mat2.zig").Mat2;
    _ = @import("vec2.zig").Vec2;
    _ = @import("vec3.zig").Vec3;
    _ = @import("vec4.zig").Vec4;
}
