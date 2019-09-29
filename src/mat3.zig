const testing = @import("std").testing;
const math = @import("std").math;
const f_eq = @import("utils.zig").f_eq;

/// A Mat3 identity matrix
pub const mat3_identity = Mat3{
    .data = [_][3]f32{
        [_]f32{ 1.0, 0.0, 0.0 },
        [_]f32{ 0.0, 1.0, 0.0 },
        [_]f32{ 0.0, 0.0, 1.0 },
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

    /// Inverts the matrix
    pub fn invert(m: Mat3) ?Mat3 {
        const b01 = m.data[2][2] * m.data[1][1] - m.data[1][2] * m.data[2][1];
        const b11 = -m.data[2][2] * m.data[1][0] + m.data[1][2] * m.data[2][0];
        const b21 = m.data[2][1] * m.data[1][0] - m.data[1][1] * m.data[2][0];

        // Calculate the determinant
        var det = m.data[0][0] * b01 + m.data[0][1] * b11 + m.data[0][2] * b21;

        if (!det) {
            return null;
        }
        det = 1.0 / det;

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

    ///Calculates the determinant
    pub fn determinant(m: Mat3) f32 {
        return m.data[0][0] * (m.data[2][2] * m.data[1][1] - m.data[1][2] * m.data[2][1]) + m.data[0][1] * (-m.data[2][2] * m.data[1][0] + m.data[1][2] * m.data[2][0]) + m.data[0][2] * (m.data[2][1] * m.data[1][0] - m.data[1][1] * m.data[2][0]);
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

    pub fn multiplyScalarAndAdd(a: Mat3, b: Mat3, s: f32) Mat3 {
        return Mat3{
            .data = [_][3]f32{
                [_]f32{
                    a.data[0][0] + (b.data[0][0] * s),
                    a.data[0][1] + (b.data[0][1] * s),
                    a.data[0][2] + (b.data[0][2] * s),
                },

                [_]f32{
                    a.data[1][0] + (b.data[1][0] * s),
                    a.data[1][1] + (b.data[1][1] * s),
                    a.data[1][2] + (b.data[1][2] * s),
                },
                [_]f32{
                    a.data[2][0] + (b.data[2][0] * s),
                    a.data[2][1] + (b.data[2][1] * s),
                    a.data[2][2] + (b.data[2][2] * s),
                },
            },
        };
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
        const s = math.sin(rad);
        const c = math.cos(rad);

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

    pub fn scale(a: Mat3, v: vec2) Mat3 {
        const x = v.data[0];
        const y = v.data[1];

        return Mat3{
            .data = [_][3]f32{
                [_]f32{
                    x * a[0][0],
                    x * a[0][1],
                    x * a[0][2],
                },

                [_]f32{
                    y * a[1][0],
                    y * a[1][1],
                    y * a[1][2],
                },
                [_]f32{
                    a[2][0],
                    a[2][1],
                    a[2][2],
                },
            },
        };
    }

    pub fn fromTranslation(v: Vec2) Mat3 {
        const x = v.data[0];
        const y = v.data[1];

        return Mat3{
            .data = [_][3]f32{
                [_]f32{
                    1.0, 0.0, 0.0,
                },

                [_]f32{
                    0.0, 1.0, 0.0,
                },
                [_]f32{
                    x, y, 1.0,
                },
            },
        };
    }

    pub fn fromRotation(rad: f32) Mat3 {
        const sin = math.sin(rad);
        const cos = math.cos(rad);

        return Mat3{
            .data = [_][3]f32{
                [_]f32{
                    cos, sin, 0.0,
                },

                [_]f32{
                    -sin, cos, 0.0,
                },
                [_]f32{
                    0.0, 0.0, 1.0,
                },
            },
        };
    }

    pub fn fromScaling(v: Vec2) Mat3 {
        return Mat3{
            .data = [_][3]f32{
                [_]f32{
                    v.data[0], 0.0, 0.0,
                },

                [_]f32{
                    0.0, v.data[1], 0.0,
                },
                [_]f32{
                    0.0, 0.0, 1.0,
                },
            },
        };
    }

    pub fn normalFromMat4(a: Mat3) Mat3 {
        const b00 = a.data[0][0] * a.data[1][1] - a.data[0][1] * a.data[1][0];
        const b01 = a.data[0][0] * a.data[1][2] - a.data[0][2] * a.data[1][0];
        const b02 = a.data[0][0] * a.data[1][3] - a.data[0][3] * a.data[1][0];
        const b03 = a.data[0][1] * a.data[1][2] - a.data[0][2] * a.data[1][1];
        const b04 = a.data[0][1] * a.data[1][3] - a.data[0][3] * a.data[1][1];
        const b05 = a.data[0][2] * a.data[1][3] - a.data[0][3] * a.data[1][2];
        const b06 = a.data[2][0] * a.data[3][1] - a.data[2][1] * a.data[3][0];
        const b07 = a.data[2][0] * a.data[3][2] - a.data[2][2] * a.data[3][0];
        const b08 = a.data[2][0] * a.data[3][3] - a.data[2][3] * a.data[3][0];
        const b09 = a.data[2][1] * a.data[3][2] - a.data[2][2] * a.data[3][1];
        const b10 = a.data[2][1] * a.data[3][3] - a.data[2][3] * a.data[3][1];
        const b11 = a.data[2][2] * a.data[3][3] - a.data[2][3] * a.data[3][2];

        // Calculate the determinant
        var det = b00 * b11 - b01 * b10 + b02 * b09 + b03 * b08 - b04 * b07 + b05 * b06;

        if (!det) {
            return null;
        }
        det = 1.0 / det;

        return Mat3{
            .data = [_][3]f32{
                [_]f32{
                    (a.data[1][1] * b11 - a.data[1][2] * b10 + a.data[1][3] * b09) * det,
                    (a.data[1][2] * b08 - a.data[1][0] * b11 - a.data[1][3] * b07) * det,
                    (a.data[1][0] * b10 - a.data[1][1] * b08 + a.data[1][3] * b06) * det,
                },

                [_]f32{
                    (a.data[0][2] * b10 - a.data[0][1] * b11 - a.data[0][3] * b09) * det,
                    (a.data[0][0] * b11 - a.data[0][2] * b08 + a.data[0][3] * b07) * det,
                    (a.data[0][1] * b08 - a.data[0][0] * b10 - a.data[0][3] * b06) * det,
                },
                [_]f32{
                    (a.data[3][1] * b05 - a.data[3][2] * b04 + a.data[3][3] * b03) * det,
                    (a.data[3][2] * b02 - a.data[3][0] * b05 - a.data[3][3] * b01) * det,
                    (a.data[3][0] * b04 - a.data[3][1] * b02 + a.data[3][3] * b00) * det,
                },
            },
        };
    }

    pub fn projection(width: f32, height: f32) Mat3 {
        return Mat3{
            .data = [_][3]f32{
                [_]f32{
                    2.0 / width, 0.0, 0.0,
                },

                [_]f32{
                    0.0, -2 / height, 0.0,
                },
                [_]f32{
                    -1.0, 1.0, 1.0,
                },
            },
        };
    }

    pub fn frob(a: Mat3) f32 {
        return -1;
        //return(Math.hypot(a[0],a[1],a[2],a[3],a[4],a[5],a[6],a[7],a[8]))
    }

    pub fn equals(a: Mat3, b: Mat3) bool {
        const epsilon = 0.000001;
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
        return (math.abs(a0 - b0) <= epsilon * math.max(1.0, math.max(math.abs(a0), math.abs(b0))) and
            math.abs(a1 - b1) <= epsilon * math.max(1.0, math.max(math.abs(a1), math.abs(b1))) and
            math.abs(a2 - b2) <= epsilon * math.max(1.0, math.max(math.abs(a2), math.abs(b2))) and
            math.abs(a3 - b3) <= epsilon * math.max(1.0, math.max(math.abs(a3), math.abs(b3))) and
            math.abs(a4 - b4) <= epsilon * math.max(1.0, math.max(math.abs(a4), math.abs(b4))) and
            math.abs(a5 - b5) <= epsilon * math.max(1.0, math.max(math.abs(a5), math.abs(b5))) and
            math.abs(a6 - b6) <= epsilon * math.max(1.0, math.max(math.abs(a6), math.abs(b6))) and
            math.abs(a7 - b7) <= epsilon * math.max(1.0, math.max(math.abs(a7), math.abs(b7))) and
            math.abs(a8 - b8) <= epsilon * math.max(1.0, math.max(math.abs(a8), math.abs(b8))));
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
};
