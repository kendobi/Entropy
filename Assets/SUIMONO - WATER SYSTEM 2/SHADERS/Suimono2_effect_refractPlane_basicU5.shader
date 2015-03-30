Shader "Suimono2/effect_refractPlane_basicU5" {


Properties {
	_MasterScale ("Master Scale", Float) = 1.0
	
	_BlurSpread ("Blur Spread", Range (0.0, 0.125)) = 0.001
	_BlurRamp ("Blur Ramp", 2D) = "" {}

	_underFogStart ("Underwater Fog Start", Range(0.0,1.0)) = 0.0
	_underFogStretch ("Underwater Fog Stretch", Range(0.0,0.02)) = 0.0
	
	//_underTex ("Underwater Fog Texture 2", 2D) = "" {}
	
	_TestHeight1 ("Test Height 1", 2D) = "" {}

	//refraction
	_RefrStrength ("Refraction Strength", Range(0.0,1.0)) = 0.0
    _RefrSpeed ("Refraction Speed", Float) = 0.5
	_AnimSpeed ("Animation Speed", Float) = 1.0

	_DepthAmt ("Depth Amount", Float) = 0.1
	_DiffuseColor ("Diffuse Color", Color) = (0.5, 0.5, 1.0, 1.0)
	
	_DepthColor ("Depth Over Tint", Color) = (0.25,0.25,0.5,1.0)
	_DepthColorR ("Depth Color 1(r)", Color) = (0.25,0.25,0.5,1.0)
	_DepthColorG ("Depth Color 2(g)", Color) = (0.25,0.25,0.5,1.0)
	_DepthColorB ("Depth Color 3(b)", Color) = (0.25,0.25,0.5,1.0)

	_Ramp2D ("BRDF Ramp", 2D) = "gray" {}
	_FalloffTex ("Falloff Texture", 2D) = "gray" {}

	_UnderReflDist ("Light Factor", Range(0.0,1.0)) = 1.0

	_suimonoHeight ("heightfactor", Float) = 1.0
}



Subshader 
{ 







Tags {"Queue"= "Overlay+21"}
Cull Back
Blend SrcAlpha OneMinusSrcAlpha
ZWrite off
ZTest Always



CGPROGRAM
#pragma target 3.0
#pragma surface surf SuimonoNoLight noambient
#pragma glsl


struct Input {
	float4 screenPos;
	float2 uv_TestHeight1; 
	float2 uv_FalloffTex;
};


sampler2D _GrabTexture;
float4 _GrabTexture_TexelSize;
float4 _DepthColorB;
float _BlurSpread;
float _RefrStrength;
sampler2D _TestHeight1;
sampler2D _CameraDepthTexture;
sampler2D _BlurRamp;
float _DepthAmt;
float _underFogStretch;
float _underFogStart;
float _EdgeBlend;
float _RefrShift;
float _BumpStrength;
float _MasterScale;
float _RefrSpeed;
sampler2D _FalloffTex;
float camDepth;
float _UnderReflDist;

float suimonoHeight;
float suimonoCameraHeight;

float hfac;


fixed4 LightingSuimonoNoLight (SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
{
	// modulate light function
	half4 inLight = _LightColor0;
	inLight = lerp(inLight*0.0,inLight,_UnderReflDist);

	fixed4 col;

	//testing
	col.a = s.Alpha;
	col.rgb = (s.Albedo*atten*inLight.rgb)*s.Gloss;
	col.rgb += (s.Albedo * 1.4) * saturate(lerp(0.1,0.0,dot(viewDir,lightDir)));
	col.rgb *= _LightColor0.rgb;
	col.a *= saturate(lerp(-1.0,2.0,dot(viewDir,half3(0,1,0))+0.7+hfac));
	col.a = saturate(col.a);
	col.a *= _DepthColorB.a;
	
	return col;
}



void surf (Input IN, inout SurfaceOutput o) {

	//CALCULATE DEPTH FOG
	//float4 edgeBlendFactors = float4(0.0, 0.0, 0.0, 0.0);
	half dpth = UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture, IN.screenPos));
	half depth = LinearEyeDepth(dpth);
	//float4 DepthFade = float4(_underFogStretch,2.0,0.0,-0.25+_underFogStart);
	//edgeBlendFactors = saturate(DepthFade * (depth-IN.screenPos.w));
	
	
	//float depthAmt = tex2D(_BlurRamp, float2(0.0, 0.5)) - (DepthFade.w * float4(0.15, 0.08, 0.01, 0.0)).a;
	float4 falloff = tex2D(_FalloffTex, IN.uv_FalloffTex);
	//depthAmt *= (edgeBlendFactors.y);
	//depthAmt = edgeBlendFactors.x * depthAmt;
	//float depthPos = depthAmt-DepthFade.w;
	//half depthViz = 1.0-tex2D(_BlurRamp, float2(depthPos, 0.5)).r;


	o.Albedo = lerp(_DepthColorB.rgb*0.25, half3(1,0,0), 0.0);
	o.Albedo = lerp(half3(0,0,0), _DepthColorB.rgb*0.25, 1.0);
	o.Albedo = _DepthColorB.rgb;

	o.Gloss = falloff.r;
	
	hfac = (IN.screenPos.w/(suimonoCameraHeight)*pow(1.4,suimonoHeight-suimonoCameraHeight));
	
	o.Alpha = 1.0;//depthViz;
	camDepth = 1.0;//depthViz;
	
}

ENDCG





}
FallBack "Diffuse"
}




