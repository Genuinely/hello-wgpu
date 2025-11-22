// Vertex shader

// define vertex input
struct VertexInput {
    @location(0) position: vec3<f32>,
    @location(1) color: vec3<f32>
}

struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>, // clipping what's seen on screen
    // don't need position anymore, only need color for rasterization
    // @location(0) vert_pos: vec3<f32>,
    // @location(1) v_color: vec3<f32>
    @location(0) color: vec3<f32>
};

// -------- Pipeline A (brown) --------
// change input to use model: VertexInput
@vertex
fn vs_main(
    model: VertexInput,
) -> VertexOutput {
    var out: VertexOutput;
    let pos =  vec4<f32>(model.position, 1.0); // 1.0 = no projection
    out.clip_position = pos;
    out.color = vec3<f32>(0.0);
    return out;
}

// change fragment to use color
@fragment
fn fs_main(_in: VertexOutput) -> @location(0) vec4<f32> {
    return vec4<f32>(0.3, 0.2, 0.1, 1.0);
}

// -------- Pipeline B (position-colored) --------
@vertex
fn vs_color(
    model: VertexInput,
) -> VertexOutput {
    var out: VertexOutput;
    let pos =  vec4<f32>(model.position, 1.0); // 1.0 = no projection
    out.clip_position = pos;

    // let pos = out.clip_position.xyz; // pos is [-1, 1] so need to normalize
    out.color = (pos.xyz * 0.5) + vec3<f32>(0.5); 
    return out;
}

@fragment
fn fs_color(in: VertexOutput) -> @location(0) vec4<f32> {
    return vec4<f32>(in.color, 1.0);
}