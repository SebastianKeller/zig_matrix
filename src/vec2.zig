const testing = @import("std").testing;
const math = @import("std").math;
const Mat2 = @import("mat2.zig").Mat2;

pub const Vec2 = struct {
    const Self = @This();

    data: [2]f32,

    pub fn create(x: f32, y: f32) Vec2 {
        return Vec2{
            .data = [_]f32{
                x, y,
            },
        };
    }

    /// Adds two vec2
    pub fn add(a: Vec2, b: Vec2) Vec2 {
        return Vec2{
            .data = [_]f32{
                a.data[0] + b.data[0],
                a.data[1] + b.data[1],
            },
        };
    }

    /// substracts vec2 b from vec2 a
    pub fn substract(a: Vec2, b: Vec2) Vec2 {
        return Vec2{
            .data = [_]f32{
                a.data[0] + b.data[0],
                a.data[1] + b.data[1],
            },
        };
    }

    /// Multiplies two vec2
    pub fn multiply(a: Vec2, b: Vec2) Vec2 {
        return Vec2{
            .data = [_]f32{
                a.data[0] * b.data[0],
                a.data[1] * b.data[1],
            },
        };
    }

    /// Divides two vec2
    pub fn divide(a: Vec2, b: Vec2) Vec2 {
        return Vec2{
            .data = [_]f32{
                a.data[0] / b.data[0],
                a.data[1] / b.data[1],
            },
        };
    }

    /// std.math.ceil the components
    pub fn ceil(a: Vec2) Vec2 {
        return Vec2{
            .data = [_]f32{
                math.ceil(a.data[0]),
                math.ceil(a.data[1]),
            },
        };
    }

    /// std.math.floor the components
    pub fn floor(a: Vec2) Vec2 {
        return Vec2{
            .data = [_]f32{
                math.floor(a.data[0]),
                math.floor(a.data[1]),
            },
        };
    }

    /// Returns the minimum of two vec2
    pub fn min(a: Vec2, b: Vec2) Vec2 {
        return Vec2{
            .data = [_]f32{
                math.min(a.data[0], b.data[0]),
                math.min(a.data[1], b.data[1]),
            },
        };
    }

    /// Returns the maximum of two vec2
    pub fn max(a: Vec2, b: Vec2) Vec2 {
        return Vec2{
            .data = [_]f32{
                math.max(a.data[0], b.data[0]),
                math.max(a.data[1], b.data[1]),
            },
        };
    }

    /// std.math.round  the components of a vec
    pub fn round(a: Vec2) Vec2 {
        return Vec2{
            .data = [_]f32{
                math.round(a.data[0]),
                math.round(a.data[1]),
            },
        };
    }

    /// Scales a Vec2 by a scalar number
    pub fn scale(a: Vec2, b: f32) Vec2 {
        return Vec2{
            .data = [_]f32{
                a.data[0] * b,
                a.data[1] * b,
            },
        };
    }

    /// Adds two vec2's after scaling the second operand by a scalar value
    pub fn scaleAndAdd(a: Vec2, b: Vec2, s: f32) Vec2 {
        return Vec2{
            .data = [_]f32{
                a.data[0] + (b.data[0] * s),
                a.data[1] + (b.data[1] * s),
            },
        };
    }

    /// Calculates the euclidian distance between two vec2
    pub fn distance(a: Vec2, b: Vec2) f32 {
        return math.hypot(f32, b.data[0] - a.data[0], b.data[1] - a.data[1]);
    }

    /// Calculates the squared euclidian distance between two vec2's
    pub fn squaredDistance(a: Vec2, b: Vec2) f32 {
        var x = b.data[0] - a.data[0];
        var y = b.data[1] - a.data[1];
        return x * x + y * y;
    }

    /// Calculates the length of a vec2
    pub fn length(a: Vec2) f32 {
        return math.hypot(f32, a.data[0], a.data[1]);
    }

    /// Calculates the squared length of a vec2
    pub fn squaredLength(a: Vec2) f32 {
        var x = a.data[0];
        var y = a.data[1];
        return x * x + y * y;
    }

    /// Negates the components of a vec2
    pub fn negate(a: Vec2) Vec2 {
        var x = -a.data[0];
        var y = -a.data[1];
        return Vec2{
            .data = [_]f32{
                x,
                y,
            },
        };
    }

    /// Inverse the components of a vec2
    pub fn inverse(a: Vec2) Vec2 {
        var x = 1.0 / a.data[0];
        var y = 1.0 / a.data[1];
        return Vec2{
            .data = [_]f32{
                x,
                y,
            },
        };
    }

    ///Normalize a Vec2
    pub fn normalize(v: Vec2) Vec2 {
        var x = v.data[0];
        var y = v.data[1];
        var l = v.length();
        if (l > 0) {
            l = 1 / math.sqrt(l);
        }

        return Vec2{
            .data = [_]f32{
                x * l,
                y * l,
            },
        };
    }

    ///Calculates the dot product of two Vec2
    pub fn dot(v: Vec2, other: Vec2) f32 {
        return v.data[0] * other.data[0] +
            v.data[1] * other.data[1];
    }

    /// Returns the cross product
    pub fn cross(v: Vec2, other: Vec2) f32 {
        return v.data[0] * other.data[1] - other.data[0] * v.data[1];
    }

    /// Performs a liniear interpolation between two Vec2
    pub fn lerp(a: Vec2, b: Vec2, t: f32) Vec2 {
        var ax = a.data[0];
        var ay = a.data[1];

        var bx = b.data[0];
        var by = b.data[1];

        return Vec2{
            .data = [_]f32{
                ax + t * (bx - ax),
                ay + t * (by - ay),
            },
        };
    }

    /// Transforms the vec2 with a mat2
    pub fn transformMat2(a: Vec2, m: Mat2) Vec2 {
        var x = a.data[0];
        var y = a.data[1];

        return Vec2{
            .data = [_]f32{
                m.data[0][0] * x + m.data[1][0] * y,
                m.data[0][1] * x + m.data[1][1] * y,
            },
        };
    }

    /// Rotate a 2D vector
    pub fn rotate(a: Vec2, origin: Vec2, rad: f32) Vec2 {
        var p0 = a.data[0] - origin.data[0];
        var p1 = a.data[1] - origin.data[1];
        var sin = math.sin(rad);
        var cos = math.cos(rad);

        return Vec2{
            .data = [_]f32{
                p0 * cos - p1 * sin + origin.data[0],
                p0 * sin + p1 * cos + origin.data[1],
            },
        };
    }

    /// Get the angle (rad) between two Vec2
    pub fn angle(a: Vec2, b: Vec2) f32 {
        var x1 = a.data[0];
        var y1 = a.data[1];
        var x2 = b.data[0];
        var y2 = b.data[1];

        var len1 = x1 * x1 + y1 * y1;
        if (len1 > 0)
            len1 = 1 / math.sqrt(len1);

        var len2 = x2 * x2 + y2 * y2;
        if (len2 > 0)
            len2 = 1 / math.sqrt(len2);

        var cos = (x1 * x2 + y1 * y2) * len1 * len2;
        if (cos > 1.0) {
            return 0;
        } else if (cos < -1.0) {
            return math.pi;
        } else {
            return math.acos(cos);
        }
    }

    pub const len = length;
    pub const sub = substract;
    pub const mul = multiply;
    pub const div = divide;
    pub const dist = distance;
    pub const sqrDist = squaredDistance;
    pub const sqrLen = squaredLength;
};

test "CheckBuild" {
    var p = Vec2.create(1.0, 1.0);
    testing.expectEqual(p, Vec2.create(1.0, 1.0));
}