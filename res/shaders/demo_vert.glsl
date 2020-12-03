#version 330 core
layout(location = 0) in vec3 a_position;
layout(location = 1) in vec2 a_texcoord;

out vec2 v_texcoord;

uniform float u_layer;
uniform mat4 u_model;
uniform mat4 u_projection;

void main() {
    v_texcoord = a_texcoord;
    gl_Position = u_projection * u_model * vec4(a_position.xy, u_layer, 1.0f);
}
