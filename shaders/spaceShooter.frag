#version 450 core

in vec4 outColor;
out vec4 fragColor;

void main()
{
    fragColor = outColor;
}