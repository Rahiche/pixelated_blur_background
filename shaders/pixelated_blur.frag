#version 460 core
precision mediump float;

#include <flutter/runtime_effect.glsl>

uniform vec2 uViewSize;
uniform sampler2D uTexture;

const int samples = 10;
const float pixelSize = 5;
const float radius = 10.0;


out vec4 FragColor;

void main()
{
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = fragCoord/uViewSize.xy;
    vec2 pixelatedUV = floor(uv * uViewSize.xy / pixelSize) * pixelSize / uViewSize.xy;

    vec3 col = vec3(0.0);
    for(int x = -samples/2; x <= samples/2; x++)
    {
        for(int y = -samples/2; y <= samples/2; y++)
        {
            vec2 samplePos = pixelatedUV + vec2(x, y) * (radius / uViewSize.xy);
            col += texture(uTexture, samplePos).rgb;
        }
    }

    col /= float((samples + 1) * (samples + 1));

    FragColor = vec4(col,1.0);
}
