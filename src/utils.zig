pub const epsilon = 0.000001;

pub fn f_eq(left: f32, right: f32) bool {
    const diff = @abs(left - right);
    return diff < 0.001;
}
