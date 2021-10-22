const std = @import("std");
const math = @import("std").math;
const Mat2 = @import("mat2.zig").Mat2;
const f_eq = @import("utils.zig").f_eq;

pub const Vec2 = packed struct {
    x: f32,
    y: f32,

    pub fn create(x: f32, y: f32) Vec2 {
        return Vec2{ .x = x, .y = y };
    }

    test "create" {
        const vecA = Vec2.create(1, 2);
        try std.testing.expect(f_eq(vecA.x, 1));
        try std.testing.expect(f_eq(vecA.y, 2));
    }

    /// Adds two vec2
    pub fn add(a: Vec2, b: Vec2) Vec2 {
        return Vec2{
            .x = a.x + b.x,
            .y = a.y + b.y,
        };
    }

    test "add" {
        const vecA = Vec2.create(1, 2);
        const vecB = Vec2.create(3, 4);
        const out = vecA.add(vecB);
        const expected = Vec2.create(4, 6);

        try Vec2.expectEqual(out, expected);
    }

    /// substracts vec2 b from vec2 a
    pub fn substract(a: Vec2, b: Vec2) Vec2 {
        return Vec2{
            .x = a.x - b.x,
            .y = a.y - b.y,
        };
    }

    test "substract" {
        const a = Vec2.create(1, 2);
        const b = Vec2.create(3, 4);
        const out = a.sub(b);
        const expected = Vec2.create(-2, -2);

        try Vec2.expectEqual(out, expected);
    }

    /// Multiplies two vec2
    pub fn multiply(a: Vec2, b: Vec2) Vec2 {
        return Vec2{
            .x = a.x * b.x,
            .y = a.y * b.y,
        };
    }

    test "multiply" {
        const a = Vec2.create(1, 2);
        const b = Vec2.create(3, 4);
        const out = a.mul(b);
        const expected = Vec2.create(3, 8);

        try Vec2.expectEqual(out, expected);
    }

    /// Divides two vec2
    pub fn divide(a: Vec2, b: Vec2) Vec2 {
        return Vec2{
            .x = a.x / b.x,
            .y = a.y / b.y,
        };
    }

    test "divide" {
        const a = Vec2.create(1, 2);
        const b = Vec2.create(3, 4);
        const out = a.div(b);
        const expected = Vec2.create(0.3333333, 0.5);

        try Vec2.expectEqual(out, expected);
    }

    /// ceil the components
    pub fn ceil(a: Vec2) Vec2 {
        return Vec2{
            .x = @ceil(a.x),
            .y = @ceil(a.y),
        };
    }

    test "ceil" {
        const a = Vec2.create(math.e, math.pi);
        const out = a.ceil();
        const expected = Vec2.create(3, 4);

        try Vec2.expectEqual(out, expected);
    }

    /// floor the components
    pub fn floor(a: Vec2) Vec2 {
        return Vec2{
            .x = @floor(a.x),
            .y = @floor(a.y),
        };
    }

    test "floor" {
        const a = Vec2.create(math.e, math.pi);
        const out = a.floor();
        const expected = Vec2.create(2, 3);

        try Vec2.expectEqual(out, expected);
    }

    /// Returns the minimum of two vec2
    pub fn min(a: Vec2, b: Vec2) Vec2 {
        return Vec2{
            .x = math.min(a.x, b.x),
            .y = math.min(a.y, b.y),
        };
    }

    test "min" {
        const a = Vec2.create(1, 4);
        const b = Vec2.create(3, 2);
        const out = a.min(b);
        const expected = Vec2.create(1, 2);

        try Vec2.expectEqual(out, expected);
    }

    /// Returns the maximum of two vec2
    pub fn max(a: Vec2, b: Vec2) Vec2 {
        return Vec2{
            .x = math.max(a.x, b.x),
            .y = math.max(a.y, b.y),
        };
    }

    test "max" {
        const a = Vec2.create(1, 4);
        const b = Vec2.create(3, 2);
        const out = a.max(b);
        const expected = Vec2.create(3, 4);

        try Vec2.expectEqual(out, expected);
    }

    /// round  the components of a vec
    pub fn round(a: Vec2) Vec2 {
        return Vec2{
            .x = @round(a.x),
            .y = @round(a.y),
        };
    }

    test "round" {
        const a = Vec2.create(math.e, math.pi);
        const out = a.round();
        const expected = Vec2.create(3, 3);

        try Vec2.expectEqual(out, expected);
    }

    /// Scales a Vec2 by a scalar number
    pub fn scale(a: Vec2, b: f32) Vec2 {
        return Vec2{
            .x = a.x * b,
            .y = a.y * b,
        };
    }

    test "scale" {
        const a = Vec2.create(1, 2);
        const out = a.scale(2);
        const expected = Vec2.create(2, 4);

        try Vec2.expectEqual(out, expected);
    }

    /// Adds two vec2's after scaling the second operand by a scalar value
    pub fn scaleAndAdd(a: Vec2, b: Vec2, s: f32) Vec2 {
        return Vec2{
            .x = a.x + (b.x * s),
            .y = a.y + (b.y * s),
        };
    }

    test "scaleAndAdd" {
        const a = Vec2.create(1, 2);
        const b = Vec2.create(3, 4);
        const out = Vec2.scaleAndAdd(a, b, 0.5);
        const expected = Vec2.create(2.5, 4);

        try Vec2.expectEqual(out, expected);
    }

    /// Calculates the euclidian distance between two vec2
    pub fn distance(a: Vec2, b: Vec2) f32 {
        return math.hypot(f32, b.x - a.x, b.y - a.y);
    }

    test "distance" {
        const a = Vec2.create(1, 2);
        const b = Vec2.create(3, 4);
        const out = a.distance(b);
        try std.testing.expectEqual(out, 2.828427);
    }

    /// Calculates the squared euclidian distance between two vec2's
    pub fn squaredDistance(a: Vec2, b: Vec2) f32 {
        const dx = b.x - a.x;
        const dy = b.y - a.y;
        return dx * dx + dy * dy;
    }

    test "squaredDistance" {
        const a = Vec2.create(1, 2);
        const b = Vec2.create(3, 4);
        const out = a.squaredDistance(b);
        try std.testing.expectEqual(out, 8);
    }

    /// Calculates the length of a vec2
    pub fn length(a: Vec2) f32 {
        return math.hypot(f32, a.x, a.y);
    }

    test "length" {
        const a = Vec2.create(1, 2);
        const out = a.len();
        try std.testing.expectEqual(out, 2.23606801);
    }

    /// Calculates the squared length of a vec2
    pub fn squaredLength(a: Vec2) f32 {
        return a.x * a.x + a.y * a.y;
    }

    test "squaredLength" {
        const a = Vec2.create(1, 2);
        const out = a.squaredLength();
        try std.testing.expectEqual(out, 5);
    }

    /// Negates the components of a vec2
    pub fn negate(a: Vec2) Vec2 {
        return Vec2{
            .x = -a.x,
            .y = -a.y,
        };
    }

    test "negate" {
        const a = Vec2.create(1, 2);
        const out = a.negate();
        const expected = Vec2.create(-1, -2);

        try Vec2.expectEqual(out, expected);
    }

    /// Inverse the components of a vec2
    pub fn inverse(a: Vec2) Vec2 {
        return Vec2{
            .x = 1 / a.x,
            .y = 1 / a.y,
        };
    }

    ///Normalize a Vec2
    pub fn normalize(v: Vec2) Vec2 {
        var l = v.x * v.x + v.y * v.y;
        if (l > 0) {
            l = 1 / @sqrt(l);
        }

        return Vec2{
            .x = v.x * l,
            .y = v.y * l,
        };
    }

    test "normalize" {
        const a = Vec2.create(5, 0);
        const out = a.normalize();
        const expected = Vec2.create(1, 0);

        try Vec2.expectEqual(out, expected);
    }

    ///Calculates the dot product of two Vec2
    pub fn dot(v: Vec2, other: Vec2) f32 {
        return v.x * other.x +
            v.y * other.y;
    }

    test "dot" {
        const a = Vec2.create(1, 2);
        const b = Vec2.create(3, 4);
        const out = Vec2.dot(a, b);

        try std.testing.expectEqual(out, 11);
    }

    /// Returns the cross product
    pub fn cross(v: Vec2, other: Vec2) f32 {
        return v.x * other.y - other.x * v.y;
    }

    test "cross" {
        const a = Vec2.create(1, 2);
        const b = Vec2.create(3, 4);
        const out = Vec2.cross(a, b);

        try std.testing.expectEqual(out, -2);
    }

    /// Performs a liniear interpolation between two Vec2
    pub fn lerp(a: Vec2, b: Vec2, t: f32) Vec2 {
        return Vec2{
            .x = a.x + t * (b.x - a.x),
            .y = a.y + t * (b.y - a.y),
        };
    }

    test "lerp" {
        const a = Vec2.create(1, 2);
        const b = Vec2.create(3, 4);
        const out = Vec2.lerp(a, b, 0.5);
        const expected = Vec2.create(2, 3);

        try Vec2.expectEqual(out, expected);
    }

    /// Transforms the vec2 with a mat2
    pub fn transformMat2(a: Vec2, m: Mat2) Vec2 {
        return Vec2{
            .x = m.data[0][0] * a.x + m.data[1][0] * a.y,
            .y = m.data[0][1] * a.x + m.data[1][1] * a.y,
        };
    }

    test "transformMat2" {
        const matA = Mat2.create(1, 2, 3, 4);
        const a = Vec2.create(1, 2);
        const out = a.transformMat2(matA);

        const expected = Vec2.create(7, 10);

        try Vec2.expectEqual(out, expected);
    }

    /// Rotate a 2D vector
    pub fn rotate(a: Vec2, origin: Vec2, rad: f32) Vec2 {
        const p0 = a.x - origin.x;
        const p1 = a.y - origin.y;
        const sin = @sin(rad);
        const cos = @cos(rad);

        return Vec2{
            .x = p0 * cos - p1 * sin + origin.x,
            .y = p0 * sin + p1 * cos + origin.y,
        };
    }

    test "rotate around world origin [0, 0, 0]" {
        const a = Vec2.create(0, 1);
        const b = Vec2.create(0, 0);
        const out = Vec2.rotate(a, b, math.pi);

        const expected = Vec2.create(0, -1);

        try Vec2.expectEqual(out, expected);
    }

    test "rotate around arbitrary origin" {
        const a = Vec2.create(6, -5);
        const b = Vec2.create(0, -5);
        const out = Vec2.rotate(a, b, math.pi);

        const expected = Vec2.create(-6, -5);

        try Vec2.expectEqual(out, expected);
    }

    /// Get the angle (rad) between two Vec2
    pub fn angle(a: Vec2, b: Vec2) f32 {
        const x1 = a.x;
        const y1 = a.y;
        const x2 = b.x;
        const y2 = b.y;

        var len1 = x1 * x1 + y1 * y1;
        if (len1 > 0)
            len1 = 1 / @sqrt(len1);

        var len2 = x2 * x2 + y2 * y2;
        if (len2 > 0)
            len2 = 1 / @sqrt(len2);

        const cos = (x1 * x2 + y1 * y2) * len1 * len2;
        if (cos > 1) {
            return 0;
        } else if (cos < -1) {
            return math.pi;
        } else {
            return math.acos(cos);
        }
    }

    test "angle" {
        const a = Vec2.create(1, 0);
        const b = Vec2.create(1, 2);
        const out = Vec2.angle(a, b);

        try std.testing.expect(f_eq(out, 1.10714));
    }

    pub fn equals(a: Vec2, b: Vec2) bool {
        return f_eq(a.x, b.x) and f_eq(a.y, b.y);
    }

    pub fn equalsExact(a: Vec2, b: Vec2) bool {
        return a.x == b.x and a.y == b.y;
    }

    pub const len = length;
    pub const sub = substract;
    pub const mul = multiply;
    pub const div = divide;
    pub const dist = distance;
    pub const sqrDist = squaredDistance;
    pub const sqrLen = squaredLength;

    pub fn format(
        value: @This(),
        comptime fmt: []const u8,
        options: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        _ = options;
        _ = fmt;
        return std.fmt.format(writer, "Vec2({d:.3}, {d:.3})", .{ value.x, value.y });
    }

    fn expectEqual(expected: Vec2, actual: Vec2) !void {
        if (!expected.equals(actual)) {
            std.debug.warn("Expected: {}, found {}", .{ expected, actual });
            return error.NotEqual;
        }
    }
};
