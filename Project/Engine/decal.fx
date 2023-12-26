#ifndef _DECAL
#define _DECAL

#include "value.fx"
#include "func.fx"

struct VS_DECAL_IN
{
    
};

struct VS_DECAL_OUT
{
    
};

VS_DECAL_OUT VS_Decal(VS_DECAL_IN _in)
{
    VS_DECAL_OUT output = (VS_DECAL_OUT) 0.f;
    
    return output;
}

float4 PS_Decal(VS_DECAL_OUT _in) : SV_Target
{
    float4 vOutColor = (float4) 0.f;
    
    return vOutColor;
}

#endif