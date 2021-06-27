const std = @import("std");
const math = std.math;
const testing = std.testing;
const utils = @import("utils.zig");
const Vec3 = @import("vec3.zig").Vec3;

/// A Mat4 identity matrix
pub const mat4_identity = Mat4{
    .data = .{
        .{ 1, 0, 0, 0 },
        .{ 0, 1, 0, 0 },
        .{ 0, 0, 1, 0 },
        .{ 0, 0, 0, 1 },
    },
};

pub const Mat4 = struct {
    data: [4][4]f32,

    pub const identity = mat4_identity;

    pub fn create(
        m00: f32,
        m01: f32,
        m02: f32,
        m03: f32,
        m10: f32,
        m11: f32,
        m12: f32,
        m13: f32,
        m20: f32,
        m21: f32,
        m22: f32,
        m23: f32,
        m30: f32,
        m31: f32,
        m32: f32,
        m33: f32,
    ) Mat4 {
        return Mat4{
            .data = .{
                .{ m00, m01, m02, m03 },
                .{ m10, m11, m12, m13 },
                .{ m20, m21, m22, m23 },
                .{ m30, m31, m32, m33 },
            },
        };
    }

    /// Transpose the values of a mat4
    pub fn transpose(m: Mat4) Mat4 {
        //  0  1  2  3
        //  4  5  6  7
        //  8  9 10 11
        // 12 13 14 15
        return Mat4{
            .data = .{
                .{ m.data[0][0], m.data[1][0], m.data[2][0], m.data[3][0] },
                .{ m.data[0][1], m.data[1][1], m.data[2][1], m.data[3][1] },
                .{ m.data[0][2], m.data[1][2], m.data[2][2], m.data[3][2] },
                .{ m.data[0][3], m.data[1][3], m.data[2][3], m.data[3][3] },
            },
        };
    }

    test "transpose" {
        const matA = Mat4.create(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1, 2, 3, 1);
        const out = Mat4.transpose(matA);
        const expected = Mat4.create(1, 0, 0, 1, 0, 1, 0, 2, 0, 0, 1, 3, 0, 0, 0, 1);
        try expectEqual(expected, out);
    }

    /// Inverts a mat4
    pub fn invert(m: Mat4) ?Mat4 {
        const b00 = m.data[0][0] * m.data[1][1] - m.data[0][1] * m.data[1][0];
        const b01 = m.data[0][0] * m.data[1][2] - m.data[0][2] * m.data[1][0];
        const b02 = m.data[0][0] * m.data[1][3] - m.data[0][3] * m.data[1][0];
        const b03 = m.data[0][1] * m.data[1][2] - m.data[0][2] * m.data[1][1];
        const b04 = m.data[0][1] * m.data[1][3] - m.data[0][3] * m.data[1][1];
        const b05 = m.data[0][2] * m.data[1][3] - m.data[0][3] * m.data[1][2];
        const b06 = m.data[2][0] * m.data[3][1] - m.data[2][1] * m.data[3][0];
        const b07 = m.data[2][0] * m.data[3][2] - m.data[2][2] * m.data[3][0];
        const b08 = m.data[2][0] * m.data[3][3] - m.data[2][3] * m.data[3][0];
        const b09 = m.data[2][1] * m.data[3][2] - m.data[2][2] * m.data[3][1];
        const b10 = m.data[2][1] * m.data[3][3] - m.data[2][3] * m.data[3][1];
        const b11 = m.data[2][2] * m.data[3][3] - m.data[2][3] * m.data[3][2];

        // Calculate the determinant
        var det = b00 * b11 - b01 * b10 + b02 * b09 + b03 * b08 - b04 * b07 + b05 * b06;

        if (det == 0) {
            return null;
        }
        det = 1 / det;

        return Mat4{
            .data = .{
                .{
                    (m.data[1][1] * b11 - m.data[1][2] * b10 + m.data[1][3] * b09) * det,
                    (m.data[0][2] * b10 - m.data[0][1] * b11 - m.data[0][3] * b09) * det,
                    (m.data[3][1] * b05 - m.data[3][2] * b04 + m.data[3][3] * b03) * det,
                    (m.data[2][2] * b04 - m.data[2][1] * b05 - m.data[2][3] * b03) * det,
                },
                .{
                    (m.data[1][2] * b08 - m.data[1][0] * b11 - m.data[1][3] * b07) * det,
                    (m.data[0][0] * b11 - m.data[0][2] * b08 + m.data[0][3] * b07) * det,
                    (m.data[3][2] * b02 - m.data[3][0] * b05 - m.data[3][3] * b01) * det,
                    (m.data[2][0] * b05 - m.data[2][2] * b02 + m.data[2][3] * b01) * det,
                },
                .{
                    (m.data[1][0] * b10 - m.data[1][1] * b08 + m.data[1][3] * b06) * det,
                    (m.data[0][1] * b08 - m.data[0][0] * b10 - m.data[0][3] * b06) * det,
                    (m.data[3][0] * b04 - m.data[3][1] * b02 + m.data[3][3] * b00) * det,
                    (m.data[2][1] * b02 - m.data[2][0] * b04 - m.data[2][3] * b00) * det,
                },
                .{
                    (m.data[1][1] * b07 - m.data[1][0] * b09 - m.data[1][2] * b06) * det,
                    (m.data[0][0] * b09 - m.data[0][1] * b07 + m.data[0][2] * b06) * det,
                    (m.data[3][1] * b01 - m.data[3][0] * b03 - m.data[3][2] * b00) * det,
                    (m.data[2][0] * b03 - m.data[2][1] * b01 + m.data[2][2] * b00) * det,
                },
            },
        };
    }

    test "invert" {
        const matA = Mat4.create(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1, 2, 3, 1);
        const out = Mat4.invert(matA) orelse @panic("test failed");
        const expected = Mat4.create(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, -1, -2, -3, 1);
        try expectEqual(expected, out);
    }

    /// Calculates the adjugate
    pub fn adjoint(m: Mat4) Mat4 {
        return Mat4{
            .data = .{
                .{
                    (m.data[1][1] * (m.data[2][2] * m.data[3][3] - m.data[2][3] * m.data[3][2]) - m.data[2][1] * (m.data[1][2] * m.data[3][3] - m.data[1][3] * m.data[3][2]) + m.data[3][1] * (m.data[1][2] * m.data[2][3] - m.data[1][3] * m.data[2][2])),
                    -(m.data[0][1] * (m.data[2][2] * m.data[3][3] - m.data[2][3] * m.data[3][2]) - m.data[2][1] * (m.data[0][2] * m.data[3][3] - m.data[0][3] * m.data[3][2]) + m.data[3][1] * (m.data[0][2] * m.data[2][3] - m.data[0][3] * m.data[2][2])),
                    (m.data[0][1] * (m.data[1][2] * m.data[3][3] - m.data[1][3] * m.data[3][2]) - m.data[1][1] * (m.data[0][2] * m.data[3][3] - m.data[0][3] * m.data[3][2]) + m.data[3][1] * (m.data[0][2] * m.data[1][3] - m.data[0][3] * m.data[1][2])),
                    -(m.data[0][1] * (m.data[1][2] * m.data[2][3] - m.data[1][3] * m.data[2][2]) - m.data[1][1] * (m.data[0][2] * m.data[2][3] - m.data[0][3] * m.data[2][2]) + m.data[2][1] * (m.data[0][2] * m.data[1][3] - m.data[0][3] * m.data[1][2])),
                },
                .{
                    -(m.data[1][0] * (m.data[2][2] * m.data[3][3] - m.data[2][3] * m.data[3][2]) - m.data[2][0] * (m.data[1][2] * m.data[3][3] - m.data[1][3] * m.data[3][2]) + m.data[3][0] * (m.data[1][2] * m.data[2][3] - m.data[1][3] * m.data[2][2])),
                    (m.data[0][0] * (m.data[2][2] * m.data[3][3] - m.data[2][3] * m.data[3][2]) - m.data[2][0] * (m.data[0][2] * m.data[3][3] - m.data[0][3] * m.data[3][2]) + m.data[3][0] * (m.data[0][2] * m.data[2][3] - m.data[0][3] * m.data[2][2])),
                    -(m.data[0][0] * (m.data[1][2] * m.data[3][3] - m.data[1][3] * m.data[3][2]) - m.data[1][0] * (m.data[0][2] * m.data[3][3] - m.data[0][3] * m.data[3][2]) + m.data[3][0] * (m.data[0][2] * m.data[1][3] - m.data[0][3] * m.data[1][2])),
                    (m.data[0][0] * (m.data[1][2] * m.data[2][3] - m.data[1][3] * m.data[2][2]) - m.data[1][0] * (m.data[0][2] * m.data[2][3] - m.data[0][3] * m.data[2][2]) + m.data[2][0] * (m.data[0][2] * m.data[1][3] - m.data[0][3] * m.data[1][2])),
                },
                .{
                    (m.data[1][0] * (m.data[2][1] * m.data[3][3] - m.data[2][3] * m.data[3][1]) - m.data[2][0] * (m.data[1][1] * m.data[3][3] - m.data[1][3] * m.data[3][1]) + m.data[3][0] * (m.data[1][1] * m.data[2][3] - m.data[1][3] * m.data[2][1])),
                    -(m.data[0][0] * (m.data[2][1] * m.data[3][3] - m.data[2][3] * m.data[3][1]) - m.data[2][0] * (m.data[0][1] * m.data[3][3] - m.data[0][3] * m.data[3][1]) + m.data[3][0] * (m.data[0][1] * m.data[2][3] - m.data[0][3] * m.data[2][1])),
                    (m.data[0][0] * (m.data[1][1] * m.data[3][3] - m.data[1][3] * m.data[3][1]) - m.data[1][0] * (m.data[0][1] * m.data[3][3] - m.data[0][3] * m.data[3][1]) + m.data[3][0] * (m.data[0][1] * m.data[1][3] - m.data[0][3] * m.data[1][1])),
                    -(m.data[0][0] * (m.data[1][1] * m.data[2][3] - m.data[1][3] * m.data[2][1]) - m.data[1][0] * (m.data[0][1] * m.data[2][3] - m.data[0][3] * m.data[2][1]) + m.data[2][0] * (m.data[0][1] * m.data[1][3] - m.data[0][3] * m.data[1][1])),
                },
                .{
                    -(m.data[1][0] * (m.data[2][1] * m.data[3][2] - m.data[2][2] * m.data[3][1]) - m.data[2][0] * (m.data[1][1] * m.data[3][2] - m.data[1][2] * m.data[3][1]) + m.data[3][0] * (m.data[1][1] * m.data[2][2] - m.data[1][2] * m.data[2][1])),
                    (m.data[0][0] * (m.data[2][1] * m.data[3][2] - m.data[2][2] * m.data[3][1]) - m.data[2][0] * (m.data[0][1] * m.data[3][2] - m.data[0][2] * m.data[3][1]) + m.data[3][0] * (m.data[0][1] * m.data[2][2] - m.data[0][2] * m.data[2][1])),
                    -(m.data[0][0] * (m.data[1][1] * m.data[3][2] - m.data[1][2] * m.data[3][1]) - m.data[1][0] * (m.data[0][1] * m.data[3][2] - m.data[0][2] * m.data[3][1]) + m.data[3][0] * (m.data[0][1] * m.data[1][2] - m.data[0][2] * m.data[1][1])),
                    (m.data[0][0] * (m.data[1][1] * m.data[2][2] - m.data[1][2] * m.data[2][1]) - m.data[1][0] * (m.data[0][1] * m.data[2][2] - m.data[0][2] * m.data[2][1]) + m.data[2][0] * (m.data[0][1] * m.data[1][2] - m.data[0][2] * m.data[1][1])),
                },
            },
        };
    }

    test "adjoint" {
        const matA = Mat4.create(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1, 2, 3, 1);
        const out = Mat4.adjoint(matA);
        const expected = Mat4.create(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, -1, -2, -3, 1);
        try expectEqual(expected, out);
    }

    ///Calculates the determinant
    pub fn determinant(m: Mat4) f32 {
        const b00 = m.data[0][0] * m.data[1][1] - m.data[0][1] * m.data[1][0];
        const b01 = m.data[0][0] * m.data[1][2] - m.data[0][2] * m.data[1][0];
        const b02 = m.data[0][0] * m.data[1][3] - m.data[0][3] * m.data[1][0];
        const b03 = m.data[0][1] * m.data[1][2] - m.data[0][2] * m.data[1][1];
        const b04 = m.data[0][1] * m.data[1][3] - m.data[0][3] * m.data[1][1];
        const b05 = m.data[0][2] * m.data[1][3] - m.data[0][3] * m.data[1][2];
        const b06 = m.data[2][0] * m.data[3][1] - m.data[2][1] * m.data[3][0];
        const b07 = m.data[2][0] * m.data[3][2] - m.data[2][2] * m.data[3][0];
        const b08 = m.data[2][0] * m.data[3][3] - m.data[2][3] * m.data[3][0];
        const b09 = m.data[2][1] * m.data[3][2] - m.data[2][2] * m.data[3][1];
        const b10 = m.data[2][1] * m.data[3][3] - m.data[2][3] * m.data[3][1];
        const b11 = m.data[2][2] * m.data[3][3] - m.data[2][3] * m.data[3][2];

        // Calculate the determinant
        return b00 * b11 - b01 * b10 + b02 * b09 + b03 * b08 - b04 * b07 + b05 * b06;
    }

    test "determinant" {
        const matA = Mat4.create(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1, 2, 3, 1);
        const out = Mat4.determinant(matA);
        const expected = 1;
        try testing.expect(utils.f_eq(out, expected));
    }

    /// Adds two mat4's
    pub fn add(a: Mat4, b: Mat4) Mat4 {
        return Mat4{
            .data = .{
                .{
                    a.data[0][0] + b.data[0][0],
                    a.data[0][1] + b.data[0][1],
                    a.data[0][2] + b.data[0][2],
                    a.data[0][3] + b.data[0][3],
                },

                .{
                    a.data[1][0] + b.data[1][0],
                    a.data[1][1] + b.data[1][1],
                    a.data[1][2] + b.data[1][2],
                    a.data[1][3] + b.data[1][3],
                },
                .{
                    a.data[2][0] + b.data[2][0],
                    a.data[2][1] + b.data[2][1],
                    a.data[2][2] + b.data[2][2],
                    a.data[2][3] + b.data[2][3],
                },
                .{
                    a.data[3][0] + b.data[3][0],
                    a.data[3][1] + b.data[3][1],
                    a.data[3][2] + b.data[3][2],
                    a.data[3][3] + b.data[3][3],
                },
            },
        };
    }

    test "add" {
        const matA = Mat4.create(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16);
        const matB = Mat4.create(17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32);
        const out = Mat4.add(matA, matB);
        const expected = Mat4.create(18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48);
        try expectEqual(expected, out);
    }

    /// Subtracts matrix b from matrix a
    pub fn subtract(a: Mat4, b: Mat4) Mat4 {
        return Mat4{
            .data = .{
                .{
                    a.data[0][0] - b.data[0][0],
                    a.data[0][1] - b.data[0][1],
                    a.data[0][2] - b.data[0][2],
                    a.data[0][3] - b.data[0][3],
                },

                .{
                    a.data[1][0] - b.data[1][0],
                    a.data[1][1] - b.data[1][1],
                    a.data[1][2] - b.data[1][2],
                    a.data[1][3] - b.data[1][3],
                },
                .{
                    a.data[2][0] - b.data[2][0],
                    a.data[2][1] - b.data[2][1],
                    a.data[2][2] - b.data[2][2],
                    a.data[2][3] - b.data[2][3],
                },
                .{
                    a.data[3][0] - b.data[3][0],
                    a.data[3][1] - b.data[3][1],
                    a.data[3][2] - b.data[3][2],
                    a.data[3][3] - b.data[3][3],
                },
            },
        };
    }
    pub const sub = subtract;

    test "substract" {
        const matA = Mat4.create(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16);
        const matB = Mat4.create(17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32);
        const out = Mat4.sub(matA, matB);
        const expected = Mat4.create(-16, -16, -16, -16, -16, -16, -16, -16, -16, -16, -16, -16, -16, -16, -16, -16);
        try expectEqual(expected, out);
    }

    ///Multiplies two Mat4
    pub fn multiply(a: Mat4, b: Mat4) Mat4 {
        return Mat4{
            .data = .{
                .{
                    b.data[0][0] * a.data[0][0] + b.data[0][1] * a.data[1][0] + b.data[0][2] * a.data[2][0] + b.data[0][3] * a.data[3][0],
                    b.data[0][0] * a.data[0][1] + b.data[0][1] * a.data[1][1] + b.data[0][2] * a.data[2][1] + b.data[0][3] * a.data[3][1],
                    b.data[0][0] * a.data[0][2] + b.data[0][1] * a.data[1][2] + b.data[0][2] * a.data[2][2] + b.data[0][3] * a.data[3][2],
                    b.data[0][0] * a.data[0][3] + b.data[0][1] * a.data[1][3] + b.data[0][2] * a.data[2][3] + b.data[0][3] * a.data[3][3],
                },

                .{
                    b.data[1][0] * a.data[0][0] + b.data[1][1] * a.data[1][0] + b.data[1][2] * a.data[2][0] + b.data[1][3] * a.data[3][0],
                    b.data[1][0] * a.data[0][1] + b.data[1][1] * a.data[1][1] + b.data[1][2] * a.data[2][1] + b.data[1][3] * a.data[3][1],
                    b.data[1][0] * a.data[0][2] + b.data[1][1] * a.data[1][2] + b.data[1][2] * a.data[2][2] + b.data[1][3] * a.data[3][2],
                    b.data[1][0] * a.data[0][3] + b.data[1][1] * a.data[1][3] + b.data[1][2] * a.data[2][3] + b.data[1][3] * a.data[3][3],
                },
                .{
                    b.data[2][0] * a.data[0][0] + b.data[2][1] * a.data[1][0] + b.data[2][2] * a.data[2][0] + b.data[2][3] * a.data[3][0],
                    b.data[2][0] * a.data[0][1] + b.data[2][1] * a.data[1][1] + b.data[2][2] * a.data[2][1] + b.data[2][3] * a.data[3][1],
                    b.data[2][0] * a.data[0][2] + b.data[2][1] * a.data[1][2] + b.data[2][2] * a.data[2][2] + b.data[2][3] * a.data[3][2],
                    b.data[2][0] * a.data[0][3] + b.data[2][1] * a.data[1][3] + b.data[2][2] * a.data[2][3] + b.data[2][3] * a.data[3][3],
                },
                .{
                    b.data[3][0] * a.data[0][0] + b.data[3][1] * a.data[1][0] + b.data[3][2] * a.data[2][0] + b.data[3][3] * a.data[3][0],
                    b.data[3][0] * a.data[0][1] + b.data[3][1] * a.data[1][1] + b.data[3][2] * a.data[2][1] + b.data[3][3] * a.data[3][1],
                    b.data[3][0] * a.data[0][2] + b.data[3][1] * a.data[1][2] + b.data[3][2] * a.data[2][2] + b.data[3][3] * a.data[3][2],
                    b.data[3][0] * a.data[0][3] + b.data[3][1] * a.data[1][3] + b.data[3][2] * a.data[2][3] + b.data[3][3] * a.data[3][3],
                },
            },
        };
    }
    pub const mul = multiply;

    test "multiply" {
        const matA = Mat4.create(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1, 2, 3, 1);
        const matB = Mat4.create(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 4, 5, 6, 1);
        const out = Mat4.mul(matA, matB);
        const expected = Mat4.create(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 5, 7, 9, 1);
        try expectEqual(expected, out);
    }

    pub fn multiplyScalar(a: Mat4, s: f32) Mat4 {
        return Mat4{
            .data = .{
                .{
                    a.data[0][0] * s,
                    a.data[0][1] * s,
                    a.data[0][2] * s,
                    a.data[0][3] * s,
                },

                .{
                    a.data[1][0] * s,
                    a.data[1][1] * s,
                    a.data[1][2] * s,
                    a.data[1][3] * s,
                },
                .{
                    a.data[2][0] * s,
                    a.data[2][1] * s,
                    a.data[2][2] * s,
                    a.data[2][3] * s,
                },
                .{
                    a.data[3][0] * s,
                    a.data[3][1] * s,
                    a.data[3][2] * s,
                    a.data[3][3] * s,
                },
            },
        };
    }

    test "multiplyScalar" {
        const matA = Mat4.create(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16);
        const out = Mat4.multiplyScalar(matA, 2.0);
        const expected = Mat4.create(2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32);
        try expectEqual(expected, out);
    }

    pub fn multiplyScalarAndAdd(a: Mat4, b: Mat4, s: f32) Mat4 {
        return Mat4{
            .data = .{
                .{
                    @mulAdd(f32, b.data[0][0], s, a.data[0][0]),
                    @mulAdd(f32, b.data[0][1], s, a.data[0][1]),
                    @mulAdd(f32, b.data[0][2], s, a.data[0][2]),
                    @mulAdd(f32, b.data[0][3], s, a.data[0][3]),
                },

                .{
                    @mulAdd(f32, b.data[1][0], s, a.data[1][0]),
                    @mulAdd(f32, b.data[1][1], s, a.data[1][1]),
                    @mulAdd(f32, b.data[1][2], s, a.data[1][2]),
                    @mulAdd(f32, b.data[1][3], s, a.data[1][3]),
                },
                .{
                    @mulAdd(f32, b.data[2][0], s, a.data[2][0]),
                    @mulAdd(f32, b.data[2][1], s, a.data[2][1]),
                    @mulAdd(f32, b.data[2][2], s, a.data[2][2]),
                    @mulAdd(f32, b.data[2][3], s, a.data[2][3]),
                },
                .{
                    @mulAdd(f32, b.data[3][0], s, a.data[3][0]),
                    @mulAdd(f32, b.data[3][1], s, a.data[3][1]),
                    @mulAdd(f32, b.data[3][2], s, a.data[3][2]),
                    @mulAdd(f32, b.data[3][3], s, a.data[3][3]),
                },
            },
        };
    }

    test "multiplyScalarAndAdd" {}

    /// Translate a mat4 by the given vector
    pub fn translate(a: Mat4, v: Vec3) Mat4 {
        return Mat4{
            .data = .{
                .{
                    a.data[0][0],
                    a.data[0][1],
                    a.data[0][2],
                    a.data[0][3],
                },
                .{
                    a.data[1][0],
                    a.data[1][1],
                    a.data[1][2],
                    a.data[1][3],
                },
                .{
                    a.data[2][0],
                    a.data[2][1],
                    a.data[2][2],
                    a.data[2][3],
                },

                .{
                    v.x * a.data[0][0] + v.y * a.data[1][0] + a.data[2][0] * v.z + a.data[3][0],
                    v.x * a.data[0][1] + v.y * a.data[1][1] + a.data[2][1] * v.z + a.data[3][1],
                    v.x * a.data[0][2] + v.y * a.data[1][2] + a.data[2][2] * v.z + a.data[3][2],
                    v.x * a.data[0][3] + v.y * a.data[1][3] + a.data[2][3] * v.z + a.data[3][3],
                },
            },
        };
    }

    test "translate" {
        const matA = Mat4.create(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1, 2, 3, 1);
        const out = Mat4.translate(matA, Vec3.create(4, 5, 6));
        const expected = Mat4.create(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 5, 7, 9, 1);
        try expectEqual(expected, out);
    }

    ///Rotates a mat4 by the given angle around the given axis
    pub fn rotate(a: Mat4, rad: f32, axis: Vec3) ?Mat4 {
        var x = axis.x;
        var y = axis.y;
        var z = axis.z;

        var l = @sqrt(x * x + y * y + z * z); //len
        if (l < utils.epsilon) return null;
        l = 1 / l;
        x *= l;
        y *= l;
        z *= l;

        const s = @sin(rad);
        const c = @cos(rad);
        const t = 1 - c;

        const b00 = x * x * t + c;
        const b01 = y * x * t + z * s;
        const b02 = z * x * t - y * s;

        const b10 = x * y * t - z * s;
        const b11 = y * y * t + c;
        const b12 = z * y * t + x * s;

        const b20 = x * z * t + y * s;
        const b21 = y * z * t - x * s;
        const b22 = z * z * t + c;

        return Mat4{
            .data = .{
                .{
                    a.data[0][0] * b00 + a.data[1][0] * b01 + a.data[2][0] * b02,
                    a.data[0][1] * b00 + a.data[1][1] * b01 + a.data[2][1] * b02,
                    a.data[0][2] * b00 + a.data[1][2] * b01 + a.data[2][2] * b02,
                    a.data[0][3] * b00 + a.data[1][3] * b01 + a.data[2][3] * b02,
                },
                .{
                    a.data[0][0] * b10 + a.data[1][0] * b11 + a.data[2][0] * b12,
                    a.data[0][1] * b10 + a.data[1][1] * b11 + a.data[2][1] * b12,
                    a.data[0][2] * b10 + a.data[1][2] * b11 + a.data[2][2] * b12,
                    a.data[0][3] * b10 + a.data[1][3] * b11 + a.data[2][3] * b12,
                },
                .{
                    a.data[0][0] * b20 + a.data[1][0] * b21 + a.data[2][0] * b22,
                    a.data[0][1] * b20 + a.data[1][1] * b21 + a.data[2][1] * b22,
                    a.data[0][2] * b20 + a.data[1][2] * b21 + a.data[2][2] * b22,
                    a.data[0][3] * b20 + a.data[1][3] * b21 + a.data[2][3] * b22,
                },
                .{
                    a.data[3][0],
                    a.data[3][1],
                    a.data[3][2],
                    a.data[3][3],
                },
            },
        };
    }

    test "rotate" {
        const rad: f32 = math.pi * 0.5;
        const axis = Vec3.create(1, 0, 0);
        const matA = Mat4.create(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1, 2, 3, 1);
        const out = Mat4.rotate(matA, rad, axis) orelse @panic("test failed");
        const expected = Mat4.create(1, 0, 0, 0, 0, @cos(rad), @sin(rad), 0, 0, -@sin(rad), @cos(rad), 0, 1, 2, 3, 1);
        try expectEqual(expected, out);
    }

    pub fn scale(a: Mat4, v: Vec3) Mat4 {
        return Mat4{
            .data = .{
                .{
                    v.x * a.data[0][0],
                    v.x * a.data[0][1],
                    v.x * a.data[0][2],
                    v.x * a.data[0][3],
                },

                .{
                    v.y * a.data[1][0],
                    v.y * a.data[1][1],
                    v.y * a.data[1][2],
                    v.y * a.data[1][3],
                },
                .{
                    v.z * a.data[2][0],
                    v.z * a.data[2][1],
                    v.z * a.data[2][2],
                    v.z * a.data[2][3],
                },
                .{
                    a.data[3][0],
                    a.data[3][1],
                    a.data[3][2],
                    a.data[3][3],
                },
            },
        };
    }

    test "scale" {
        const matA = Mat4.create(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1, 2, 3, 1);
        const out = Mat4.scale(matA, Vec3.create(4, 5, 6));
        const expected = Mat4.create(4, 0, 0, 0, 0, 5, 0, 0, 0, 0, 6, 0, 1, 2, 3, 1);
        try expectEqual(expected, out);
    }

    ///Creates a matrix from a vector translation
    pub fn fromTranslation(v: Vec3) Mat4 {
        return Mat4{
            .data = .{
                .{
                    1, 0, 0, 0,
                },

                .{
                    0, 1, 0, 0,
                },

                .{
                    0, 0, 1, 0,
                },
                .{
                    v.x, v.y, v.z, 1,
                },
            },
        };
    }

    pub fn fromRotation(rad: f32, axis: Vec3) ?Mat4 {
        var x = axis.x;
        var y = axis.y;
        var z = axis.z;

        var l = @sqrt(x * x + y * y + z * z);
        if (l < utils.epsilon) return null;
        l = 1 / l;

        x *= l;
        y *= l;
        z *= l;

        const s = @sin(rad);
        const c = @cos(rad);
        const t = 1 - c;

        return Mat4{
            .data = .{
                .{
                    x * x * t + c,
                    y * x * t + z * s,
                    z * x * t - y * s,
                    0,
                },

                .{
                    x * y * t - z * s,
                    y * y * t + c,
                    z * y * t + x * s,
                    0,
                },
                .{
                    x * z * t + y * s,
                    y * z * t - x * s,
                    z * z * t + c,
                    0,
                },
                .{
                    0, 0, 0, 1,
                },
            },
        };
    }

    pub fn fromXRotation(rad: f32) Mat4 {
        const s = @sin(rad);
        const c = @cos(rad);

        return Mat4{
            .data = .{
                .{
                    1, 0, 0, 0,
                },

                .{
                    0, c, s, 0,
                },
                .{
                    0, -s, c, 0,
                },
                .{
                    0, 0, 0, 1,
                },
            },
        };
    }

    /// Creates a matrix from the given angle around the Y axis
    pub fn fromYRotation(rad: f32) Mat4 {
        const s = @sin(rad);
        const c = @cos(rad);

        return Mat4{
            .data = .{
                .{
                    c, 0, -s, 0,
                },

                .{
                    0, 1, 0, 0,
                },
                .{
                    s, 0, c, 0,
                },
                .{
                    0, 0, 0, 1,
                },
            },
        };
    }

    /// Creates a matrix from the given angle around the Z axis
    pub fn fromZRotation(rad: f32) Mat4 {
        const s = @sin(rad);
        const c = @cos(rad);

        return Mat4{
            .data = .{
                .{
                    c, s, 0, 0,
                },

                .{
                    -s, c, 0, 0,
                },
                .{
                    0, 0, 1, 0,
                },
                .{
                    0, 0, 0, 1,
                },
            },
        };
    }

    /// Creates a matrix from a vector scaling
    pub fn fromScaling(v: Vec3) Mat4 {
        return Mat4{
            .data = .{
                .{
                    v.x, 0, 0, 0,
                },

                .{
                    0, v.y, 0, 0,
                },
                .{
                    0, 0, v.z, 0,
                },

                .{
                    0, 0, 0, 1,
                },
            },
        };
    }

    /// Returns the translation vector component of a transformation
    /// matrix. If a matrix is built with fromRotationTranslation,
    /// the returned vector will be the same as the translation vector
    /// originally supplied.
    pub fn getTranslation(m: Mat4) Vec3 {
        return Vec3.create(m.data[3][0], m.data[3][1], m.data[3][2]);
    }

    test "getTranslation - identity" {
        var out = Mat4.getTranslation(mat4_identity);
        const expected = Vec3.create(0, 0, 0);
        try Vec3.expectEqual(expected, out);
    }

    test "getTranslation - translation-only" {
        const matB = Mat4.create(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 4, 5, 6, 1);

        var out = Mat4.getTranslation(matB);
        const expected = Vec3.create(4, 5, 6);
        try Vec3.expectEqual(expected, out);
    }

    /// Returns the scaling factor component of a transformation
    /// matrix. If a matrix is built with fromRotationTranslationScale
    /// with a normalized Quaternion paramter, the returned vector will be
    /// the same as the scaling vector
    /// originally supplied.
    pub fn getScaling(m: Mat4) Vec3 {
        const m11 = m.data[0][0];
        const m12 = m.data[0][1];
        const m13 = m.data[0][2];
        const m21 = m.data[1][0];
        const m22 = m.data[1][1];
        const m23 = m.data[1][2];
        const m31 = m.data[2][0];
        const m32 = m.data[2][1];
        const m33 = m.data[2][2];

        return Vec3.create(
            @sqrt(m11 * m11 + m12 * m12 + m13 * m13),
            @sqrt(m21 * m21 + m22 * m22 + m23 * m23),
            @sqrt(m31 * m31 + m32 * m32 + m33 * m33),
        );
    }

    test "getScaling" {
        const matA = Mat4.targetTo(Vec3.create(0, 1, 0), Vec3.create(0, 0, 1), Vec3.create(0, 0, -1));
        const out = Mat4.getScaling(matA);
        const expected = Vec3.create(1, 1, 1);
        try Vec3.expectEqual(expected, out);
    }

    pub fn frustum(left: f32, right: f32, bottom: f32, top: f32, near: f32, far: f32) Mat4 {
        const rl = 1 / (right - left);
        const tb = 1 / (top - bottom);
        const nf = 1 / (near - far);

        return Mat4{
            .data = .{
                .{
                    (near * 2) * rl,
                    0,
                    0,
                    0,
                },
                .{
                    0,
                    (near * 2) * tb,
                    0,
                    0,
                },
                .{
                    (right + left) * rl,
                    (top + bottom) * tb,
                    (far + near) * nf,
                    -1,
                },
                .{
                    0,
                    0,
                    (far * near * 2) * nf,
                    0,
                },
            },
        };
    }

    test "frustum" {
        const out = Mat4.frustum(-1, 1, -1, 1, -1, 1);
        const expected = Mat4.create(-1, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, -1, 0, 0, 1, 0);
        try expectEqual(expected, out);
    }

    /// Generates a perspective projection matrix with the given bounds.
    /// Passing infinite for far will generate infinite projection matrix.
    pub fn perspective(fovy: f32, aspect: f32, near: f32, far: f32) Mat4 {
        const f = (1.0 / math.tan(fovy / 2));
        const fasp = f / aspect;

        const nf = 1 / (near - far);
        const m22 = if (!math.isInf(far)) ((far + near) * nf) else -1.0;
        const m32 = if (!math.isInf(far)) ((2 * far * near) * nf) else (-2.0 * near);

        return Mat4{
            .data = .{
                .{
                    fasp,
                    0,
                    0,
                    0,
                },
                .{
                    0,
                    f,
                    0,
                    0,
                },
                .{
                    0,
                    0,
                    m22,
                    -1,
                },
                .{
                    0,
                    0,
                    m32,
                    0,
                },
            },
        };
    }

    test "perspective" {
        const out = Mat4.perspective(math.pi * 0.5, 1, 0, 1);
        const expected = Mat4.create(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0);
        try expectEqual(expected, out);
    }

    test "perspective, 45deg fovy, realistic aspect ratio" {
        const out = Mat4.perspective(45 * math.pi / 180.0, 640.0 / 480.0, 0.1, 200);
        const expected = Mat4.create(1.81066, 0, 0, 0, 0, 2.414213, 0, 0, 0, 0, -1.001, -1, 0, 0, -0.2001, 0);
        try expectEqual(expected, out);
    }

    test "perspective, 45deg fovy, realistic aspect ratio, no far plane" {
        const out = Mat4.perspective(45 * math.pi / 180.0, 640.0 / 480.0, 0.1, math.inf_f32);
        const expected = Mat4.create(1.81066, 0, 0, 0, 0, 2.414213, 0, 0, 0, 0, -1, -1, 0, 0, -0.2, 0);
        try expectEqual(expected, out);
    }

    /// Generates a orthogonal projection matrix with the given bounds
    pub fn ortho(left: f32, right: f32, bottom: f32, top: f32, near: f32, far: f32) Mat4 {
        const lr = 1 / (left - right);
        const bt = 1 / (bottom - top);
        const nf = 1 / (near - far);

        return Mat4{
            .data = .{
                .{
                    -2 * lr,
                    0,
                    0,
                    0,
                },
                .{
                    0,
                    -2 * bt,
                    0,
                    0,
                },
                .{
                    0,
                    0,
                    2 * nf,
                    0,
                },
                .{
                    (left + right) * lr,
                    (top + bottom) * bt,
                    (far + near) * nf,
                    1,
                },
            },
        };
    }

    test "ortho" {
        const out = Mat4.ortho(-1, 1, -1, 1, -1, 1);
        const expected = Mat4.create(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, -1, 0, 0, 0, 0, 1);
        try expectEqual(expected, out);
    }

    /// Generates a look-at matrix with the given eye position, focal point, and up axis.
    /// If you want a matrix that actually makes an object look at another object, you should use targetTo instead.
    pub fn lookat(eye: Vec3, center: Vec3, up: Vec3) Mat4 {
        const eyex = eye.x;
        const eyey = eye.y;
        const eyez = eye.z;

        const upx = up.x;
        const upy = up.y;
        const upz = up.z;

        const centerx = center.x;
        const centery = center.y;
        const centerz = center.z;

        if (@fabs(eyex - centerx) < utils.epsilon and
            @fabs(eyey - centery) < utils.epsilon and
            @fabs(eyez - centerz) < utils.epsilon)
            return mat4_identity;

        var z0 = eyex - centerx;
        var z1 = eyey - centery;
        var z2 = eyez - centerz;

        var l = 1 / @sqrt(z0 * z0 + z1 * z1 + z2 * z2);
        z0 *= l;
        z1 *= l;
        z2 *= l;

        var x0 = upy * z2 - upz * z1;
        var x1 = upz * z0 - upx * z2;
        var x2 = upx * z1 - upy * z0;
        l = @sqrt(x0 * x0 + x1 * x1 + x2 * x2);
        if (l == 0) {
            x0 = 0;
            x1 = 0;
            x2 = 0;
        } else {
            l = 1 / l;
            x0 *= l;
            x1 *= l;
            x2 *= l;
        }

        var y0 = z1 * x2 - z2 * x1;
        var y1 = z2 * x0 - z0 * x2;
        var y2 = z0 * x1 - z1 * x0;

        l = @sqrt(y0 * y0 + y1 * y1 + y2 * y2);
        if (l == 0) {
            y0 = 0;
            y1 = 0;
            y2 = 0;
        } else {
            l = 1 / l;
            y0 *= l;
            y1 *= l;
            y2 *= l;
        }

        return Mat4{
            .data = .{
                .{
                    x0, y0, z0, 0,
                },
                .{
                    x1, y1, z1, 0,
                },
                .{
                    x2, y2, z2, 0,
                },
                .{
                    -(x0 * eyex + x1 * eyey + x2 * eyez),
                    -(y0 * eyex + y1 * eyey + y2 * eyez),
                    -(z0 * eyex + z1 * eyey + z2 * eyez),
                    1,
                },
            },
        };
    }

    test "lookat (down)" {
        const eye = Vec3.create(0, 0, 1);
        const center = Vec3.create(0, 0, -1);
        const view = Vec3.create(0, -1, 0);
        const up = Vec3.create(0, 0, -1);
        const right = Vec3.create(1, 0, 0);

        const out = Mat4.lookat(Vec3.create(0, 0, 0), view, up);

        var result = Vec3.transformMat4(view, out);
        try Vec3.expectEqual(result, Vec3.create(0, 0, -1));

        result = Vec3.transformMat4(up, out);
        try Vec3.expectEqual(result, Vec3.create(0, 1, 0));

        result = Vec3.transformMat4(right, out);
        try Vec3.expectEqual(result, Vec3.create(1, 0, 0));
    }

    /// Generates a matrix that makes something look at something else.
    pub fn targetTo(eye: Vec3, target: Vec3, up: Vec3) Mat4 {
        const eyex = eye.x;
        const eyey = eye.y;
        const eyez = eye.z;
        const upx = up.x;
        const upy = up.y;
        const upz = up.z;

        var z0 = eyex - target.x;
        var z1 = eyey - target.y;
        var z2 = eyez - target.z;

        var l = z0 * z0 + z1 * z1 + z2 * z2;
        if (l > 0) {
            l = 1 / @sqrt(l);
            z0 *= l;
            z1 *= l;
            z2 *= l;
        }

        var x0 = upy * z2 - upz * z1;
        var x1 = upz * z0 - upx * z2;
        var x2 = upx * z1 - upy * z0;

        l = x0 * x0 + x1 * x1 + x2 * x2;
        if (l > 0) {
            l = 1 / @sqrt(l);
            x0 *= l;
            x1 *= l;
            x2 *= l;
        }

        return Mat4{
            .data = .{
                .{
                    x0, x1, x2, 0,
                },
                .{
                    z1 * x2 - z2 * x1,
                    z2 * x0 - z0 * x2,
                    z0 * x1 - z1 * x0,
                    0,
                },
                .{
                    z0, z1, z2, 0,
                },
                .{
                    eyex, eyey, eyez, 1,
                },
            },
        };
    }

    test "targetTo (looking down)" {
        const eye = Vec3.create(0, 0, 1);
        const center = Vec3.create(0, 0, -1);
        const view = Vec3.create(0, -1, 0);
        const up = Vec3.create(0, 0, -1);
        const right = Vec3.create(1, 0, 0);

        const out = Mat4.targetTo(Vec3.create(0, 0, 0), view, up);

        var result = Vec3.transformMat4(view, out);
        try Vec3.expectEqual(result, Vec3.create(0, 0, 1));

        result = Vec3.transformMat4(up, out);
        try Vec3.expectEqual(result, Vec3.create(0, -1, 0));

        result = Vec3.transformMat4(right, out);
        try Vec3.expectEqual(result, Vec3.create(1, 0, 0));
    }

    pub fn equals(a: Mat4, b: Mat4) bool {
        const epsilon = utils.epsilon;
        const a0 = a.data[0][0];
        const a1 = a.data[0][1];
        const a2 = a.data[0][2];
        const a3 = a.data[0][3];
        const a4 = a.data[1][0];
        const a5 = a.data[1][1];
        const a6 = a.data[1][2];
        const a7 = a.data[1][3];
        const a8 = a.data[2][0];
        const a9 = a.data[2][1];
        const a10 = a.data[2][2];
        const a11 = a.data[2][3];
        const a12 = a.data[3][0];
        const a13 = a.data[3][1];
        const a14 = a.data[3][2];
        const a15 = a.data[3][3];

        const b0 = b.data[0][0];
        const b1 = b.data[0][1];
        const b2 = b.data[0][2];
        const b3 = b.data[0][3];
        const b4 = b.data[1][0];
        const b5 = b.data[1][1];
        const b6 = b.data[1][2];
        const b7 = b.data[1][3];
        const b8 = b.data[2][0];
        const b9 = b.data[2][1];
        const b10 = b.data[2][2];
        const b11 = b.data[2][3];
        const b12 = b.data[3][0];
        const b13 = b.data[3][1];
        const b14 = b.data[3][2];
        const b15 = b.data[3][3];

        return (@fabs(a0 - b0) <= epsilon * math.max(1, math.max(@fabs(a0), @fabs(b0))) and
            @fabs(a1 - b1) <= epsilon * math.max(1, math.max(@fabs(a1), @fabs(b1))) and
            @fabs(a2 - b2) <= epsilon * math.max(1, math.max(@fabs(a2), @fabs(b2))) and
            @fabs(a3 - b3) <= epsilon * math.max(1, math.max(@fabs(a3), @fabs(b3))) and
            @fabs(a4 - b4) <= epsilon * math.max(1, math.max(@fabs(a4), @fabs(b4))) and
            @fabs(a5 - b5) <= epsilon * math.max(1, math.max(@fabs(a5), @fabs(b5))) and
            @fabs(a6 - b6) <= epsilon * math.max(1, math.max(@fabs(a6), @fabs(b6))) and
            @fabs(a7 - b7) <= epsilon * math.max(1, math.max(@fabs(a7), @fabs(b7))) and
            @fabs(a8 - b8) <= epsilon * math.max(1, math.max(@fabs(a8), @fabs(b8))) and
            @fabs(a9 - b9) <= epsilon * math.max(1, math.max(@fabs(a9), @fabs(b9))) and
            @fabs(a10 - b10) <= epsilon * math.max(1, math.max(@fabs(a10), @fabs(b10))) and
            @fabs(a11 - b11) <= epsilon * math.max(1, math.max(@fabs(a11), @fabs(b11))) and
            @fabs(a12 - b12) <= epsilon * math.max(1, math.max(@fabs(a12), @fabs(b12))) and
            @fabs(a13 - b13) <= epsilon * math.max(1, math.max(@fabs(a13), @fabs(b13))) and
            @fabs(a14 - b14) <= epsilon * math.max(1, math.max(@fabs(a14), @fabs(b14))) and
            @fabs(a15 - b15) <= epsilon * math.max(1, math.max(@fabs(a15), @fabs(b15))));
    }

    pub fn exactEquals(a: Mat4, b: Mat4) bool {
        return a.data[0][0] == b.data[0][0] and
            a.data[0][1] == b.data[0][1] and
            a.data[0][2] == b.data[0][2] and
            a.data[0][3] == b.data[0][3] and
            a.data[1][0] == b.data[1][0] and
            a.data[1][1] == b.data[1][1] and
            a.data[1][2] == b.data[1][2] and
            a.data[1][3] == b.data[1][3] and
            a.data[2][0] == b.data[2][0] and
            a.data[2][1] == b.data[2][1] and
            a.data[2][2] == b.data[2][2] and
            a.data[2][3] == b.data[2][3] and
            a.data[3][0] == b.data[3][0] and
            a.data[3][1] == b.data[3][1] and
            a.data[3][2] == b.data[3][2] and
            a.data[3][3] == b.data[3][3];
    }

    pub fn format(
        value: @This(),
        comptime fmt: []const u8,
        options: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        const str = "Mat4({d:.7}, {d:.7}, {d:.7}, {d:.7}, {d:.7}, {d:.7}, {d:.7}, {d:.7}, {d:.7}, {d:.7}, {d:.7}, {d:.7}, {d:.7}, {d:.7}, {d:.7}, {d:.7}, )";
        return std.fmt.format(
            writer,
            str,
            .{
                value.data[0][0],
                value.data[0][1],
                value.data[0][2],
                value.data[0][3],
                value.data[1][0],
                value.data[1][1],
                value.data[1][2],
                value.data[1][3],
                value.data[2][0],
                value.data[2][1],
                value.data[2][2],
                value.data[2][3],
                value.data[3][0],
                value.data[3][1],
                value.data[3][2],
                value.data[3][3],
            },
        );
    }

    fn expectEqual(a: Mat4, b: Mat4) !void {
        if (!a.equals(b)) {
            std.debug.warn("Expected:\n{}, found\n{}\n", .{ a, b });
            return error.NotEqual;
        }
    }
};
