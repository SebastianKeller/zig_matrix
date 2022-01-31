const std = @import("std");
const testing = std.testing;
const math = @import("std").math;
const f_eq = @import("utils.zig").f_eq;
const debug = @import("std").debug;

pub const Vec4 = packed struct {
    x: f32,
    y: f32,
    z: f32,
    w: f32,

    pub fn create(x: f32, y: f32, z: f32, w: f32) Vec4 {
        return Vec4{
            .x = x,
            .y = y,
            .z = z,
            .w = w,
        };
    }

    pub fn add(a: Vec4, b: Vec4) Vec4 {
        return Vec4{
            .x = a.x + b.x,
            .y = a.y + b.y,
            .z = a.z + b.z,
            .w = a.w + b.w,
        };
    }

    test "add" {
        const a = Vec4.create(1, 2, 3, 4);
        const b = Vec4.create(5, 6, 7, 8);
        const out = Vec4.add(a, b);
        const expected = Vec4.create(6, 8, 10, 12);
        try expectEqual(expected, out);
    }

    pub fn substract(a: Vec4, b: Vec4) Vec4 {
        return Vec4{
            .x = a.x - b.x,
            .y = a.y - b.y,
            .z = a.z - b.z,
            .w = a.w - b.w,
        };
    }

    test "substract" {
        const a = Vec4.create(1, 2, 3, 4);
        const b = Vec4.create(5, 6, 7, 8);
        const out = Vec4.sub(a, b);
        const expected = Vec4.create(-4, -4, -4, -4);
        try expectEqual(expected, out);
    }

    pub fn multiply(a: Vec4, b: Vec4) Vec4 {
        return Vec4{
            .x = a.x * b.x,
            .y = a.y * b.y,
            .z = a.z * b.z,
            .w = a.w * b.w,
        };
    }

    test "multiply" {
        const a = Vec4.create(1, 2, 3, 4);
        const b = Vec4.create(5, 6, 7, 8);
        const out = Vec4.mul(a, b);
        const expected = Vec4.create(5, 12, 21, 32);
        try expectEqual(expected, out);
    }

    pub fn divide(a: Vec4, b: Vec4) Vec4 {
        return Vec4{
            .x = a.x / b.x,
            .y = a.y / b.y,
            .z = a.z / b.z,
            .w = a.w / b.w,
        };
    }

    test "divide" {
        const a = Vec4.create(1, 2, 3, 4);
        const b = Vec4.create(5, 6, 7, 8);
        const out = Vec4.div(a, b);
        const expected = Vec4.create(0.2, 0.33333, 0.428571, 0.5);
        try expectEqual(expected, out);
    }

    pub fn ceil(a: Vec4) Vec4 {
        return Vec4{
            .x = @ceil(a.x),
            .y = @ceil(a.y),
            .z = @ceil(a.z),
            .w = @ceil(a.w),
        };
    }

    test "ceil" {
        const a = Vec4.create(math.e, math.pi, @sqrt(2.0), 1.0 / @sqrt(2.0));
        const out = Vec4.ceil(a);
        const expected = Vec4.create(3, 4, 2, 1);
        try expectEqual(expected, out);
    }

    pub fn floor(a: Vec4) Vec4 {
        return Vec4{
            .x = @floor(a.x),
            .y = @floor(a.y),
            .z = @floor(a.z),
            .w = @floor(a.w),
        };
    }

    test "floor" {
        const a = Vec4.create(math.e, math.pi, @sqrt(2.0), 1.0 / @sqrt(2.0));
        const out = Vec4.floor(a);
        const expected = Vec4.create(2, 3, 1, 0);
        try expectEqual(expected, out);
    }

    pub fn min(a: Vec4, b: Vec4) Vec4 {
        return Vec4{
            .x = math.min(a.x, b.x),
            .y = math.min(a.y, b.y),
            .z = math.min(a.z, b.z),
            .w = math.min(a.w, b.w),
        };
    }

    test "min" {
        const a = Vec4.create(1, 3, 1, 3);
        const b = Vec4.create(3, 1, 3, 1);
        const out = Vec4.min(a, b);
        const expected = Vec4.create(1, 1, 1, 1);
        try expectEqual(expected, out);
    }

    pub fn max(a: Vec4, b: Vec4) Vec4 {
        return Vec4{
            .x = math.max(a.x, b.x),
            .y = math.max(a.y, b.y),
            .z = math.max(a.z, b.z),
            .w = math.max(a.w, b.w),
        };
    }

    test "max" {
        const a = Vec4.create(1, 3, 1, 3);
        const b = Vec4.create(3, 1, 3, 1);
        const out = Vec4.max(a, b);
        const expected = Vec4.create(3, 3, 3, 3);
        try expectEqual(expected, out);
    }

    pub fn round(a: Vec4) Vec4 {
        return Vec4{
            .x = @round(a.x),
            .y = @round(a.y),
            .z = @round(a.z),
            .w = @round(a.w),
        };
    }

    test "round" {
        const a = Vec4.create(math.e, math.pi, @sqrt(2.0), 1.0 / @sqrt(2.0));
        const out = Vec4.round(a);
        const expected = Vec4.create(3, 3, 1, 1);
        try expectEqual(expected, out);
    }

    pub fn scale(a: Vec4, s: f32) Vec4 {
        return Vec4{
            .x = a.x * s,
            .y = a.y * s,
            .z = a.z * s,
            .w = a.w * s,
        };
    }

    test "scale" {
        const a = Vec4.create(1, 2, 3, 4);
        const out = Vec4.scale(a, 2);
        const expected = Vec4.create(2, 4, 6, 8);
        try expectEqual(expected, out);
    }

    pub fn scaleAndAdd(a: Vec4, b: Vec4, s: f32) Vec4 {
        return Vec4{
            .x = a.x + (b.x * s),
            .y = a.y + (b.y * s),
            .z = a.z + (b.z * s),
            .w = a.w + (b.w * s),
        };
    }

    test "scaleAndAdd" {
        const a = Vec4.create(1, 2, 3, 4);
        const b = Vec4.create(5, 6, 7, 8);
        const out = Vec4.scaleAndAdd(a, b, 0.5);
        const expected = Vec4.create(3.5, 5, 6.5, 8);
        try expectEqual(expected, out);
    }

    pub fn distance(a: Vec4, b: Vec4) f32 {
        // TODO: use std.math.hypot
        return @sqrt(Vec4.squaredDistance(a, b));
    }

    test "distance" {
        const a = Vec4.create(1, 2, 3, 4);
        const b = Vec4.create(5, 6, 7, 8);
        const out = Vec4.distance(a, b);
        try std.testing.expectEqual(out, 8);
    }

    pub fn squaredDistance(a: Vec4, b: Vec4) f32 {
        const x = a.x - b.x;
        const y = a.y - b.y;
        const z = a.z - b.z;
        const w = a.w - b.w;
        return x * x + y * y + z * z + w * w;
    }

    test "squaredDistance" {
        const a = Vec4.create(1, 2, 3, 4);
        const b = Vec4.create(5, 6, 7, 8);
        const out = Vec4.squaredDistance(a, b);
        try std.testing.expectEqual(out, 64);
    }

    pub fn length(a: Vec4) f32 {
        // TODO: use std.math.hypot
        return @sqrt(a.squaredLength());
    }

    test "length" {
        const a = Vec4.create(1, 2, 3, 4);
        const out = Vec4.length(a);
        try std.testing.expect(f_eq(out, 5.477225));
    }

    pub fn squaredLength(a: Vec4) f32 {
        const x = a.x;
        const y = a.y;
        const z = a.z;
        const w = a.w;
        return x * x + y * y + z * z + w * w;
    }

    test "squaredLength" {
        const a = Vec4.create(1, 2, 3, 4);
        const out = Vec4.squaredLength(a);
        try std.testing.expect(f_eq(out, 30));
    }

    pub fn negate(a: Vec4) Vec4 {
        return Vec4{
            .x = -a.x,
            .y = -a.y,
            .z = -a.z,
            .w = -a.w,
        };
    }

    test "negate" {
        const a = Vec4.create(1, 2, 3, 4);
        const out = Vec4.negate(a);
        const expected = Vec4.create(-1, -2, -3, -4);
        try expectEqual(expected, out);
    }

    pub fn inverse(a: Vec4) Vec4 {
        return Vec4{
            .x = -(1.0 / a.x),
            .y = -(1.0 / a.y),
            .z = -(1.0 / a.z),
            .w = -(1.0 / a.w),
        };
    }

    pub fn normalize(a: Vec4) Vec4 {
        const x = a.x;
        const y = a.y;
        const z = a.z;
        const w = a.w;

        var l = x * x + y * y + z * z + w * w;
        if (l > 0)
            l = 1 / @sqrt(l);

        return Vec4{
            .x = x * l,
            .y = y * l,
            .z = z * l,
            .w = w * l,
        };
    }

    test "normalize" {
        const a = Vec4.create(5, 0, 0, 0);
        const out = Vec4.normalize(a);
        const expected = Vec4.create(1, 0, 0, 0);
        try expectEqual(expected, out);
    }

    pub fn dot(a: Vec4, b: Vec4) f32 {
        return a.x * b.x //
        + a.y * b.y //
        + a.z * b.z //
        + a.w * b.w;
    }

    test "dot" {
        const a = Vec4.create(1, 2, 3, 4);
        const b = Vec4.create(5, 6, 7, 8);
        const out = Vec4.dot(a, b);
        const expected = 70.0;
        try std.testing.expect(f_eq(expected, out));
    }

    /// Returns the cross-product of three vectors in a 4-dimensional space
    pub fn cross(u: Vec4, v: Vec4, w: Vec4) Vec4 {
        const A = (v.x * w.y) - (v.y * w.x);
        const B = (v.x * w.z) - (v.z * w.x);
        const C = (v.x * w.w) - (v.w * w.x);
        const D = (v.y * w.z) - (v.z * w.y);
        const E = (v.y * w.w) - (v.w * w.y);
        const F = (v.z * w.w) - (v.w * w.z);
        const G = u.x;
        const H = u.y;
        const I = u.z;
        const J = u.w;

        return Vec4{
            .x = (H * F) - (I * E) + (J * D),
            .y = -(G * F) + (I * C) - (J * B),
            .z = (G * E) - (H * C) + (J * A),
            .w = -(G * D) + (H * B) - (I * A),
        };
    }

    test "cross" {
        const a = Vec4.create(1, 0, 0, 0);
        const b = Vec4.create(0, 1, 0, 0);
        const c = Vec4.create(0, 0, 1, 0);
        const out = Vec4.cross(a, b, c);
        const expected = Vec4.create(0, 0, 0, -1);
        try expectEqual(expected, out);
    }

    pub fn lerp(a: Vec4, b: Vec4, t: f32) Vec4 {
        return Vec4{
            .x = a.x + t * (b.x - a.x),
            .y = a.y + t * (b.y - a.y),
            .z = a.z + t * (b.z - a.z),
            .w = a.w + t * (b.w - a.w),
        };
    }

    test "lerp" {
        const a = Vec4.create(1, 2, 3, 4);
        const b = Vec4.create(5, 6, 7, 8);
        const out = Vec4.lerp(a, b, 0.5);
        const expected = Vec4.create(3, 4, 5, 6);
        try expectEqual(expected, out);
    }

    pub fn equals(a: Vec4, b: Vec4) bool {
        return f_eq(a.x, b.x) and f_eq(a.y, b.y) and f_eq(a.z, b.z) and f_eq(a.w, b.w);
    }

    pub fn equalsExact(a: Vec4, b: Vec4) bool {
        return a.x == b.x and a.y == b.y and a.z == b.z and a.w == b.w;
    }

    pub fn format(
        value: @This(),
        comptime fmt: []const u8,
        options: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        _ = options;
        _ = fmt;
        return std.fmt.format(
            writer,
            "Vec4({d:.3}, {d:.3}, {d:.3}, {d:.3})",
            .{ value.x, value.y, value.z, value.w },
        );
    }

    pub const sub = substract;
    pub const mul = multiply;
    pub const div = divide;
    pub const dist = distance;
    pub const sqrDist = squaredDistance;
    pub const len = length;
    pub const sqrLen = squaredLength;

    fn expectEqual(expected: Vec4, actual: Vec4) !void {
        if (!equals(expected, actual)) {
            std.log.err("Expected: {}, found {}", .{ expected, actual });
            return error.NotEqual;
        }
    }
};
