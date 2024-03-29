const std = @import("std");
const testing = std.testing;
const math = @import("std").math;
const Mat2 = @import("mat2.zig").Mat2;
const Mat3 = @import("mat3.zig").Mat3;
const Mat4 = @import("mat4.zig").Mat4;
const Quat = @import("quat.zig").Quat;
const f_eq = @import("utils.zig").f_eq;
const debug = @import("std").debug;

pub const Vec3 = packed struct {
    x: f32,
    y: f32,
    z: f32,

    pub const zero = Vec3.create(0, 0, 0);

    pub fn create(x: f32, y: f32, z: f32) Vec3 {
        return Vec3{
            .x = x,
            .y = y,
            .z = z,
        };
    }

    pub fn add(a: Vec3, b: Vec3) Vec3 {
        return Vec3.create(
            a.x + b.x,
            a.y + b.y,
            a.z + b.z,
        );
    }

    test "add" {
        const vecA = Vec3.create(1.0, 2.0, 3.0);
        const vecB = Vec3.create(7.0, 8.0, 9.0);
        const out = Vec3.add(vecA, vecB);
        const expected = Vec3.create(8.0, 10.0, 12.0);

        try Vec3.expectEqual(expected, out);
    }

    pub fn substract(a: Vec3, b: Vec3) Vec3 {
        return Vec3.create(
            a.x - b.x,
            a.y - b.y,
            a.z - b.z,
        );
    }

    test "substract" {
        const vecA = Vec3.create(3.0, 2.0, 1.0);
        const vecB = Vec3.create(7.0, 8.0, 9.0);
        const out = Vec3.sub(vecA, vecB);
        const expected = Vec3.create(-4.0, -6.0, -8.0);

        try Vec3.expectEqual(expected, out);
    }

    pub fn multiply(a: Vec3, b: Vec3) Vec3 {
        return Vec3.create(
            a.x * b.x,
            a.y * b.y,
            a.z * b.z,
        );
    }

    test "multiply" {
        const vecA = Vec3.create(1.0, 2.0, 3.0);
        const vecB = Vec3.create(7.0, 8.0, 9.0);
        const out = Vec3.mul(vecA, vecB);
        const expected = Vec3.create(7.0, 16.0, 27.0);

        try Vec3.expectEqual(expected, out);
    }

    pub fn divide(a: Vec3, b: Vec3) Vec3 {
        return Vec3.create(
            a.x / b.x,
            a.y / b.y,
            a.z / b.z,
        );
    }

    test "divide" {
        const vecA = Vec3.create(7.0, 8.0, 9.0);
        const vecB = Vec3.create(1.0, 2.0, 3.0);
        const out = Vec3.div(vecA, vecB);
        const expected = Vec3.create(7.0, 4.0, 3.0);

        try Vec3.expectEqual(expected, out);
    }

    pub fn ceil(a: Vec3) Vec3 {
        return Vec3.create(
            @ceil(a.x),
            @ceil(a.y),
            @ceil(a.z),
        );
    }

    test "ceil" {
        const vecA = Vec3.create(math.e, math.pi, @sqrt(2.0));
        const out = vecA.ceil();
        const expected = Vec3.create(3.0, 4.0, 2.0);

        try Vec3.expectEqual(expected, out);
    }

    pub fn floor(a: Vec3) Vec3 {
        return Vec3.create(
            @floor(a.x),
            @floor(a.y),
            @floor(a.z),
        );
    }

    test "floor" {
        const vecA = Vec3.create(math.e, math.pi, @sqrt(2.0));
        const out = vecA.floor();
        const expected = Vec3.create(2.0, 3.0, 1.0);

        try Vec3.expectEqual(expected, out);
    }

    pub fn min(a: Vec3, b: Vec3) Vec3 {
        return Vec3.create(
            @min(a.x, b.x),
            @min(a.y, b.y),
            @min(a.z, b.z),
        );
    }

    test "min" {
        const vecA = Vec3.create(1.0, 3.0, 1.0);
        const vecB = Vec3.create(3.0, 1.0, 3.0);
        const out = Vec3.min(vecA, vecB);
        const expected = Vec3.create(1.0, 1.0, 1.0);

        try Vec3.expectEqual(expected, out);
    }

    pub fn max(a: Vec3, b: Vec3) Vec3 {
        return Vec3.create(
            @max(a.x, b.x),
            @max(a.y, b.y),
            @max(a.z, b.z),
        );
    }

    test "max" {
        const vecA = Vec3.create(1.0, 3.0, 1.0);
        const vecB = Vec3.create(3.0, 1.0, 3.0);
        const out = Vec3.max(vecA, vecB);
        const expected = Vec3.create(3.0, 3.0, 3.0);

        try Vec3.expectEqual(expected, out);
    }

    pub fn round(a: Vec3) Vec3 {
        return Vec3.create(
            @round(a.x),
            @round(a.y),
            @round(a.z),
        );
    }

    test "round" {
        const vecA = Vec3.create(math.e, math.pi, @sqrt(2.0));
        const out = vecA.round();
        const expected = Vec3.create(3.0, 3.0, 1.0);

        try Vec3.expectEqual(expected, out);
    }

    pub fn scale(a: Vec3, s: f32) Vec3 {
        return Vec3.create(
            a.x * s,
            a.y * s,
            a.z * s,
        );
    }

    test "scale" {
        const vecA = Vec3.create(1.0, 2.0, 3.0);
        const out = vecA.scale(2.0);
        const expected = Vec3.create(2.0, 4.0, 6.0);

        try Vec3.expectEqual(expected, out);
    }

    pub fn scaleAndAdd(a: Vec3, b: Vec3, s: f32) Vec3 {
        return Vec3.create(
            a.x + (b.x * s),
            a.y + (b.y * s),
            a.z + (b.z * s),
        );
    }

    test "scaleAndAdd" {
        const vecA = Vec3.create(1.0, 2.0, 3.0);
        const vecB = Vec3.create(4.0, 5.0, 6.0);
        const out = vecA.scaleAndAdd(vecB, 0.5);
        const expected = Vec3.create(3.0, 4.5, 6.0);

        try Vec3.expectEqual(expected, out);
    }

    pub fn distance(a: Vec3, b: Vec3) f32 {
        // TODO: use std.math.hypot
        return @sqrt(Vec3.squaredDistance(a, b));

        //const x = a.x - b.x;
        //const y = a.y - b.y;
        //const z = a.z - b.z;

        //return math.hypot(f32, x, y, z);
    }

    test "distance" {
        const vecA = Vec3.create(1.0, 2.0, 3.0);
        const vecB = Vec3.create(4.0, 5.0, 6.0);
        const out = vecA.distance(vecB);
        const expected = 5.196152;

        try testing.expectEqual(out, expected);
    }

    pub fn squaredDistance(a: Vec3, b: Vec3) f32 {
        const x = a.x - b.x;
        const y = a.y - b.y;
        const z = a.z - b.z;
        return x * x + y * y + z * z;
    }

    test "squaredDistance" {
        const vecA = Vec3.create(1.0, 2.0, 3.0);
        const vecB = Vec3.create(4.0, 5.0, 6.0);
        const out = vecA.squaredDistance(vecB);
        const expected = 27.0;

        try testing.expectEqual(out, expected);
    }

    pub fn length(a: Vec3) f32 {
        // TODO: use std.math.hypot
        return @sqrt(a.squaredLength());

        //const x = a.x;
        //const y = a.y;
        //const z = a.z;
        //return math.hypot(f32, x, y) + math.hypot(f32, y, z);
    }

    test "length" {
        const vecA = Vec3.create(1.0, 2.0, 3.0);
        const out = vecA.length();
        const expected = 3.74165749;

        try testing.expectEqual(out, expected);
    }

    pub fn squaredLength(a: Vec3) f32 {
        const x = a.x;
        const y = a.y;
        const z = a.z;
        return x * x + y * y + z * z;
    }

    test "squaredLength" {
        const vecA = Vec3.create(1.0, 2.0, 3.0);
        const out = vecA.squaredLength();
        const expected = 14;

        try testing.expectEqual(out, expected);
    }

    pub fn negate(a: Vec3) Vec3 {
        const x = a.x;
        const y = a.y;
        const z = a.z;
        return Vec3.create(
            -x,
            -y,
            -z,
        );
    }

    test "negate" {
        const vecA = Vec3.create(1.0, 2.0, 3.0);
        const out = vecA.negate();
        const expected = Vec3.create(-1.0, -2.0, -3.0);

        try testing.expectEqual(out, expected);
    }

    pub fn inverse(a: Vec3) Vec3 {
        const x = 1.0 / a.x;
        const y = 1.0 / a.y;
        const z = 1.0 / a.z;
        return Vec3.create(
            -x,
            -y,
            -z,
        );
    }

    pub fn normalize(a: Vec3) Vec3 {
        const x = a.x;
        const y = a.y;
        const z = a.z;

        var l = x * x + y * y + z * z;
        if (l > 0)
            l = 1 / @sqrt(l);

        return Vec3.create(
            x * l,
            y * l,
            z * l,
        );
    }

    test "normalize" {
        const vecA = Vec3.create(5.0, 0.0, 0.0);
        const out = vecA.normalize();
        const expected = Vec3.create(1.0, 0.0, 0.0);

        try Vec3.expectEqual(expected, out);
    }

    pub fn dot(a: Vec3, b: Vec3) f32 {
        return a.x * b.x //
        + a.y * b.y //
        + a.z * b.z;
    }

    test "dot" {
        const vecA = Vec3.create(1.0, 2.0, 3.0);
        const vecB = Vec3.create(4.0, 5.0, 6.0);
        const out = Vec3.dot(vecA, vecB);
        const expected = 32.0;

        try testing.expectEqual(out, expected);
    }

    pub fn cross(a: Vec3, b: Vec3) Vec3 {
        const ax = a.x;
        const ay = a.y;
        const az = a.z;

        const bx = b.x;
        const by = b.y;
        const bz = b.z;

        return Vec3.create(
            ay * bz - az * by,
            az * bx - ax * bz,
            ax * by - ay * bx,
        );
    }

    test "cross" {
        const vecA = Vec3.create(1.0, 2.0, 3.0);
        const vecB = Vec3.create(4.0, 5.0, 6.0);
        const out = Vec3.cross(vecA, vecB);
        const expected = Vec3.create(-3.0, 6.0, -3.0);

        try Vec3.expectEqual(expected, out);
    }

    pub fn lerp(a: Vec3, b: Vec3, t: f32) Vec3 {
        return Vec3.create(
            a.x + t * (b.x - a.x),
            a.y + t * (b.y - a.y),
            a.z + t * (b.z - a.z),
        );
    }

    test "lerp" {
        const vecA = Vec3.create(1.0, 2.0, 3.0);
        const vecB = Vec3.create(4.0, 5.0, 6.0);
        const out = Vec3.lerp(vecA, vecB, 0.5);
        const expected = Vec3.create(2.5, 3.5, 4.5);

        try Vec3.expectEqual(expected, out);
    }

    pub fn hermite(a: Vec3, b: Vec3, c: Vec3, d: Vec3, t: f32) Vec3 {
        const factorTimes2 = t * t;
        const factor1 = factorTimes2 * (2 * t - 3) + 1;
        const factor2 = factorTimes2 * (t - 2) + t;
        const factor3 = factorTimes2 * (t - 1);
        const factor4 = factorTimes2 * (3 - 2 * t);

        return Vec3.create(
            a.x * factor1 + b.x * factor2 + c.x * factor3 + d.x * factor4,
            a.y * factor1 + b.y * factor2 + c.y * factor3 + d.y * factor4,
            a.z * factor1 + b.z * factor2 + c.z * factor3 + d.z * factor4,
        );
    }

    pub fn bezier(a: Vec3, b: Vec3, c: Vec3, d: Vec3, t: f32) Vec3 {
        const inverseFactor = 1 - t;
        const inverseFactorTimesTwo = inverseFactor * inverseFactor;
        const factorTimes2 = t * t;
        const factor1 = inverseFactorTimesTwo * inverseFactor;
        const factor2 = 3 * t * inverseFactorTimesTwo;
        const factor3 = 3 * factorTimes2 * inverseFactor;
        const factor4 = factorTimes2 * t;

        return Vec3.create(
            a.x * factor1 + b.x * factor2 + c.x * factor3 + d.x * factor4,
            a.y * factor1 + b.y * factor2 + c.y * factor3 + d.y * factor4,
            a.z * factor1 + b.z * factor2 + c.z * factor3 + d.z * factor4,
        );
    }

    pub fn transformMat3(a: Vec3, m: Mat3) Vec3 {
        return Vec3.create(
            a.x * m.data[0][0] + a.y * m.data[1][0] + a.z * m.data[2][0],
            a.x * m.data[0][1] + a.y * m.data[1][1] + a.z * m.data[2][1],
            a.x * m.data[0][2] + a.y * m.data[1][2] + a.z * m.data[2][2],
        );
    }

    pub fn transformQuat(a: Vec3, q: Quat) Vec3 {
        // var uv = vec3.cross([], qvec, a);
        var uvx = q.y * a.z - q.z * a.y;
        var uvy = q.z * a.x - q.x * a.z;
        var uvz = q.x * a.y - q.y * a.x;

        // var uuv = vec3.cross([], qvec, uv);
        var uuvx = q.y * uvz - q.z * uvy;
        var uuvy = q.z * uvx - q.x * uvz;
        var uuvz = q.x * uvy - q.y * uvx;

        // vec3.scale(uv, uv, 2 * w);
        const w2 = q.w * 2;
        uvx *= w2;
        uvy *= w2;
        uvz *= w2;

        // vec3.scale(uuv, uuv, 2);
        uuvx *= 2;
        uuvy *= 2;
        uuvz *= 2;

        // return vec3.add(out, a, vec3.add(out, uv, uuv));
        return Vec3.create(
            a.x + uvx + uuvx,
            a.y + uvy + uuvy,
            a.z + uvz + uuvz,
        );
    }

    pub fn transformMat4(a: Vec3, m: Mat4) Vec3 {
        const x = a.x;
        const y = a.y;
        const z = a.z;

        var w = m.data[0][3] * x + m.data[1][3] * y + m.data[2][3] * z + m.data[3][3];
        if (w == 0.0) w = 1.0;

        return Vec3.create(
            (m.data[0][0] * x + m.data[1][0] * y + m.data[2][0] * z + m.data[3][0]) / w,
            (m.data[0][1] * x + m.data[1][1] * y + m.data[2][1] * z + m.data[3][1]) / w,
            (m.data[0][2] * x + m.data[1][2] * y + m.data[2][2] * z + m.data[3][2]) / w,
        );
    }

    test "transformMat3 identity" {
        const vecA = Vec3.create(1.0, 2.0, 3.0);
        const m = Mat3.identity;
        const out = vecA.transformMat3(m);
        const expected = Vec3.create(1.0, 2.0, 3.0);

        try Vec3.expectEqual(expected, out);
    }

    test "transformMat3 with 90deg about X" {
        const vecA = Vec3.create(0.0, 1.0, 0.0);
        const m = Mat3.create(1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, -1.0, 0.0);
        const out = vecA.transformMat3(m);
        const expected = Vec3.create(0.0, 0.0, 1.0);

        try Vec3.expectEqual(expected, out);
    }

    test "transformMat3 with 90deg about Y" {
        const vecA = Vec3.create(1.0, 0.0, 0.0);
        const m = Mat3.create(0.0, 0.0, -1.0, 0.0, 1.0, 0.0, 1.0, 0.0, 0.0);
        const out = vecA.transformMat3(m);
        const expected = Vec3.create(0.0, 0.0, -1.0);

        try Vec3.expectEqual(expected, out);
    }

    test "transformMat3 with 90deg about Z" {
        const vecA = Vec3.create(1.0, 0.0, 0.0);
        const m = Mat3.create(0.0, 1.0, 0.0, -1.0, 0.0, 0.0, 0.0, 0.0, 1.0);
        const out = vecA.transformMat3(m);
        const expected = Vec3.create(0.0, 1.0, 0.0);

        try Vec3.expectEqual(expected, out);
    }

    pub fn rotateX(a: Vec3, origin: Vec3, rad: f32) Vec3 {
        //Translate point to the origin
        const px = a.x - origin.x;
        const py = a.y - origin.y;
        const pz = a.z - origin.z;

        const cos = @cos(rad);
        const sin = @sin(rad);

        //perform rotation
        const rx = px;
        const ry = py * cos - pz * sin;
        const rz = py * sin + pz * cos;

        //translate to correct position

        return Vec3.create(
            rx + origin.x,
            ry + origin.y,
            rz + origin.z,
        );
    }

    test "rotateX around world origin [0, 0, 0]" {
        const vecA = Vec3.create(0.0, 1.0, 0.0);
        const vecB = Vec3.create(0.0, 0.0, 0.0);
        const out = Vec3.rotateX(vecA, vecB, math.pi);
        const expected = Vec3.create(0.0, -1.0, 0.0);
        try Vec3.expectEqual(expected, out);
    }

    test "rotateX around arbitrary origin" {
        const vecA = Vec3.create(2.0, 7.0, 0.0);
        const vecB = Vec3.create(2.0, 5.0, 0.0);
        const out = vecA.rotateX(vecB, math.pi);
        const expected = Vec3.create(2.0, 3.0, 0.0);
        try Vec3.expectEqual(expected, out);
    }

    pub fn rotateY(a: Vec3, origin: Vec3, rad: f32) Vec3 {
        const px = a.x - origin.x;
        const py = a.y - origin.y;
        const pz = a.z - origin.z;

        const cos = @cos(rad);
        const sin = @sin(rad);

        const rx = pz * sin + px * cos;
        const ry = py;
        const rz = pz * cos - px * sin;

        return Vec3.create(
            rx + origin.x,
            ry + origin.y,
            rz + origin.z,
        );
    }

    test "rotateY around world origin [0, 0, 0]" {
        const vecA = Vec3.create(1.0, 0.0, 0.0);
        const vecB = Vec3.create(0.0, 0.0, 0.0);
        const out = vecA.rotateY(vecB, math.pi);
        const expected = Vec3.create(-1.0, 0.0, 0.0);
        try Vec3.expectEqual(expected, out);
    }

    test "rotateY around arbitrary origin" {
        const vecA = Vec3.create(-2.0, 3.0, 10.0);
        const vecB = Vec3.create(-4.0, 3.0, 10.0);
        const out = vecA.rotateY(vecB, math.pi);
        const expected = Vec3.create(-6.0, 3.0, 10.0);
        try Vec3.expectEqual(expected, out);
    }

    pub fn rotateZ(a: Vec3, origin: Vec3, rad: f32) Vec3 {
        //Translate point to the origin
        const px = a.x - origin.x;
        const py = a.y - origin.y;
        const pz = a.z - origin.z;

        const cos = @cos(rad);
        const sin = @sin(rad);

        //perform rotation
        const rx = px * cos - py * sin;
        const ry = px * sin + py * cos;
        const rz = pz;

        //translate to correct position

        return Vec3.create(
            rx + origin.x,
            ry + origin.y,
            rz + origin.z,
        );
    }

    test "rotateZ around world origin [0, 0, 0]" {
        const vecA = Vec3.create(0.0, 1.0, 0.0);
        const vecB = Vec3.create(0.0, 0.0, 0.0);
        const out = vecA.rotateZ(vecB, math.pi);
        const expected = Vec3.create(0.0, -1.0, 0.0);
        try Vec3.expectEqual(expected, out);
    }

    test "rotateZ around arbitrary origin" {
        const vecA = Vec3.create(0.0, 6.0, -5.0);
        const vecB = Vec3.create(0.0, 0.0, -5.0);
        const out = vecA.rotateZ(vecB, math.pi);
        const expected = Vec3.create(0.0, -6.0, -5.0);
        try Vec3.expectEqual(expected, out);
    }

    pub fn angle(a: Vec3, b: Vec3) f32 {
        const tempA = a.normalize();
        const tempB = b.normalize();

        const cosine = Vec3.dot(tempA, tempB);

        if (cosine > 1.0) {
            return 0.0;
        } else if (cosine < -1.0) {
            return math.pi;
        } else {
            return math.acos(cosine);
        }
    }

    test "angle" {
        const vecA = Vec3.create(1.0, 2.0, 3.0);
        const vecB = Vec3.create(4.0, 5.0, 6.0);
        const out = vecA.angle(vecB);
        const expected = 0.225726;
        try testing.expect(f_eq(expected, out));
    }

    pub fn equals(a: Vec3, b: Vec3) bool {
        return f_eq(a.x, b.x) and f_eq(a.y, b.y) and f_eq(a.z, b.z);
    }

    pub fn equalsExact(a: Vec3, b: Vec3) bool {
        return a.x == b.x and a.y == b.y and a.z == b.z;
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
            "Vec3({d:.3}, {d:.3}, {d:.3})",
            .{ value.x, value.y, value.z },
        );
    }

    pub const sub = substract;
    pub const mul = multiply;
    pub const div = divide;
    pub const dist = distance;
    pub const sqrDist = squaredDistance;
    pub const len = length;
    pub const sqrLen = squaredLength;

    pub fn expectEqual(expected: Vec3, actual: Vec3) !void {
        if (!equals(expected, actual)) {
            std.log.err("Expected: {}, found {}", .{ expected, actual });
            return error.NotEqual;
        }
    }
};
