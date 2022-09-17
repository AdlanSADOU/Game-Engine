#VERT_START
#version 450 core

layout (location = 0) in vec3 vPos;
layout (location = 1) in vec3 vNormals;
layout (location = 2) in vec2 vTex;
layout (location = 3) in vec4 vJoints;
layout (location = 4) in vec4 vWeights;

out vec2 texCoord;
out vec4 color;
out vec3 normals;

uniform mat4 projection;
uniform mat4 view;
uniform mat4 model;

uniform mat4 finalPoseJointMatrices[128];// might want to switch to SSBOs

void main()
{
    // vec4 point = projectionGLM * vec4(1.0f, 1.0f, 1.0f, 1.0f);
    mat4 modelViewProj = projection * view * model;

    mat4 skinMatrix =
    vWeights.x * finalPoseJointMatrices[uint(vJoints.x)]+
    vWeights.y * finalPoseJointMatrices[uint(vJoints.y)]+
    vWeights.z * finalPoseJointMatrices[uint(vJoints.z)];
    (1-vWeights.x-vWeights.y-vWeights.z) * finalPoseJointMatrices[uint(vJoints.w)];

    gl_Position = modelViewProj * skinMatrix * vec4(vPos, 1.0f);
    texCoord = vTex;
    normals =  vNormals;
    // color = vec4(1,1,1,1);
}

#VERT_END
#FRAG_START

#version 450 core

// in vec4 inColor;
in vec2 texCoord;
in vec4 color;
in vec3 normals;

out vec4 FragColor;

uniform sampler2D texSampler;

void main()
{
    // FragColor = mix(texture(texSampler, texCoord), texture(texSampler1, texCoord), 0.2) * inColor;
    // FragColor = texture(texSampler, texCoord) * inColor;
    // FragColor = texture(texSampler, texCoord) * vec4(1., .4, 1., 1.)*4;
    FragColor = texture(texSampler, texCoord) * vec4(normals, 1.)*2;
}

#FRAG_END