#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float3 position [[attribute(0)]];
    float4 color [[attribute(1)]];
};

struct VertexOut {
    float4 position [[position]];
    float4 color;
};

struct Uniforms {
    float4x4 mvpMatrix;
};

vertex VertexOut vertex_main(const VertexIn v_in [[stage_in]],
                             constant Uniforms &uniforms [[buffer(1)]]) {
    VertexOut v_out;
    // Умножаем матрицу на позицию для вращения и масштаба
    v_out.position = uniforms.mvpMatrix * float4(v_in.position, 1.0);
    v_out.color = v_in.color;
    return v_out;
}

fragment float4 fragment_main(VertexOut v_out [[stage_in]]) {
    return v_out.color;
}
