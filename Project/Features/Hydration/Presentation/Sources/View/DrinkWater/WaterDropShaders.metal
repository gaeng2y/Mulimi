#include <metal_stdlib>
using namespace metal;

float mulimiWaveNoise(float2 uv, float time) {
    float rippleA = sin((uv.x * 21.0) + (time * 1.37) + sin((uv.y * 7.0) - (time * 0.41)));
    float rippleB = sin((uv.x * -13.0) + (uv.y * 11.0) + (time * 0.93));
    float rippleC = sin(((uv.x + uv.y) * 31.0) - (time * 1.71));
    return (rippleA * 0.55) + (rippleB * 0.32) + (rippleC * 0.13);
}

[[ stitchable ]] float2 mulimiWaterDistortion(
    float2 position,
    float time,
    float progress,
    float2 size
) {
    float2 safeSize = max(size, float2(1.0, 1.0));
    float2 uv = position / safeSize;
    float surface = clamp(1.0 - progress, 0.03, 0.97);
    float waterMask = smoothstep(surface - 0.04, surface + 0.18, uv.y);
    float surfaceFalloff = exp(-abs(uv.y - surface) * 18.0);
    float depthFalloff = smoothstep(surface, 1.0, uv.y);
    float noise = mulimiWaveNoise(uv, time);

    float horizontal = noise * (5.5 * surfaceFalloff + 1.4 * depthFalloff) * waterMask;
    float vertical = sin((uv.x * 16.0) - (time * 1.12)) * 2.0 * surfaceFalloff * waterMask;

    return position + float2(horizontal, vertical);
}

[[ stitchable ]] half4 mulimiWaterLighting(
    float2 position,
    half4 color,
    float time,
    float progress,
    float2 size
) {
    float2 safeSize = max(size, float2(1.0, 1.0));
    float2 uv = position / safeSize;
    float surface = clamp(1.0 - progress, 0.03, 0.97);
    float waterMask = smoothstep(surface - 0.02, surface + 0.12, uv.y);
    float depth = clamp((uv.y - surface) / max(1.0 - surface, 0.001), 0.0, 1.0);
    float surfaceLine = exp(-abs(uv.y - surface) * 44.0);
    float caustic = max(
        0.0,
        sin(((uv.x * 18.0) + (uv.y * 12.0)) + (time * 1.28)) *
        sin(((uv.x * -9.0) + (uv.y * 17.0)) - (time * 0.73))
    );
    float sideShade = smoothstep(0.0, 0.46, uv.x) * smoothstep(1.0, 0.54, uv.x);

    half3 shallowColor = half3(0.18, 0.84, 0.94);
    half3 deepColor = half3(0.02, 0.43, 0.58);
    half3 waterColor = mix(shallowColor, deepColor, half(depth * 0.9));
    waterColor += half3(0.13, 0.20, 0.20) * half(caustic * (0.25 + depth * 0.7));
    waterColor += half3(0.45, 0.72, 0.78) * half(surfaceLine * 0.34);
    waterColor *= half(0.78 + (sideShade * 0.22));

    half3 finalColor = mix(color.rgb, waterColor, half(waterMask));
    return half4(finalColor, color.a);
}
