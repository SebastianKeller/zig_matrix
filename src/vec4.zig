const std = @import("std");
const testing = std.testing;
const math = @import("std").math;
const f_eq = @import("utils.zig").f_eq;
const debug = @import("std").debug;

pub const Vec4 = struct {
    data: [4]f32,

    pub fn create(x: f32, y: f32, z: f32, w: f32) Vec4 {
        return Vec4{
            .data = [_]f32{
                x, y, z, w,
            },
        };
    }

    pub fn add(a: Vec4, b: Vec4) Vec4 {
        return Vec4{
            .data = [_]f32{
                a.data[0] + b.data[0],
                a.data[1] + b.data[1],
                a.data[2] + b.data[2],
                a.data[3] + b.data[3],
            },
        };
    }

    test "add" {
        const a = Vec4.create(1, 2, 3, 4);
        const b = Vec4.create(5, 6, 7, 8);
        const out = Vec4.add(a, b);
        const expected = Vec4.create(6, 8, 10, 12);
        expectEqual(expected, out);
    }

    pub fn substract(a: Vec4, b: Vec4) Vec4 {
        return Vec4{
            .data = [_]f32{
                a.data[0] - b.data[0],
                a.data[1] - b.data[1],
                a.data[2] - b.data[2],
                a.data[3] - b.data[3],
            },
        };
    }

    test "substract" {
        const a = Vec4.create(1, 2, 3, 4);
        const b = Vec4.create(5, 6, 7, 8);
        const out = Vec4.sub(a, b);
        const expected = Vec4.create(-4, -4, -4, -4);
        expectEqual(expected, out);
    }

    pub fn multiply(a: Vec4, b: Vec4) Vec4 {
        return Vec4{
            .data = [_]f32{
                a.data[0] * b.data[0],
                a.data[1] * b.data[1],
                a.data[2] * b.data[2],
                a.data[3] * b.data[3],
            },
        };
    }

    test "multiply" {
        const a = Vec4.create(1, 2, 3, 4);
        const b = Vec4.create(5, 6, 7, 8);
        const out = Vec4.mul(a, b);
        const expected = Vec4.create(5, 12, 21, 32);
        expectEqual(expected, out);
    }

    pub fn divide(a: Vec4, b: Vec4) Vec4 {
        return Vec4{
            .data = [_]f32{
                a.data[0] / b.data[0],
                a.data[1] / b.data[1],
                a.data[2] / b.data[2],
                a.data[3] / b.data[3],
            },
        };
    }

    test "divide" {
        const a = Vec4.create(1, 2, 3, 4);
        const b = Vec4.create(5, 6, 7, 8);
        const out = Vec4.div(a, b);
        const expected = Vec4.create(0.2, 0.33333, 0.428571, 0.5);
        expectEqual(expected, out);
    }

    pub fn ceil(a: Vec4) Vec4 {
        return Vec4{
            .data = [_]f32{
                @ceil(f32, a.data[0]),
                @ceil(f32, a.data[1]),
                @ceil(f32, a.data[2]),
                @ceil(f32, a.data[3]),
            },
        };
    }

    test "ceil" {
        const a = Vec4.create(math.e, math.pi, @sqrt(f32, 2.0), 1.0 / @sqrt(f32, 2.0));
        const out = Vec4.ceil(a);
        const expected = Vec4.create(3, 4, 2, 1);
        expectEqual(expected, out);
    }

    pub fn floor(a: Vec4) Vec4 {
        return Vec4{
            .data = [_]f32{
                @floor(f32, a.data[0]),
                @floor(f32, a.data[1]),
                @floor(f32, a.data[2]),
                @floor(f32, a.data[3]),
            },
        };
    }

    test "floor" {
        const a = Vec4.create(math.e, math.pi, @sqrt(f32, 2.0), 1.0 / @sqrt(f32, 2.0));
        const out = Vec4.floor(a);
        const expected = Vec4.create(2, 3, 1, 0);
        expectEqual(expected, out);
    }

    pub fn min(a: Vec4, b: Vec4) Vec4 {
        return Vec4{
            .data = [_]f32{
                math.min(a.data[0], b.data[0]),
                math.min(a.data[1], b.data[1]),
                math.min(a.data[2], b.data[2]),
                math.min(a.data[3], b.data[3]),
            },
        };
    }

    test "min" {
        const a = Vec4.create(1, 3, 1, 3);
        const b = Vec4.create(3, 1, 3, 1);
        const out = Vec4.min(a, b);
        const expected = Vec4.create(1, 1, 1, 1);
        expectEqual(expected, out);
    }

    pub fn max(a: Vec4, b: Vec4) Vec4 {
        return Vec4{
            .data = [_]f32{
                math.max(a.data[0], b.data[0]),
                math.max(a.data[1], b.data[1]),
                math.max(a.data[2], b.data[2]),
                math.max(a.data[3], b.data[3]),
            },
        };
    }

    test "max" {
        const a = Vec4.create(1, 3, 1, 3);
        const b = Vec4.create(3, 1, 3, 1);
        const out = Vec4.max(a, b);
        const expected = Vec4.create(3, 3, 3, 3);
        expectEqual(expected, out);
    }

    pub fn round(a: Vec4) Vec4 {
        return Vec4{
            .data = [_]f32{
                @round(f32, a.data[0]),
                @round(f32, a.data[1]),
                @round(f32, a.data[2]),
                @round(f32, a.data[3]),
            },
        };
    }

    test "round" {
        const a = Vec4.create(math.e, math.pi, @sqrt(f32, 2.0), 1.0 / @sqrt(f32, 2.0));
        const out = Vec4.round(a);
        const expected = Vec4.create(3, 3, 1, 1);
        expectEqual(expected, out);
    }

    pub fn scale(a: Vec4, s: f32) Vec4 {
        return Vec4{
            .data = [_]f32{
                a.data[0] * s,
                a.data[1] * s,
                a.data[2] * s,
                a.data[3] * s,
            },
        };
    }

    test "scale" {
        const a = Vec4.create(1, 2, 3, 4);
        const out = Vec4.scale(a, 2);
        const expected = Vec4.create(2, 4, 6, 8);
        expectEqual(expected, out);
    }

    pub fn scaleAndAdd(a: Vec4, b: Vec4, s: f32) Vec4 {
        return Vec4{
            .data = [_]f32{
                a.data[0] + (b.data[0] * s),
                a.data[1] + (b.data[1] * s),
                a.data[2] + (b.data[2] * s),
                a.data[3] + (b.data[3] * s),
            },
        };
    }

    test "scaleAndAdd" {
        const a = Vec4.create(1, 2, 3, 4);
        const b = Vec4.create(5, 6, 7, 8);
        const out = Vec4.scaleAndAdd(a, b, 0.5);
        const expected = Vec4.create(3.5, 5, 6.5, 8);
        expectEqual(expected, out);
    }

    pub fn distance(a: Vec4, b: Vec4) f32 {
        // TODO: use std.math.hypot
        return @sqrt(f32, Vec4.squaredDistance(a, b));
    }

    test "distance" {
        const a = Vec4.create(1, 2, 3, 4);
        const b = Vec4.create(5, 6, 7, 8);
        const out = Vec4.distance(a, b);
        std.testing.expectEqual(out, 8);
    }

    pub fn squaredDistance(a: Vec4, b: Vec4) f32 {
        const x = a.data[0] - b.data[0];
        const y = a.data[1] - b.data[1];
        const z = a.data[2] - b.data[2];
        const w = a.data[3] - b.data[3];
        return x * x + y * y + z * z + w * w;
    }

    test "squaredDistance" {
        const a = Vec4.create(1, 2, 3, 4);
        const b = Vec4.create(5, 6, 7, 8);
        const out = Vec4.squaredDistance(a, b);
        std.testing.expectEqual(out, 64);
    }

    pub fn length(a: Vec4) f32 {
        // TODO: use std.math.hypot
        return @sqrt(f32, a.squaredLength());
    }

    test "length" {
        const a = Vec4.create(1, 2, 3, 4);
        const out = Vec4.length(a);
        std.testing.expect(f_eq(out, 5.477225));
    }

    pub fn squaredLength(a: Vec4) f32 {
        const x = a.data[0];
        const y = a.data[1];
        const z = a.data[2];
        const w = a.data[3];
        return x * x + y * y + z * z + w * w;
    }

    test "squaredLength" {
        const a = Vec4.create(1, 2, 3, 4);
        const out = Vec4.squaredLength(a);
        std.testing.expect(f_eq(out, 30));
    }

    pub fn negate(a: Vec4) Vec4 {
        const x = a.data[0];
        const y = a.data[1];
        const z = a.data[2];
        const w = a.data[3];
        return Vec4{
            .data = [_]f32{
                -x,
                -y,
                -z,
                -w,
            },
        };
    }

    test "negate" {
        const a = Vec4.create(1, 2, 3, 4);
        const out = Vec4.negate(a);
        const expected = Vec4.create(-1, -2, -3, -4);
        expectEqual(expected, out);
    }

    pub fn inverse(a: Vec4) Vec4 {
        const x = 1.0 / a.data[0];
        const y = 1.0 / a.data[1];
        const z = 1.0 / a.data[2];
        const w = 1.0 / a.data[3];
        return Vec4{
            .data = [_]f32{
                -x,
                -y,
                -z,
                -w,
            },
        };
    }

    pub fn normalize(a: Vec4) Vec4 {
        const x = a.data[0];
        const y = a.data[1];
        const z = a.data[2];
        const w = a.data[3];

        var l = x * x + y * y + z * z + w * w;
        if (l > 0)
            l = 1 / @sqrt(f32, l);

        return Vec4{
            .data = [_]f32{
                x * l,
                y * l,
                z * l,
                w * l,
            },
        };
    }

    test "normalize" {
        const a = Vec4.create(5, 0, 0, 0);
        const out = Vec4.normalize(a);
        const expected = Vec4.create(1, 0, 0, 0);
        expectEqual(expected, out);
    }

    pub fn dot(a: Vec4, b: Vec4) f32 {
        return a.data[0] * b.data[0] //
            + a.data[1] * b.data[1] //
            + a.data[2] * b.data[2] //
            + a.data[3] * b.data[3];
    }

    test "dot" {
        const a = Vec4.create(1, 2, 3, 4);
        const b = Vec4.create(5, 6, 7, 8);
        const out = Vec4.dot(a, b);
        const expected = 70.0;
        std.testing.expect(f_eq(expected, out));
    }

    /// Returns the cross-product of three vectors in a 4-dimensional space
    pub fn cross(u: Vec4, v: Vec4, w: Vec4) Vec4 {
        const A = (v.data[0] * w.data[1]) - (v.data[1] * w.data[0]);
        const B = (v.data[0] * w.data[2]) - (v.data[2] * w.data[0]);
        const C = (v.data[0] * w.data[3]) - (v.data[3] * w.data[0]);
        const D = (v.data[1] * w.data[2]) - (v.data[2] * w.data[1]);
        const E = (v.data[1] * w.data[3]) - (v.data[3] * w.data[1]);
        const F = (v.data[2] * w.data[3]) - (v.data[3] * w.data[2]);
        const G = u.data[0];
        const H = u.data[1];
        const I = u.data[2];
        const J = u.data[3];

        return Vec4{
            .data = [_]f32{
                (H * F) - (I * E) + (J * D),
                -(G * F) + (I * C) - (J * B),
                (G * E) - (H * C) + (J * A),
                -(G * D) + (H * B) - (I * A),
            },
        };
    }

    test "cross" {
        const a = Vec4.create(1, 0, 0, 0);
        const b = Vec4.create(0, 1, 0, 0);
        const c = Vec4.create(0, 0, 1, 0);
        const out = Vec4.cross(a, b, c);
        const expected = Vec4.create(0, 0, 0, -1);
        expectEqual(expected, out);
    }

    pub fn lerp(a: Vec4, b: Vec4, t: f32) Vec4 {
        const ax = a.data[0];
        const ay = a.data[1];
        const az = a.data[2];
        const aw = a.data[3];

        const bx = b.data[0];
        const by = b.data[1];
        const bz = b.data[2];
        const bw = b.data[3];

        return Vec4{
            .data = [_]f32{
                ax + t * (bx - ax),
                ay + t * (by - ay),
                az + t * (bz - az),
                aw + t * (bw - aw),
            },
        };
    }

    test "lerp" {
        const a = Vec4.create(1, 2, 3, 4);
        const b = Vec4.create(5, 6, 7, 8);
        const out = Vec4.lerp(a, b, 0.5);
        const expected = Vec4.create(3, 4, 5, 6);
        expectEqual(expected, out);
    }

    pub fn equals(a: Vec4, b: Vec4) bool {
        return f_eq(a.data[0], b.data[0]) and f_eq(a.data[1], b.data[1]) and f_eq(a.data[2], b.data[2]) and f_eq(a.data[3], b.data[3]);
    }

    pub fn equalsExact(a: Vec4, b: Vec4) bool {
        return a.data[0] == b.data[0] and a.data[1] == b.data[1] and a.data[2] == b.data[2] and a.data[3] == b.data[3];
    }

    pub fn format(
        self: @This(),
        comptime fmt: []const u8,
        options: std.fmt.FormatOptions,
        context: var,
        comptime Errors: type,
        output: fn (@typeOf(context), []const u8) Errors!void,
    ) Errors!void {
        return std.fmt.format(context, Errors, output, "Vec4({d:.3}, {d:.3}, {d:.3}, {d:.3})", self.data[0], self.data[1], self.data[2], self.data[3]);
    }

    pub const sub = substract;
    pub const mul = multiply;
    pub const div = divide;
    pub const dist = distance;
    pub const sqrDist = squaredDistance;
    pub const len = length;
    pub const sqrLen = squaredLength;

    fn expectEqual(expected: Vec4, actual: Vec4) void {
        if (!equals(expected, actual)) {
            std.debug.warn("Expected: {}, found {}", expected, actual);
            @panic("test failed");
        }
    }
};
