#version 330 core

layout(location = 0) in vec2 a_position;

uniform float u_layer;

void main() {
    gl_Position = vec4(a_position, 0.0f, 1.0f);
}
