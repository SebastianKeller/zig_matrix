const testing = @import("std").testing;
const math = @import("std").math;
const Vec2 = @import("vec2.zig").Vec2;
const f_eq = @import("utils.zig").f_eq;

/// A Mat2 identity matrix
pub const mat2_identity = Mat2{
    .data = [_][2]f32{
        [_]f32{ 1.0, 0.0 },
        [_]f32{ 0.0, 1.0 },
    },
};

/// Creates a new Mat2 with the given values
pub fn mat2_values(m00: f32, m01: f32, m10: f32, m11: f32) Mat2 {
    return Mat2{
        .data = [_][2]f32{
            [_]f32{ m00, m01 },
            [_]f32{ m10, m11 },
        },
    };
}

pub const Mat2 = struct {
    data: [2][2]f32,

    pub fn identity() Mat2 {
        return mat2_identity;
    }

    pub fn create(m00: f32, m01: f32, m10: f32, m11: f32) Mat2 {
        return Mat2{
            .data = [_][2]f32{
                [_]f32{ m00, m01 },
                [_]f32{ m10, m11 },
            },
        };
    }

    pub fn transpose(m: Mat2) Mat2 {
        return Mat2{
            .data = [_][2]f32{
                [_]f32{ m.data[0][0], m.data[1][0] },
                [_]f32{ m.data[0][1], m.data[1][1] },
            },
        };
    }

    /// Inverts the matrix
    pub fn invert(m: Mat2) ?Mat2 {
        var det = m.data[0][0] * m.data[1][1] - m.data[1][0] * m.data[0][1];
        if (det == 0)
            return null;

        det = 1.0 / det;
        return Mat2{
            .data = [_][2]f32{
                [_]f32{ m.data[1][1] * det, -m.data[0][1] * det },
                [_]f32{ -m.data[1][0] * det, m.data[0][0] * det },
            },
        };
    }

    /// Calculates the adjugate
    pub fn adjoint(m: Mat2) Mat2 {
        return Mat2{
            .data = [_][2]f32{
                [_]f32{ m.data[1][1], -m.data[0][1] },
                [_]f32{ -m.data[1][0], m.data[0][0] },
            },
        };
    }

    ///Calculates the determinant
    pub fn determinant(m: Mat2) f32 {
        return m.data[0][0] * m.data[1][1] - m.data[1][0] * m.data[0][1];
    }

    ///Multiplies two Mat2
    pub fn multiply(m: Mat2, other: Mat2) Mat2 {
        return Mat2{
            .data = [_][2]f32{
                [_]f32{ m.data[0][0] * other.data[0][0] + m.data[1][0] * other.data[0][1], m.data[0][1] * other.data[0][0] + m.data[1][1] * other.data[0][1] },
                [_]f32{ m.data[0][0] * other.data[1][0] + m.data[1][0] * other.data[1][1], m.data[0][1] * other.data[1][0] + m.data[1][1] * other.data[1][1] },
            },
        };
    }
    pub const mul = multiply;

    /// Rotates the matrix by a given angle
    pub fn rotate(m: Mat2, rad: f32) Mat2 {
        const s = @sin(f32, rad);
        const c = @cos(f32, rad);

        return Mat2{
            .data = [_][2]f32{
                [_]f32{ m.data[0][0] * c + m.data[1][0] * s, m.data[0][1] * c + m.data[1][1] * s },
                [_]f32{ m.data[0][0] * -s + m.data[1][0] * c, m.data[0][1] * -s + m.data[1][1] * c },
            },
        };
    }

    ///Scales the matrix by the dimentions in the given vec2
    pub fn scale(m: Mat2, v: Vec2) Mat2 {
        return Mat2{
            .data = [_][2]f32{
                [_]f32{ m.data[0][0] * v.data[0], m.data[0][1] * v.data[0] },
                [_]f32{ m.data[1][0] * v.data[1], m.data[1][1] * v.data[1] },
            },
        };
    }

    pub fn add(m: Mat2, other: Mat2) Mat2 {
        return Mat2{
            .data = [_][2]f32{
                [_]f32{ m.data[0][0] + other.data[0][0], m.data[0][1] + other.data[0][1] },
                [_]f32{ m.data[1][0] + other.data[1][0], m.data[1][1] + other.data[1][1] },
            },
        };
    }

    pub fn substract(m: Mat2, other: Mat2) Mat2 {
        return Mat2{
            .data = [_][2]f32{
                [_]f32{ m.data[0][0] - other.data[0][0], m.data[0][1] - other.data[0][1] },
                [_]f32{ m.data[1][0] - other.data[1][0], m.data[1][1] - other.data[1][1] },
            },
        };
    }

    pub const sub = substract;

    ///Multiply each element by a scalar
    pub fn multiplyScalar(m: Mat2, s: f32) Mat2 {
        return Mat2{
            .data = [_][2]f32{
                [_]f32{ m.data[0][0] * s, m.data[0][1] * s },
                [_]f32{ m.data[1][0] * s, m.data[1][1] * s },
            },
        };
    }

    ///Creates a matrix from a given angle
    pub fn from_rotation(rad: f32) Mat2 {
        const s = @sin(f32, rad);
        const c = @cos(f32, rad);

        return Mat2{
            .data = [_][2]f32{
                [_]f32{ c, s },
                [_]f32{ -s, c },
            },
        };
    }

    ///Creates a matrix from a vector scaling
    pub fn from_scaling(v: Vec2) Mat2 {
        return Mat2{
            .data = [_][2]f32{
                [_]f32{ v.data[0], 0.0 },
                [_]f32{ 0.0, v.data[1] },
            },
        };
    }

    pub fn equals(a: Mat2, b: Mat2) bool {
        return f_eq(a.data[0][0], b.data[0][0]) //
            and f_eq(a.data[0][1], b.data[0][1]) //
            and f_eq(a.data[1][0], b.data[1][0]) //
            and f_eq(a.data[1][1], b.data[1][1]);
    }

    pub fn format(
        self: @This(),
        comptime fmt: []const u8,
        options: std.fmt.FormatOptions,
        context: var,
        comptime Errors: type,
        output: fn (@typeOf(context), []const u8) Errors!void,
    ) Errors!void {
        return std.fmt.format(context, Errors, output, "Mat2({d:.3}, {d:.3}, {d:.3}, {d:.3})", self.data[0][0], self.data[0][1], self.data[1][0], self.data[1][1]);
    }

    test "identity" {
        const out = Mat2.identity();
        const expected = Mat2{
            .data = [_][2]f32{
                [_]f32{ 1.0, 0.0 },
                [_]f32{ 0.0, 1.0 },
            },
        };

        testing.expect(Mat2.equals(out, expected));
    }

    test "transpose" {
        const matA = Mat2.create(1.0, 2.0, 3.0, 4.0);
        const out = matA.transpose();
        const expected = Mat2.create(1.0, 3.0, 2.0, 4.0);
        testing.expect(Mat2.equals(out, expected));
    }

    test "invert" {
        const matA = Mat2.create(1.0, 2.0, 3.0, 4.0);
        const out = matA.invert() orelse @panic("could not invert mat2");
        const expected = Mat2.create(-2, 1.0, 1.5, -0.5);
        testing.expect(Mat2.equals(out, expected));
    }

    test "adjoint" {
        const matA = Mat2.create(1.0, 2.0, 3.0, 4.0);
        const out = matA.adjoint();
        const expected = Mat2.create(4, -2, -3, 1);
        testing.expect(Mat2.equals(out, expected));
    }

    test "determinant" {
        const matA = Mat2.create(1.0, 2.0, 3.0, 4.0);
        const out = matA.determinant();
        testing.expectEqual(out, -2);
    }

    test "multiply" {
        const matA = Mat2.create(1.0, 2.0, 3.0, 4.0);
        const matB = Mat2.create(5.0, 6.0, 7.0, 8.0);
        const out = matA.mul(matB);
        const expected = Mat2.create(23.0, 34.0, 31.0, 46.0);

        testing.expect(Mat2.equals(out, expected));
    }

    test "rotate" {
        const matA = Mat2.create(1.0, 2.0, 3.0, 4.0);
        const out = matA.rotate(math.pi * 0.5);
        const expected = Mat2.create(3, 4.0, -1.0, -2.0);

        testing.expect(Mat2.equals(out, expected));
    }

    test "scale" {
        const matA = Mat2.create(1.0, 2.0, 3.0, 4.0);
        const out = matA.scale(Vec2.create(2, 3));
        const expected = Mat2.create(2.0, 4.0, 9.0, 12.0);

        testing.expect(Mat2.equals(out, expected));
    }

    test "add" {
        const matA = Mat2.create(1.0, 2.0, 3.0, 4.0);
        const matB = Mat2.create(5.0, 6.0, 7.0, 8.0);

        const out = matA.add(matB);
        const expected = Mat2.create(6.0, 8.0, 10.0, 12.0);

        testing.expect(Mat2.equals(out, expected));
    }

    test "substract" {
        const matA = Mat2.create(1.0, 2.0, 3.0, 4.0);
        const matB = Mat2.create(5.0, 6.0, 7.0, 8.0);

        const out = matA.sub(matB);
        const expected = Mat2.create(-4, -4, -4, -4);

        testing.expect(Mat2.equals(out, expected));
    }

    test "equals" {
        const out = mat2_identity;
        const expected = Mat2.create(1.0, 0.0, 0.0, 1.0);
        testing.expect(Mat2.equals(out, expected));

        const notExpected = Mat2.create(5.0, 6.0, 7.0, 8.0);

        testing.expect(!Mat2.equals(out, notExpected));
    }
};
