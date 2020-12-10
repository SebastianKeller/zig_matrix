const std = @import("std");
const math = @import("std").math;
const Mat3 = @import("mat3.zig").Mat3;
const Mat4 = @import("mat4.zig").Mat4;
const utils = @import("utils.zig");
const Vec3 = @import("vec3.zig").Vec3;

pub const quat_identity = Quat.create(0, 0, 0, 1);
pub const quat_zero = Quat.create(0, 0, 0, 0);

pub const Quat = packed struct {
    x: f32,
    y: f32,
    z: f32,
    w: f32,

    pub fn create(x: f32, y: f32, z: f32, w: f32) Quat {
        return Quat{
            .x = x,
            .y = y,
            .z = z,
            .w = w,
        };
    }

    pub const identity = quat_identity;
    pub const zero = quat_zero;

    test "identity" {
        const quatA = Quat.identity;
        std.testing.expect(utils.f_eq(quatA.x, 0));
        std.testing.expect(utils.f_eq(quatA.y, 0));
        std.testing.expect(utils.f_eq(quatA.z, 0));
        std.testing.expect(utils.f_eq(quatA.w, 1));
    }

    ///Gets the rotation axis and angle for a given quaternion.
    pub fn getAxisAngle(q: Quat, out_axis: ?*Vec3) f32 {
        const rad = math.acos(q.w) * 2.0;
        if (out_axis) |v| {
            const s = @sin(rad / 2.0);
            if (s > utils.epsilon) {
                v.* = Vec3.create(
                    q.x / s,
                    q.y / s,
                    q.z / s,
                );
            } else {
                v.* = Vec3.create(1, 0, 0);
            }
        }
        return rad;
    }

    test "getAxisAngle no rotation" {
        const quat = fromAxisAngle(Vec3.create(0, 1, 0), 0.0);
        const deg90 = quat.getAxisAngle(null);

        std.testing.expect(utils.f_eq(@mod(deg90, math.pi * 2.0), 0.0));
    }

    test "getAxisAngle simple rotation X" {
        const quat = fromAxisAngle(Vec3.create(1, 0, 0), 0.7778);
        var out = Vec3.zero;
        const deg90 = quat.getAxisAngle(&out);

        std.testing.expect(utils.f_eq(deg90, 0.7778));
        Vec3.expectEqual(Vec3.create(1, 0, 0), out);
    }

    test "getAxisAngle simple rotation Y" {
        const quat = fromAxisAngle(Vec3.create(0, 0, 1), 0.123456);
        var out = Vec3.zero;
        const deg90 = quat.getAxisAngle(&out);

        std.testing.expect(utils.f_eq(deg90, 0.123456));
        Vec3.expectEqual(Vec3.create(0, 0, 1), out);
    }

    test "getAxisAngle slightly irregular axis and right angle" {
        const quat = fromAxisAngle(Vec3.create(0.707106, 0, 0.707106), math.pi * 0.5);
        var out = Vec3.zero;
        const deg90 = quat.getAxisAngle(&out);

        std.testing.expect(utils.f_eq(deg90, math.pi * 0.5));
        Vec3.expectEqual(Vec3.create(0.707106, 0, 0.707106), out);
    }

    test "getAxisAngle very irregular axis and negative input angle" {
        const quatA = fromAxisAngle(Vec3.create(0.65538555, 0.49153915, 0.57346237), 8.8888);
        var vec = Vec3.zero;
        const deg90 = quatA.getAxisAngle(&vec);
        const quatB = fromAxisAngle(vec, deg90);

        std.testing.expect(deg90 > 0.0);
        std.testing.expect(deg90 < math.pi * 2.0);
        expectEqual(quatA, quatB);
    }

    test "getAxisAngle simple rotation Z" {
        const quat = fromAxisAngle(Vec3.create(0, 1, 0), 0.879546);
        var out = Vec3.zero;
        const deg90 = quat.getAxisAngle(&out);

        std.testing.expect(utils.f_eq(deg90, 0.879546));
        Vec3.expectEqual(Vec3.create(0, 1, 0), out);
    }

    /// Sets a quat from the given angle and rotation axis,
    /// then returns it.
    pub fn fromAxisAngle(axis: Vec3, rad: f32) Quat {
        const radHalf = rad * 0.5;
        const s = @sin(radHalf);
        const c = @cos(radHalf);
        return Quat{
            .x = s * axis.x,
            .y = s * axis.y,
            .z = s * axis.z,
            .w = c,
        };
    }

    test "fromAxisAngle" {
        const out = fromAxisAngle(Vec3.create(1, 0, 0), math.pi * 0.5);
        const expected = create(0.707106, 0, 0, 0.707106);
        expectEqual(expected, out);
    }

    /// Gets the angular distance between two unit quaternions
    pub fn getAngle(a: Quat, b: Quat) f32 {
        const dotproduct = dot(a, b);
        return math.acos(2 * dotproduct * dotproduct - 1);
    }

    test "getAngle from itself" {
        const quatA = create(1, 2, 3, 4).normalize();
        const out = getAngle(quatA, quatA);
        std.testing.expect(utils.f_eq(out, 0.0));
    }

    test "getAngle from rotated" {
        const quatA = create(1, 2, 3, 4).normalize();
        const quatB = quatA.rotateX(math.pi / 4.0);

        const out = getAngle(quatA, quatB);
        std.testing.expect(utils.f_eq(out, math.pi / 4.0));
    }

    test "getAngle compare with axisAngle" {
        const quatA = create(1, 2, 3, 4).normalize();
        const quatB = create(5, 6, 7, 8).normalize();
        const quatAInv = conjugate(quatA);
        const quatAB = multiply(quatAInv, quatB);
        const reference = getAxisAngle(quatAB, null);

        std.testing.expect(utils.f_eq(getAngle(quatA, quatB), reference));
    }

    /// Adds two quats
    pub fn add(a: Quat, b: Quat) Quat {
        return Quat{
            .x = a.x + b.x,
            .y = a.y + b.y,
            .z = a.z + b.z,
            .w = a.w + b.w,
        };
    }

    test "add" {
        const a = Quat.create(1, 2, 3, 4);
        const b = Quat.create(5, 6, 7, 8);
        const out = Quat.add(a, b);
        const expected = Quat.create(6, 8, 10, 12);
        expectEqual(expected, out);
    }

    /// Multiplies two quats
    pub fn multiply(a: Quat, b: Quat) Quat {
        return Quat{
            .x = a.x * b.w + a.w * b.x + a.y * b.z - a.z * b.y,
            .y = a.y * b.w + a.w * b.y + a.z * b.x - a.x * b.z,
            .z = a.z * b.w + a.w * b.z + a.x * b.y - a.y * b.x,
            .w = a.w * b.w - a.x * b.x - a.y * b.y - a.z * b.z,
        };
    }

    /// Scales a quat by a scalar number
    pub fn scale(a: Quat, s: f32) Quat {
        return Quat{
            .x = a.x * s,
            .y = a.y * s,
            .z = a.z * s,
            .w = a.w * s,
        };
    }

    test "scale" {
        const a = Quat.create(1, 2, 3, 4);
        const out = Quat.scale(a, 2);
        const expected = Quat.create(2, 4, 6, 8);
        expectEqual(expected, out);
    }

    pub fn dot(a: Quat, b: Quat) f32 {
        return a.x * b.x //
            + a.y * b.y //
            + a.z * b.z //
            + a.w * b.w;
    }

    test "dot" {
        const a = Quat.create(1, 2, 3, 4);
        const b = Quat.create(5, 6, 7, 8);
        const out = Quat.dot(a, b);
        const expected = 70.0;
        std.testing.expect(utils.f_eq(expected, out));
    }

    pub fn lerp(a: Quat, b: Quat, t: f32) Quat {
        return Quat{
            .x = a.x + t * (b.x - a.x),
            .y = a.y + t * (b.y - a.y),
            .z = a.z + t * (b.z - a.z),
            .w = a.w + t * (b.w - a.w),
        };
    }

    test "lerp" {
        const a = Quat.create(1, 2, 3, 4);
        const b = Quat.create(5, 6, 7, 8);
        const out = Quat.lerp(a, b, 0.5);
        const expected = Quat.create(3, 4, 5, 6);
        expectEqual(expected, out);
    }

    pub fn length(a: Quat) f32 {
        // TODO: use std.math.hypot
        return @sqrt(a.squaredLength());
    }

    test "length" {
        const a = Quat.create(1, 2, 3, 4);
        const out = Quat.length(a);
        std.testing.expect(utils.f_eq(out, 5.477225));
    }

    pub fn squaredLength(a: Quat) f32 {
        return a.x * a.x + a.y * a.y + a.z * a.z + a.w * a.w;
    }

    test "squaredLength" {
        const a = Quat.create(1, 2, 3, 4);
        const out = Quat.squaredLength(a);
        std.testing.expect(utils.f_eq(out, 30));
    }

    pub fn normalize(a: Quat) Quat {
        var l = a.x * a.x + a.y * a.y + a.z * a.z + a.w * a.w;
        if (l > 0)
            l = 1 / @sqrt(l);

        return Quat{
            .x = a.x * l,
            .y = a.y * l,
            .z = a.z * l,
            .w = a.w * l,
        };
    }

    test "normalize" {
        const a = Quat.create(5, 0, 0, 0);
        const out = Quat.normalize(a);
        const expected = Quat.create(1, 0, 0, 0);
        expectEqual(expected, out);
    }

    /// Rotates a quaternion by the given angle about the X axis
    pub fn rotateX(a: Quat, rad: f32) Quat {
        var radHalf = rad * 0.5;
        const bx = @sin(radHalf);
        const bw = @cos(radHalf);

        return Quat{
            .x = a.x * bw + a.w * bx,
            .y = a.y * bw + a.z * bx,
            .z = a.z * bw - a.y * bx,
            .w = a.w * bw - a.x * bx,
        };
    }

    test "rotateX" {
        const out = identity.rotateX(math.pi / 2.0);

        const vec = Vec3.create(0, 0, -1).transformQuat(out);
        const expected = Vec3.create(0, 1, 0);
        Vec3.expectEqual(expected, vec);
    }

    /// Rotates a quaternion by the given angle about the Y axis
    pub fn rotateY(a: Quat, rad: f32) Quat {
        var radHalf = rad * 0.5;

        const by = @sin(radHalf);
        const bw = @cos(radHalf);

        return Quat{
            .x = a.x * bw - a.z * by,
            .y = a.y * bw + a.w * by,
            .z = a.z * bw + a.x * by,
            .w = a.w * bw - a.y * by,
        };
    }

    test "rotateY" {
        const out = identity.rotateY(math.pi / 2.0);

        const vec = Vec3.create(0, 0, -1).transformQuat(out);
        const expected = Vec3.create(-1, 0, 0);
        Vec3.expectEqual(expected, vec);
    }

    /// Rotates a quaternion by the given angle about the Z axis
    pub fn rotateZ(a: Quat, rad: f32) Quat {
        const radHalf = rad * 0.5;

        const bz = @sin(radHalf);
        const bw = @cos(radHalf);

        return Quat{
            .x = a.x * bw + a.y * bz,
            .y = a.y * bw - a.x * bz,
            .z = a.z * bw + a.w * bz,
            .w = a.w * bw - a.z * bz,
        };
    }

    test "rotateZ" {
        const out = identity.rotateZ(math.pi / 2.0);

        const vec = Vec3.create(0, 1, 0).transformQuat(out);
        const expected = Vec3.create(-1, 0, 0);
        Vec3.expectEqual(expected, vec);
    }

    /// Calculates the W component of a quat from the X, Y, and Z components.
    /// Assumes that quaternion is 1 unit in length.
    /// Any existing W component will be ignored.
    pub fn calculatW(a: Quat) Quat {
        return Quat{
            .x = a.x,
            .y = a.y,
            .z = a.z,
            .w = @sqrt(@fabs(1.0 - a.x * a.x - a.y * a.y - a.z * a.z)),
        };
    }

    /// Calculate the exponential of a unit quaternion.
    pub fn exp(a: Quat) Quat {
        var r = @sqrt(a.x * a.x + a.y * a.y + a.z * a.z);
        var et = @exp(a.w);
        var s = if (r > 0) (et * @sin(r) / r) else 0.0;

        return Quat{
            .x = a.x * s,
            .y = a.y * s,
            .z = a.z * s,
            .w = et * @cos(r),
        };
    }

    /// Calculate the naturl logarithm of a unit quaternion.
    pub fn ln(a: Quat) Quat {
        var r = @sqrt(a.x * a.x + a.y * a.y + a.z * a.z);
        var t: f32 = 0.0;
        if (r > 0)
            t = math.atan2(f32, r, a.w) / r;

        return Quat{
            .x = a.x * t,
            .y = a.y * t,
            .z = a.z * t,
            .w = 0.5 * @log10(a.x * a.x + a.y * a.y + a.z * a.z + a.w * a.w),
        };
    }

    /// Calculate the scalar power of a unit quaternion.
    pub fn pow(a: Quat, b: f32) Quat {
        var out = ln(a);
        out = scale(out, b);
        out = exp(out);
        return out;
    }

    test "pow identity quat" {
        const result = pow(identity, 2.1);
        expectEqual(result, identity);
    }

    test "pow of one" {
        var quatA = create(1, 2, 3, 4);
        quatA = normalize(quatA);

        const result = pow(quatA, 1);
        expectEqual(result, quatA);
    }

    test "pow squared" {
        var quatA = create(1, 2, 3, 4);
        quatA = normalize(quatA);
        const result = pow(quatA, 2);

        expectEqual(result, multiply(quatA, quatA));
    }

    /// Performs a spherical linear interpolation between two quats
    pub fn slerp(a: Quat, b: Quat, t: f32) Quat {
        // calc cosine
        var cosom = a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w;

        var bx = b.x;
        var by = b.y;
        var bz = b.z;
        var bw = b.w;

        // adjust signs (if necessary)
        if (cosom < 0.0) {
            cosom = -cosom;
            bx = -bx;
            by = -by;
            bz = -bz;
            bw = -bw;
        }

        var scale0: f32 = 0.0;
        var scale1: f32 = 0.0;
        // calculate coefficients
        if ((1.0 - cosom) > utils.epsilon) {
            // standard case (slerp)
            const omega = math.acos(cosom);
            const sinom = @sin(omega);
            scale0 = @sin((1.0 - t) * omega) / sinom;
            scale1 = @sin(t * omega) / sinom;
        } else {
            // "from" and "to" quaternions are very close
            //  ... so we can do a linear interpolation
            scale0 = 1.0 - t;
            scale1 = t;
        }

        // calculate final values
        return Quat{
            .x = scale0 * a.x + scale1 * bx,
            .y = scale0 * a.y + scale1 * by,
            .z = scale0 * a.z + scale1 * bz,
            .w = scale0 * a.w + scale1 * bw,
        };
    }

    test "slerp normal case" {
        const out = slerp(create(0, 0, 0, 1), create(0, 1, 0, 0), 0.5);
        const expected = create(0, 0.707106, 0, 0.707106);
        expectEqual(expected, out);
    }

    test "slerp a == b" {
        const out = slerp(create(0, 0, 0, 1), create(0, 0, 0, 1), 0.5);
        const expected = create(0, 0, 0, 1);
        expectEqual(expected, out);
    }

    test "slerp a == -b" {
        const out = slerp(create(1, 0, 0, 0), create(-1, 0, 0, 0), 0.5);
        const expected = create(1, 0, 0, 0);
        expectEqual(expected, out);
    }

    test "slerp theta == 180deg" {
        const quatA = create(1, 0, 0, 0).rotateX(math.pi);
        const out = slerp(create(-1, 0, 0, 0), quatA, 1);
        const expected = create(0, 0, 0, -1);
        expectEqual(expected, out);
    }

    /// Calculates the inverse of a quat
    pub fn invert(a: Quat) Quat {
        const dotProduct = Quat.dot(a, a);

        const invDot = if (dotProduct != 0.0) 1.0 / dotProduct else 0.0;
        if (invDot == 0) return quat_zero;

        return Quat{
            .x = -a.x * invDot,
            .y = -a.y * invDot,
            .z = -a.z * invDot,
            .w = a.w * invDot,
        };
    }

    test "invert" {
        const out = create(1, 2, 3, 4).invert();
        const expected = create(-0.033333, -0.066666, -0.1, 0.133333);
        expectEqual(expected, out);
    }

    /// Calculates the conjugate of a quat
    /// If the quaternion is normalized, this function is faster than Quat.inverse
    /// and produces the same result.
    pub fn conjugate(a: Quat) Quat {
        return Quat{
            .x = -a.x,
            .y = -a.y,
            .z = -a.z,
            .w = a.w,
        };
    }

    test "conjugate" {
        var quatA = create(1, 2, 3, 4).normalize();
        var result = pow(quatA, -1);

        expectEqual(quatA.conjugate(), result);
        std.testing.expect(utils.f_eq(result.length(), 1.0));
    }

    test "conjugate reversible" {
        var quatA = create(1, 2, 3, 4).normalize();

        const b = 2.1;
        const result = pow(pow(quatA, b), 1 / b);
        expectEqual(quatA, result);
        std.testing.expect(utils.f_eq(result.length(), 1.0));
    }

    /// Creates a quaternion from the given 3x3 rotation matrix.
    /// NOTE: The resultant quaternion is not normalized, so you should be sure
    /// to renomalize the quaternion yourself where necessary.
    pub fn fromMat3(m: Mat3) Quat {
        // Algorithm in Ken Shoemake's article in 1987 SIGGRAPH course notes
        // article "Quaternion Calculus and Fast Animation".
        const fTrace = m.data[0][0] + m.data[1][1] + m.data[2][2];

        if (fTrace > 0.0) {
            // |w| > 1/2, may as well choose w > 1/2
            const fRoot = @sqrt(fTrace + 1.0); // 2w
            const fRoot4 = 0.5 / fRoot;

            return Quat{
                .x = (m.data[1][2] - m.data[2][1]) * fRoot4,
                .y = (m.data[2][0] - m.data[0][2]) * fRoot4,
                .z = (m.data[0][1] - m.data[1][0]) * fRoot4,
                .w = 0.5 * fRoot,
            };
        } else {
            // 0 1 2
            // 3 4 5
            // 6 7 8

            // |w| <= 1/2
            var i: usize = 0;
            if (m.data[1][1] > m.data[0][0])
                i = 1;
            if (m.data[2][2] > m.data[i][i])
                i = 2;
            var j = (i + 1) % 3;
            var k = (i + 2) % 3;

            const fRoot = @sqrt(m.data[i][i] - m.data[j][j] - m.data[k][k] + 1.0);
            const fRoot2 = 0.5 / fRoot;

            var out: [4]f32 = undefined;
            out[i] = 0.5 * fRoot;
            out[3] = (m.data[j][k] - m.data[k][j]) * fRoot2;
            out[j] = (m.data[j][i] + m.data[i][j]) * fRoot2;
            out[k] = (m.data[k][i] + m.data[i][k]) * fRoot2;

            return Quat{
                .x = out[0],
                .y = out[1],
                .z = out[2],
                .w = out[3],
            };
        }
    }

    test "fromMat3 where trace > 0" {
        const mat = Mat3.create(1, 0, 0, 0, 0, -1, 0, 1, 0);
        const result = fromMat3(mat);

        const out = Vec3.create(0, 1, 0).transformQuat(result);
        const expected = Vec3.create(0, 0, -1);
        Vec3.expectEqual(expected, out);
    }

    fn testFromMat3(eye: Vec3, center: Vec3, up: Vec3) void {
        const lookat = Mat4.lookat(eye, center, up);

        var mat = Mat3.fromMat4(lookat).invert() orelse @panic("test failed");
        mat = mat.transpose();
        const result = fromMat3(mat);

        const out = Vec3.create(3, 2, -1).transformQuat(result.normalize());
        const expected = Vec3.create(3, 2, -1).transformMat3(mat);
        Vec3.expectEqual(expected, out);
    }

    test "fromMat3 normal matrix looking 'backward'" {
        testFromMat3(Vec3.create(0, 0, 0), Vec3.create(0, 0, 1), Vec3.create(0, 1, 0));
    }

    test "fromMat3 normal matrix looking 'left' and 'upside down'" {
        testFromMat3(Vec3.create(0, 0, 0), Vec3.create(-1, 0, 0), Vec3.create(0, -1, 0));
    }

    test "fromMat3 normal matrix looking 'upside down'" {
        testFromMat3(Vec3.create(0, 0, 0), Vec3.create(0, 0, 0), Vec3.create(0, -1, 0));
    }

    /// Creates a quaternion from the given euler angle x, y, z.
    pub fn fromEuler(x: f32, y: f32, z: f32) Quat {
        const halfToRad = 0.5 * math.pi / 180.0;
        const xH = x * halfToRad;
        const yH = y * halfToRad;
        const zH = z * halfToRad;

        const sx = @sin(xH);
        const cx = @cos(xH);
        const sy = @sin(yH);
        const cy = @cos(yH);
        const sz = @sin(zH);
        const cz = @cos(zH);

        return Quat{
            .x = sx * cy * cz - cx * sy * sz,
            .y = cx * sy * cz + sx * cy * sz,
            .z = cx * cy * sz - sx * sy * cz,
            .w = cx * cy * cz + sx * sy * sz,
        };
    }

    test "fromEuler legacy" {
        const result = fromEuler(-90, 0, 0);
        expectEqual(result, Quat.create(-0.707106, 0, 0, 0.707106));
    }

    test "fromEuler where trace > 0" {
        const result = fromEuler(-90, 0, 0);
        expectEqual(result, Quat.create(-0.707106, 0, 0, 0.707106));
    }

    /// Sets a quaternion to represent the shortest rotation from one
    /// vector to another.
    /// Both vectors are assumed to be unit length.
    pub fn rotationTo(a: Vec3, b: Vec3) Quat {
        var tmpvec3 = Vec3.zero;
        var xUnitVec3 = Vec3.create(1, 0, 0);
        var yUnitVec3 = Vec3.create(0, 1, 0);
        const dotProduct = Vec3.dot(a, b);

        if (dotProduct < (-1 + utils.epsilon)) {
            tmpvec3 = Vec3.cross(xUnitVec3, a);
            if (Vec3.len(tmpvec3) < utils.epsilon)
                tmpvec3 = Vec3.cross(yUnitVec3, a);
            tmpvec3 = Vec3.normalize(tmpvec3);
            return fromAxisAngle(tmpvec3, math.pi);
        } else if (dotProduct > (1 - utils.epsilon)) {
            return quat_identity;
        } else {
            tmpvec3 = Vec3.cross(a, b);
            const out = Quat{
                .x = tmpvec3.x,
                .y = tmpvec3.y,
                .z = tmpvec3.z,
                .w = 1 + dotProduct,
            };
            return normalize(out);
        }
    }

    test "rotationTo at right angle" {
        const result = rotationTo(Vec3.create(0, 1, 0), Vec3.create(1, 0, 0));
        expectEqual(result, Quat.create(0, 0, -0.707106, 0.707106));
    }

    test "rotationTo when vectors are parallel" {
        const result = rotationTo(Vec3.create(0, 1, 0), Vec3.create(0, 1, 0));
        Vec3.expectEqual(Vec3.create(0, 1, 0), Vec3.create(0, 1, 0).transformQuat(result));
    }

    test "rotationTo when vectors are opposed X" {
        const result = rotationTo(Vec3.create(1, 0, 0), Vec3.create(-1, 0, 0));
        Vec3.expectEqual(Vec3.create(-1, 0, 0), Vec3.create(1, 0, 0).transformQuat(result));
    }

    test "rotationTo when vectors are opposed Y" {
        const result = rotationTo(Vec3.create(0, 1, 0), Vec3.create(0, -1, 0));
        Vec3.expectEqual(Vec3.create(0, -1, 0), Vec3.create(0, 1, 0).transformQuat(result));
    }

    test "rotationTo when vectors are opposed Z" {
        const result = rotationTo(Vec3.create(0, 0, 1), Vec3.create(0, 0, -1));
        Vec3.expectEqual(Vec3.create(0, 0, -1), Vec3.create(0, 0, 1).transformQuat(result));
    }

    /// Performs a spherical linear interpolation with two control points
    pub fn sqlerp(a: Quat, b: Quat, c: Quat, d: Quat, t: f32) Quat {
        var temp1 = slerp(a, d, t);
        var temp2 = slerp(b, c, t);
        return slerp(temp1, temp2, 2 * t * (1 - t));
    }

    pub fn equals(a: Quat, b: Quat) bool {
        return utils.f_eq(a.x, b.x) //
            and utils.f_eq(a.y, b.y) //
            and utils.f_eq(a.z, b.z) //
            and utils.f_eq(a.w, b.w);
    }

    pub fn equalsExact(a: Quat, b: Quat) bool {
        return a.x == b.x //
            and a.y == b.y //
            and a.z == b.z //
            and a.w == b.w;
    }

    pub fn format(
        value: @This(),
        comptime fmt: []const u8,
        options: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        const str = "Quat({d:.3}, {d:.3}, {d:.3}, {d:.3})";
        return std.fmt.format(writer, str, .{ value.x, value.y, value.z, value.w });
    }

    fn expectEqual(expected: Quat, actual: Quat) void {
        if (!expected.equals(actual)) {
            std.debug.warn("Expected: {}, found {}", .{ expected, actual });
            @panic("test failed");
        }
    }

    pub const mul = multiply;
};
