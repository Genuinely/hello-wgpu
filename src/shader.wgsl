// Vertex shader

struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>, // clipping what's seen on screen
    @location(0) vert_pos: vec3<f32>,
    @location(1) v_color: vec3<f32>
};

// -------- Pipeline A (brown) --------
@vertex
fn vs_main(
    @builtin(vertex_index) idx: u32,
) -> VertexOutput {
    var out: VertexOutput;
    let x = f32(1 - i32(idx)) * 0.5;
    let y = f32(i32(idx & 1u) * 2 - 1) * 0.5;
    out.clip_position = vec4<f32>(x, y, 0.0, 1.0);

    out.v_color = vec3<f32>(0.0);
    return out;
}

@fragment
fn fs_main(_in: VertexOutput) -> @location(0) vec4<f32> {
    return vec4<f32>(0.3, 0.2, 0.1, 1.0);
}

// -------- Pipeline B (position-colored) --------
@vertex
fn vs_color(
    @builtin(vertex_index) idx: u32,
) -> VertexOutput {
    var out: VertexOutput;
    let x = f32(1 - i32(idx)) * 0.5;
    let y = f32(i32(idx & 1u) * 2 - 1) * 0.5;
    out.clip_position = vec4<f32>(x, y, 0.0, 1.0);

    let pos = out.clip_position.xyz;
    out.v_color = (pos * 0.5) + vec3<f32>(0.5);
    return out;
}

@fragment
fn fs_color(in: VertexOutput) -> @location(0) vec4<f32> {
    return vec4<f32>(in.v_color, 1.0);
}