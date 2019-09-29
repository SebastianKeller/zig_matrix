const math = @import("std").math;
pub fn f_eq(left: f32, right: f32) bool {
    const diff = math.fabs(left - right);
    return diff < 0.001;
}
