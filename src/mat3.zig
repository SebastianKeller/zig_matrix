const std = @import("std");
const testing = std.testing;
const math = std.math;
const f_eq = @import("utils.zig").f_eq;
const Vec2 = @import("vec2.zig").Vec2;

/// A Mat3 identity matrix
pub const mat3_identity = Mat3{
    .data = [_][3]f32{
        [_]f32{ 1, 0, 0 },
        [_]f32{ 0, 1, 0 },
        [_]f32{ 0, 0, 1 },
    },
};

pub const Mat3 = struct {
    data: [3][3]f32,

    pub fn identity() Mat3 {
        return mat3_identity;
    }

    pub fn create(m00: f32, m01: f32, m02: f32, m10: f32, m11: f32, m12: f32, m20: f32, m21: f32, m22: f32) Mat3 {
        return Mat3{
            .data = [_][3]f32{
                [_]f32{ m00, m01, m02 },
                [_]f32{ m10, m11, m12 },
                [_]f32{ m20, m21, m22 },
            },
        };
    }

    pub fn transpose(m: Mat3) Mat3 {
        return Mat3{
            .data = [_][3]f32{
                [_]f32{ m.data[0][0], m.data[1][0], m.data[2][0] },
                [_]f32{ m.data[0][1], m.data[1][1], m.data[2][1] },
                [_]f32{ m.data[0][2], m.data[1][2], m.data[2][2] },
            },
        };
    }

    test "transpose" {
        const matA = Mat3.create( //
            1, 0, 0, //
            0, 1, 0, //
            1, 2, 1);

        const out = matA.transpose();
        const expected = Mat3.create( //
            1, 0, 1, //
            0, 1, 2, //
            0, 0, 1);

        expectEqual(expected, out);
    }

    /// Inverts the matrix
    pub fn invert(m: Mat3) ?Mat3 {
        const b01 = m.data[2][2] * m.data[1][1] - m.data[1][2] * m.data[2][1];
        const b11 = -m.data[2][2] * m.data[1][0] + m.data[1][2] * m.data[2][0];
        const b21 = m.data[2][1] * m.data[1][0] - m.data[1][1] * m.data[2][0];

        // Calculate the determinant
        var det = m.data[0][0] * b01 + m.data[0][1] * b11 + m.data[0][2] * b21;

        if (det == 0) {
            return null;
        }
        det = 1 / det;

        return Mat3{
            .data = [_][3]f32{
                [_]f32{
                    b01 * det,
                    (-m.data[2][2] * m.data[0][1] + m.data[0][2] * m.data[2][1]) * det,
                    (m.data[1][2] * m.data[0][1] - m.data[0][2] * m.data[1][1]) * det,
                },
                [_]f32{
                    b11 * det,
                    (m.data[2][2] * m.data[0][0] - m.data[0][2] * m.data[2][0]) * det,
                    (-m.data[1][2] * m.data[0][0] + m.data[0][2] * m.data[1][0]) * det,
                },
                [_]f32{
                    b21 * det,
                    (-m.data[2][1] * m.data[0][0] + m.data[0][1] * m.data[2][0]) * det,
                    (m.data[1][1] * m.data[0][0] - m.data[0][1] * m.data[1][0]) * det,
                },
            },
        };
    }

    test "invert" {
        const matA = Mat3.create( //
            1, 0, 0, //
            0, 1, 0, //
            1, 2, 1);

        const out = matA.invert() orelse @panic("test failed");
        const expected = Mat3.create( //
            1, 0, 0, //
            0, 1, 0, //
            -1, -2, 1);

        expectEqual(expected, out);
    }

    /// Calculates the adjugate
    pub fn adjoint(m: Mat3) Mat3 {
        return Mat3{
            .data = [_][3]f32{
                [_]f32{
                    (m.data[1][1] * m.data[2][2] - m.data[1][2] * m.data[2][1]),
                    (m.data[0][2] * m.data[2][1] - m.data[0][1] * m.data[2][2]),
                    (m.data[0][1] * m.data[1][2] - m.data[0][2] * m.data[1][1]),
                },
                [_]f32{
                    (m.data[1][2] * m.data[2][0] - m.data[1][0] * m.data[2][2]),
                    (m.data[0][0] * m.data[2][2] - m.data[0][2] * m.data[2][0]),
                    (m.data[0][2] * m.data[1][0] - m.data[0][0] * m.data[1][2]),
                },
                [_]f32{
                    (m.data[1][0] * m.data[2][1] - m.data[1][1] * m.data[2][0]),
                    (m.data[0][1] * m.data[2][0] - m.data[0][0] * m.data[2][1]),
                    (m.data[0][0] * m.data[1][1] - m.data[0][1] * m.data[1][0]),
                },
            },
        };
    }

    test "adjoint" {
        const matA = Mat3.create( //
            1, 0, 0, //
            0, 1, 0, //
            1, 2, 1);

        const out = matA.adjoint();
        const expected = Mat3.create( //
            1, 0, 0, //
            0, 1, 0, //
            -1, -2, 1);

        expectEqual(expected, out);
    }

    ///Calculates the determinant
    pub fn determinant(m: Mat3) f32 {
        return m.data[0][0] * (m.data[2][2] * m.data[1][1] - m.data[1][2] * m.data[2][1]) //
            + m.data[0][1] * (-m.data[2][2] * m.data[1][0] + m.data[1][2] * m.data[2][0]) //
            + m.data[0][2] * (m.data[2][1] * m.data[1][0] - m.data[1][1] * m.data[2][0]);
    }

    test "determinant" {
        const matA = Mat3.create( //
            1, 0, 0, //
            0, 1, 0, //
            1, 2, 1);

        const out = matA.determinant();
        testing.expectEqual(out, 1);
    }

    pub fn add(a: Mat3, b: Mat3) Mat3 {
        return Mat3{
            .data = [_][3]f32{
                [_]f32{
                    a.data[0][0] + b.data[0][0],
                    a.data[0][1] + b.data[0][1],
                    a.data[0][2] + b.data[0][2],
                },

                [_]f32{
                    a.data[1][0] + b.data[1][0],
                    a.data[1][1] + b.data[1][1],
                    a.data[1][2] + b.data[1][2],
                },
                [_]f32{
                    a.data[2][0] + b.data[2][0],
                    a.data[2][1] + b.data[2][1],
                    a.data[2][2] + b.data[2][2],
                },
            },
        };
    }

    test "add" {
        const matA = Mat3.create(1, 2, 3, 4, 5, 6, 7, 8, 9);
        const matB = Mat3.create(10, 11, 12, 13, 14, 15, 16, 17, 18);

        const out = Mat3.add(matA, matB);
        const expected = Mat3.create( //
            11, 13, 15, //
            17, 19, 21, //
            23, 25, 27);

        expectEqual(expected, out);
    }

    pub fn subtract(a: Mat3, b: Mat3) Mat3 {
        return Mat3{
            .data = [_][3]f32{
                [_]f32{
                    a.data[0][0] - b.data[0][0],
                    a.data[0][1] - b.data[0][1],
                    a.data[0][2] - b.data[0][2],
                },

                [_]f32{
                    a.data[1][0] - b.data[1][0],
                    a.data[1][1] - b.data[1][1],
                    a.data[1][2] - b.data[1][2],
                },
                [_]f32{
                    a.data[2][0] - b.data[2][0],
                    a.data[2][1] - b.data[2][1],
                    a.data[2][2] - b.data[2][2],
                },
            },
        };
    }
    pub const sub = subtract;

    test "substract" {
        const matA = Mat3.create(1, 2, 3, 4, 5, 6, 7, 8, 9);
        const matB = Mat3.create(10, 11, 12, 13, 14, 15, 16, 17, 18);

        const out = Mat3.sub(matA, matB);
        const expected = Mat3.create( //
            -9, -9, -9, //
            -9, -9, -9, //
            -9, -9, -9);

        expectEqual(expected, out);
    }

    ///Multiplies two Mat3
    pub fn multiply(a: Mat3, b: Mat3) Mat3 {
        return Mat3{
            .data = [_][3]f32{
                [_]f32{
                    b.data[0][0] * a.data[0][0] + b.data[0][1] * a.data[1][0] + b.data[0][2] * a.data[2][0],
                    b.data[0][0] * a.data[0][1] + b.data[0][1] * a.data[1][1] + b.data[0][2] * a.data[2][1],
                    b.data[0][0] * a.data[0][2] + b.data[0][1] * a.data[1][2] + b.data[0][2] * a.data[2][2],
                },

                [_]f32{
                    b.data[1][0] * a.data[0][0] + b.data[1][1] * a.data[1][0] + b.data[1][2] * a.data[2][0],
                    b.data[1][0] * a.data[0][1] + b.data[1][1] * a.data[1][1] + b.data[1][2] * a.data[2][1],
                    b.data[1][0] * a.data[0][2] + b.data[1][1] * a.data[1][2] + b.data[1][2] * a.data[2][2],
                },
                [_]f32{
                    b.data[2][0] * a.data[0][0] + b.data[2][1] * a.data[1][0] + b.data[2][2] * a.data[2][0],
                    b.data[2][0] * a.data[0][1] + b.data[2][1] * a.data[1][1] + b.data[2][2] * a.data[2][1],
                    b.data[2][0] * a.data[0][2] + b.data[2][1] * a.data[1][2] + b.data[2][2] * a.data[2][2],
                },
            },
        };
    }
    pub const mul = multiply;

    test "multiply" {
        const matA = Mat3.create( //
            1, 0, 0, //
            0, 1, 0, //
            1, 2, 1);

        const matB = Mat3.create( //
            1, 0, 0, //
            0, 1, 0, //
            3, 4, 1);

        const out = Mat3.mul(matA, matB);
        const expected = Mat3.create( //
            1, 0, 0, //
            0, 1, 0, //
            4, 6, 1);

        expectEqual(expected, out);
    }

    pub fn multiplyScalar(a: Mat3, s: f32) Mat3 {
        return Mat3{
            .data = [_][3]f32{
                [_]f32{
                    a.data[0][0] * s,
                    a.data[0][1] * s,
                    a.data[0][2] * s,
                },

                [_]f32{
                    a.data[1][0] * s,
                    a.data[1][1] * s,
                    a.data[1][2] * s,
                },
                [_]f32{
                    a.data[2][0] * s,
                    a.data[2][1] * s,
                    a.data[2][2] * s,
                },
            },
        };
    }

    test "multiplyScalar" {
        const matA = Mat3.create( //
            1, 2, 3, //
            4, 5, 6, //
            7, 8, 9);

        const out = matA.multiplyScalar(2);
        const expected = Mat3.create( //
            2, 4, 6, //
            8, 10, 12, //
            14, 16, 18);

        expectEqual(expected, out);
    }

    pub fn multiplyScalarAndAdd(a: Mat3, b: Mat3, s: f32) Mat3 {
        return Mat3{
            .data = [_][3]f32{
                [_]f32{
                    @mulAdd(f32, b.data[0][0], s, a.data[0][0]),
                    @mulAdd(f32, b.data[0][1], s, a.data[0][1]),
                    @mulAdd(f32, b.data[0][2], s, a.data[0][2]),
                },

                [_]f32{
                    @mulAdd(f32, b.data[1][0], s, a.data[1][0]),
                    @mulAdd(f32, b.data[1][1], s, a.data[1][1]),
                    @mulAdd(f32, b.data[1][2], s, a.data[1][2]),
                },
                [_]f32{
                    @mulAdd(f32, b.data[2][0], s, a.data[2][0]),
                    @mulAdd(f32, b.data[2][1], s, a.data[2][1]),
                    @mulAdd(f32, b.data[2][2], s, a.data[2][2]),
                },
            },
        };
    }

    test "multiplyScalarAndAdd" {
        const matA = Mat3.create(1, 2, 3, 4, 5, 6, 7, 8, 9);
        const matB = Mat3.create(10, 11, 12, 13, 14, 15, 16, 17, 18);

        const out = Mat3.multiplyScalarAndAdd(matA, matB, 0.5);
        const expected = Mat3.create(6, 7.5, 9, 10.5, 12, 13.5, 15, 16.5, 18);

        expectEqual(expected, out);
    }

    pub fn translate(a: Mat3, b: Vec2) Mat3 {
        return Mat3{
            .data = [_][3]f32{
                [_]f32{
                    a.data[0][0],
                    a.data[0][1],
                    a.data[0][2],
                },

                [_]f32{
                    a.data[1][0],
                    a.data[1][1],
                    a.data[1][2],
                },
                [_]f32{
                    b.data[0] * a.data[0][0] + b.data[1] * a.data[1][0] + a.data[2][0],
                    b.data[0] * a.data[0][1] + b.data[1] * a.data[1][1] + a.data[2][1],
                    b.data[0] * a.data[0][2] + b.data[1] * a.data[1][2] + a.data[2][2],
                },
            },
        };
    }

    pub fn rotate(a: Mat3, rad: f32) Mat3 {
        const s = @sin(f32, rad);
        const c = @cos(f32, rad);

        return Mat3{
            .data = [_][3]f32{
                [_]f32{
                    c * a.data[0][0] + s * a.data[1][0],
                    c * a.data[0][1] + s * a.data[1][1],
                    c * a.data[0][2] + s * a.data[1][2],
                },

                [_]f32{
                    c * a.data[1][0] - s * a.data[0][0],
                    c * a.data[1][1] - s * a.data[0][1],
                    c * a.data[1][2] - s * a.data[0][2],
                },
                [_]f32{
                    a.data[2][0],
                    a.data[2][1],
                    a.data[2][2],
                },
            },
        };
    }

    pub fn scale(a: Mat3, v: Vec2) Mat3 {
        const x = v.data[0];
        const y = v.data[1];

        return Mat3{
            .data = [_][3]f32{
                [_]f32{
                    x * a.data[0][0],
                    x * a.data[0][1],
                    x * a.data[0][2],
                },

                [_]f32{
                    y * a.data[1][0],
                    y * a.data[1][1],
                    y * a.data[1][2],
                },
                [_]f32{
                    a.data[2][0],
                    a.data[2][1],
                    a.data[2][2],
                },
            },
        };
    }

    test "scale" {
        const matA = Mat3.create( //
            1, 0, 0, //
            0, 1, 0, //
            1, 2, 1);

        const matB = Mat3.create( //
            1, 0, 0, //
            0, 1, 0, //
            3, 4, 1);

        const out = matA.scale(Vec2.create(2, 2));
        const expected = Mat3.create( //
            2, 0, 0, //
            0, 2, 0, //
            1, 2, 1);

        expectEqual(expected, out);
    }

    pub fn fromTranslation(v: Vec2) Mat3 {
        const x = v.data[0];
        const y = v.data[1];

        return Mat3{
            .data = [_][3]f32{
                [_]f32{
                    1, 0, 0,
                },

                [_]f32{
                    0, 1, 0,
                },
                [_]f32{
                    x, y, 1,
                },
            },
        };
    }

    pub fn fromRotation(rad: f32) Mat3 {
        const sin = @sin(f32, rad);
        const cos = @cos(f32, rad);

        return Mat3{
            .data = [_][3]f32{
                [_]f32{
                    cos, sin, 0,
                },

                [_]f32{
                    -sin, cos, 0,
                },
                [_]f32{
                    0, 0, 1,
                },
            },
        };
    }

    pub fn fromScaling(v: Vec2) Mat3 {
        return Mat3{
            .data = [_][3]f32{
                [_]f32{
                    v.data[0], 0, 0,
                },

                [_]f32{
                    0, v.data[1], 0,
                },
                [_]f32{
                    0, 0, 1,
                },
            },
        };
    }

    //pub fn normalFromMat4(a: Mat4) Mat3 {
    //    const b00 = a.data[0][0] * a.data[1][1] - a.data[0][1] * a.data[1][0];
    //    const b01 = a.data[0][0] * a.data[1][2] - a.data[0][2] * a.data[1][0];
    //    const b02 = a.data[0][0] * a.data[1][3] - a.data[0][3] * a.data[1][0];
    //    const b03 = a.data[0][1] * a.data[1][2] - a.data[0][2] * a.data[1][1];
    //    const b04 = a.data[0][1] * a.data[1][3] - a.data[0][3] * a.data[1][1];
    //    const b05 = a.data[0][2] * a.data[1][3] - a.data[0][3] * a.data[1][2];
    //    const b06 = a.data[2][0] * a.data[3][1] - a.data[2][1] * a.data[3][0];
    //    const b07 = a.data[2][0] * a.data[3][2] - a.data[2][2] * a.data[3][0];
    //    const b08 = a.data[2][0] * a.data[3][3] - a.data[2][3] * a.data[3][0];
    //    const b09 = a.data[2][1] * a.data[3][2] - a.data[2][2] * a.data[3][1];
    //    const b10 = a.data[2][1] * a.data[3][3] - a.data[2][3] * a.data[3][1];
    //    const b11 = a.data[2][2] * a.data[3][3] - a.data[2][3] * a.data[3][2];

    //    // Calculate the determinant
    //    var det = b00 * b11 - b01 * b10 + b02 * b09 + b03 * b08 - b04 * b07 + b05 * b06;

    //    if (!det) {
    //        return null;
    //    }
    //    det = 1 / det;

    //    return Mat3{
    //        .data = [_][3]f32{
    //            [_]f32{
    //                (a.data[1][1] * b11 - a.data[1][2] * b10 + a.data[1][3] * b09) * det,
    //                (a.data[1][2] * b08 - a.data[1][0] * b11 - a.data[1][3] * b07) * det,
    //                (a.data[1][0] * b10 - a.data[1][1] * b08 + a.data[1][3] * b06) * det,
    //            },

    //            [_]f32{
    //                (a.data[0][2] * b10 - a.data[0][1] * b11 - a.data[0][3] * b09) * det,
    //                (a.data[0][0] * b11 - a.data[0][2] * b08 + a.data[0][3] * b07) * det,
    //                (a.data[0][1] * b08 - a.data[0][0] * b10 - a.data[0][3] * b06) * det,
    //            },
    //            [_]f32{
    //                (a.data[3][1] * b05 - a.data[3][2] * b04 + a.data[3][3] * b03) * det,
    //                (a.data[3][2] * b02 - a.data[3][0] * b05 - a.data[3][3] * b01) * det,
    //                (a.data[3][0] * b04 - a.data[3][1] * b02 + a.data[3][3] * b00) * det,
    //            },
    //        },
    //    };
    //}

    pub fn projection(width: f32, height: f32) Mat3 {
        return Mat3{
            .data = [_][3]f32{
                [_]f32{
                    2 / width, 0, 0,
                },

                [_]f32{
                    0, -2 / height, 0,
                },
                [_]f32{
                    -1, 1, 1,
                },
            },
        };
    }

    test "projection" {
        const out = Mat3.projection(100, 200);
        const expected = Mat3.create(0.02, 0, 0, 0, -0.01, 0, -1, 1, 1);

        expectEqual(expected, out);
    }

    //pub fn frob(a: Mat3) f32 {
    //    return -1;
    //    //return(Math.hypot(a[0],a[1],a[2],a[3],a[4],a[5],a[6],a[7],a[8]))
    //}

    pub fn equals(a: Mat3, b: Mat3) bool {
        const epsilon = 000001;
        const a0 = a.data[0][0];
        const a1 = a.data[0][1];
        const a2 = a.data[0][2];
        const a3 = a.data[1][0];
        const a4 = a.data[1][1];
        const a5 = a.data[1][2];
        const a6 = a.data[2][0];
        const a7 = a.data[2][1];
        const a8 = a.data[2][2];
        const b0 = b.data[0][0];
        const b1 = b.data[0][1];
        const b2 = b.data[0][2];
        const b3 = b.data[1][0];
        const b4 = b.data[1][1];
        const b5 = b.data[1][2];
        const b6 = b.data[2][0];
        const b7 = b.data[2][1];
        const b8 = b.data[2][2];
        return (@fabs(f32, a0 - b0) <= epsilon * math.max(1, math.max(@fabs(f32, a0), @fabs(f32, b0))) and
            @fabs(f32, a1 - b1) <= epsilon * math.max(1, math.max(@fabs(f32, a1), @fabs(f32, b1))) and
            @fabs(f32, a2 - b2) <= epsilon * math.max(1, math.max(@fabs(f32, a2), @fabs(f32, b2))) and
            @fabs(f32, a3 - b3) <= epsilon * math.max(1, math.max(@fabs(f32, a3), @fabs(f32, b3))) and
            @fabs(f32, a4 - b4) <= epsilon * math.max(1, math.max(@fabs(f32, a4), @fabs(f32, b4))) and
            @fabs(f32, a5 - b5) <= epsilon * math.max(1, math.max(@fabs(f32, a5), @fabs(f32, b5))) and
            @fabs(f32, a6 - b6) <= epsilon * math.max(1, math.max(@fabs(f32, a6), @fabs(f32, b6))) and
            @fabs(f32, a7 - b7) <= epsilon * math.max(1, math.max(@fabs(f32, a7), @fabs(f32, b7))) and
            @fabs(f32, a8 - b8) <= epsilon * math.max(1, math.max(@fabs(f32, a8), @fabs(f32, b8))));
    }

    pub fn exactEquals(a: Mat3, b: Mat3) bool {
        return a.data[0][0] == b.data[0][0] and
            a.data[0][1] == b.data[0][1] and
            a.data[0][2] == b.data[0][2] and
            a.data[1][0] == b.data[1][0] and
            a.data[1][1] == b.data[1][1] and
            a.data[1][2] == b.data[1][2] and
            a.data[2][0] == b.data[2][0] and
            a.data[2][1] == b.data[2][1] and
            a.data[2][2] == b.data[2][2];
    }

    pub fn format(
        self: @This(),
        comptime fmt: []const u8,
        options: std.fmt.FormatOptions,
        context: var,
        comptime Errors: type,
        output: fn (@typeOf(context), []const u8) Errors!void,
    ) Errors!void {
        const str = "Mat3({d:.3}, {d:.3}, {d:.3}, {d:.3}, {d:.3}, {d:.3}, {d:.3}, {d:.3}, {d:.3})";
        return std.fmt.format(context, Errors, output, str, //
            self.data[0][0], self.data[0][1], self.data[0][2], //
            self.data[1][0], self.data[1][1], self.data[1][2], //
            self.data[2][0], self.data[2][1], self.data[2][2]);
    }

    fn expectEqual(a: Mat3, b: Mat3) void {
        if (!a.equals(b)) {
            std.debug.warn("Expected: {}, found {}\n", a, b);
            @panic("test failed");
        }
    }
};
