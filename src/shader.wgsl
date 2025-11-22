// Vertex shader
struct CameraUniform {
    view_proj: mat4x4<f32>,
};
@group(1) @binding(0) // 1.
var<uniform> camera: CameraUniform;

// define vertex input
struct VertexInput {
    @location(0) position: vec3<f32>,
    // @location(1) color: vec3<f32>
    @location(1) tex_coords: vec2<f32>
}

struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>, // clipping what's seen on screen
    // don't need position anymore, only need color for rasterization
    // @location(0) vert_pos: vec3<f32>,
    // @location(1) v_color: vec3<f32>
    @location(0) tex_coords: vec2<f32>
};

// Fixed Pipeline
// change input to use model: VertexInput
@vertex
fn vs_main(
    model: VertexInput,
) -> VertexOutput {
    var out: VertexOutput;
    let pos =  vec4<f32>(model.position, 1.0); // 1.0 = no projection
    out.clip_position = pos;
    out.tex_coords = model.tex_coords;
    out.clip_position = camera.view_proj * vec4<f32>(model.position, 1.0); // clipping with camera
    // make sure KP not PK
    return out;
}

// uniforms using bindgroups
@group(0) @binding(0)
var t_diffuse: texture_2d<f32>;
@group(0) @binding(1)
var s_diffuse: sampler;

// change fragment to use color
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
     return textureSample(t_diffuse, s_diffuse, in.tex_coords);
}

// interpolate position?
@vertex
fn vs_color(
    model: VertexInput,
) -> VertexOutput {
    var out: VertexOutput;
    let pos =  vec4<f32>(model.position, 1.0); // 1.0 = no projection
    out.clip_position = pos;

    // let pos = out.clip_position.xyz; // pos is [-1, 1] so need to normalize
    out.tex_coords = (pos.xy * 0.5) + 0.5; // this will flip it b/c now we 
    // are procedurally gen'ing it; 
    // have to relook at that
    return out;
}

@fragment
fn fs_color(in: VertexOutput) -> @location(0) vec4<f32> {
    return textureSample(t_diffuse, s_diffuse, in.tex_coords);
}