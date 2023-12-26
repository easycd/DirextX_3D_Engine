#ifndef _STD3D
#define _STD3D

#include "value.fx"
#include "func.fx"

//static float3 g_vLightPos = float3(0.f, 0.f, 0.f);
//static float3 g_vLightDir = float3(1.f, -1.f, 1.f);

//static float3 g_vLightColor = float3(1.f, 1.f, 1.f);
//static float3 g_vLightAmb = float3(0.15f, 0.15f, 0.15f); //환경광
//static float g_fLightSpecCoeff = 0.3f; //반사광 계수 /재질마다 계수를 다르게 줄 수 있다.

struct VS_IN
{
    float3 vPos : POSITION;
    float2 vUV : TEXCOORD;
    
    float3 vNormal : NORMAL;
    float3 vTangent : TANGENT;
    float3 vBinormal : BINORMAL;
};

struct VS_OUT
{
    float4 vPosition : SV_Position;
    float2 vUV : TEXCOORD;
    
    float3 vViewPos : POSITION;
    
    float3 vViewNormal : NORMAL;
    float3 vViewTangent : TANGENT;
    float3 vViewBinormal : BINORMAL;
};

//
// Std3DShader
//
// Param
#define SPEC_COEFF  saturate(g_float_0) // 반사 계수

#define IS_SKYBOX_ENV   g_btexcube_0 // 환경텍스처
#define SKYBOX_ENV_TEX  g_cube_0     // 재질을 통해 값이 전달됐다면

VS_OUT VS_Std3D(VS_IN _in)
{
    VS_OUT output = (VS_OUT) 0.f;
        
    // 로컬에서의 Normal 방향을 월드로 이동    
    output.vViewPos = mul(float4(_in.vPos, 1.f), g_matWV);
    
    output.vViewNormal = normalize(mul(float4(_in.vNormal, 0.f), g_matWV)).xyz;
    output.vViewTangent = normalize(mul(float4(_in.vTangent, 0.f), g_matWV)).xyz;
    output.vViewBinormal = normalize(mul(float4(_in.vBinormal, 0.f), g_matWV)).xyz;
    
    output.vPosition = mul(float4(_in.vPos, 1.f), g_matWVP);
    output.vUV = _in.vUV;
    
    return output;
}

float4 PS_Std3D(VS_OUT _in) : SV_Target
{
    float4 vOutColor = float4(0.5f, 0.5f, 0.5f, 1.f);
        
    float3 vViewNormal = _in.vViewNormal;
    
    if (g_btex_0) //첫번째 텍스처
    {
        vOutColor = g_tex_0.Sample(g_sam_0, _in.vUV);
    }
    
    if(g_btex_1) //두번째 텍스처
    {
        float3 vNormal = g_tex_1.Sample(g_sam_0, _in.vUV).xyz;
        
        // 0 ~ 1 범위의 값을 -1 ~ 1 로 확장        
        vNormal = vNormal * 2.f - 1.f;
        
        float3x3 vRotateMat =
        {
            _in.vViewTangent,
          //_in.vViewBinormal,
           -_in.vViewBinormal,
            _in.vViewNormal        
        };
        
        vViewNormal = normalize(mul(vNormal, vRotateMat));
    }
    
    tLightColor lightcolor = (tLightColor) 0.f;
    float fSpecPow = 0.f;
    
    for (int i = 0; i < g_Light3DCount; ++i)
    {
        CalcLight3D(_in.vViewPos, vViewNormal, i, lightcolor, fSpecPow);
    }
    
    vOutColor.xyz = vOutColor.xyz * lightcolor.vDiffuse.xyz
                    + vOutColor.xyz * lightcolor.vAmbient.xyz
                    + saturate(g_Light3DBuffer[0].Color.vDiffuse.xyz) * 0.3f * fSpecPow * SPEC_COEFF;
    
    //// (물체의 본래 색 * 비춰진 빛의 색 * 빛의 세기) 
    //// + (물체의 본래 색 * 비춰진 빛의 색 * 환경광)
    //// + (비춰진 빛의 색 * 설정한 최대 반사 계수 * 반사광의 세기)
    //vOutColor.xyz = (vOutColor.xyz * g_vLightColor * fLightPow)
    //                + (vOutColor.xyz * g_vLightColor * g_vLightAmb)
    //                + (g_vLightColor * g_fLightSpecCoeff * fSpecPow);
    
    if(IS_SKYBOX_ENV)
    {
        float3 vEye = normalize(_in.vViewPos);
        float3 vEyeReflect = normalize(reflect(vEye, vViewNormal));
        
        vEyeReflect = normalize(mul(float4(vEyeReflect, 0.f), g_matViewInv));
        
        vOutColor *= SKYBOX_ENV_TEX.Sample(g_sam_2, vEyeReflect);
    }
    
    return vOutColor;
}

#endif