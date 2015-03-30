Shader "Suimono2/water_android" {


Properties {
	_Tess ("Tessellation", Float) = 4.0
    _minDist ("TessMin", Range(-180.0, 0.0)) = 10.0
    _maxDist ("TessMax", Range(20.0, 500.0)) = 25.0
    _Displacement ("Displacement", Range(0, 8.0)) = 0.3
    _MaskAmt ("Mask Strength", Range(1, 8.0)) = 1.0

    _WaveLargeTex ("Wave Large", 2D) = "white" {}
   	_WaveHeight ("Wave Height", Range(0, 20.0)) = 0.0
   	_DetailHeight ("Detail Height", Range(0, 20.0)) = 0.0
   	_WaveShoreHeight ("Wave Shore Height", Range(0, 8.0)) = 0.0
   	_WaveScale ("Wave Scale", Range(0, 1.0)) = 0.25
	
	_CenterHeight ("Center Height", Float) = 0.0
	_MaxVariance ("Maximum Variance", Float) = 3.0

	_HighColor ("High Color", Color) = (1.0, 0.0, 0.0, 1.0)
	_LowColor ("Low Color", Color) = (0.0, 1.0, 0.0, 0.1)
		
	_Surface1 ("Surface Distortion 1", 2D) = "white" {}
	_Surface2 ("Surface Distortion 2", 2D) = "white" {}
	_WaveRamp ("Wave Ramp", 2D) = "white" {}
	
	_RefrStrength ("Refraction Strength (0.0 - 25.0)", Float) = 25.0
    _RefrSpeed ("Refraction Speed (0.0 - 0.5)", Float) = 0.5
    _RefrScale ("Refraction Scale", Float) = 0.5
	
	_SpecScatterWidth ("Specular Width", Range(1.0,10.0)) = 2.0
	_SpecScatterAmt ("Specular Scatter", Range(0.0,0.05)) = 0.02
	_SpecColorH ("Hot Specular Color", Color) = (0.5, 0.5, 0.5, 1)
	_SpecColorL ("Reflect Specular Color", Color) = (0.5, 0.5, 0.5, 1)
	
	_DynReflColor ("Reflection Dynamic", Color) = (1.0, 1.0, 1.0, 0.5)
	_ReflDist ("Reflection Distance", Float) = 1000.0
	_ReflBlend ("Reflection Blend", Range(0.002,0.1)) = 0.01
	_ReflBlur ("Reflection Blur", Range (0.0, 0.125)) = 0.01
	_ReflectionTex ("Reflection", 2D) = "white" {}

	_DepthAmt ("Depth Amount", Float) = 0.1
	
	_DepthColor ("Depth Over Tint", Color) = (0.25,0.25,0.5,1.0)
	_DepthColorR ("Depth Color 1(r)", Color) = (0.25,0.25,0.5,1.0)
	_DepthColorG ("Depth Color 2(g)", Color) = (0.25,0.25,0.5,1.0)
	_DepthColorB ("Depth Color 3(b)", Color) = (0.25,0.25,0.5,1.0)
	_DepthRamp ("Depth Color Ramp", 2D) = "white" {}
	
	_BlurSpread ("Blur Spread", Range (0.0, 0.125)) = 0.01
	_BlurRamp ("Blur Ramp", 2D) = "white" {}
	
	_FoamHeight ("Foam Height", Float) = 5.0
	_HeightFoamAmount ("Height Foam Amount", Range (0.0, 1.0)) = 1.0
	_HeightFoamSpread ("Height Foam Spread", Float) = 2.0
	
	_FoamSpread ("Foam Spread", Range (0.0, 1.0)) = 0.5
	_FoamColor ("Foam Color", Color) = (1,1,1,1)
	_FoamRamp ("Foam Ramp", 2D) = "white" {}
	_FoamTex ("Foam Texture (RGB)", 2D) = "white" {}

	_EdgeBlend ("Edge Spread", Range (0.04,5.0)) = 10.0
	_EdgeSpread ("Edge Spread", Range (0.04,5.0)) = 10.0
	_EdgeColor ("Edge Color", Color) = (1,1,1,1)
	
	_BumpStrength ("Normal Strength", Float) = 0.9
	_ReflectStrength ("Reflection Strength", Float) = 1.0
		
	_CubeTex ("Cubemap reflections", CUBE) = "white" {}
	_CubeBDRF ("Cubemap BDRF", CUBE) = "white" {}
    
	_MasterScale ("Master Scale", Float) = 1.0
	_UnderReflDist ("Under Reflection", Float) = 1.0
	_UnderColor ("Underwater Color", Color) = (0.25,0.25,0.5,1.0)
	
	_WaveTex ("_WaveTex", 2D) = "white" {}
	_FlowMap ("_FlowMap", 2D) = "white" {}
	_FlowScale ("Flowmap Scale", Range(0.1,10.0)) = 0.0

	_TideColor ("Tide Color", Color) = (0.0,0.0,0.2,1.0)
	_TideAmount ("Tide Amount", Range(0.0,1.0)) = 1.0
	_TideSpread ("Tide Amount", Range(0.02,1.0)) = 0.4

	_WaveMap ("_WaveMap", 2D) = "white" {}
	
	_Ramp2D ("_BRDF Ramp", 2D) = "white" {}
	_RimPower ("RimPower", Range(0.0,10.0)) = 1.0

	_castshadowEnabled ("shadow Enabled", Float) = 1.0
	_castshadowStrength ("shadow Strength", Float) = 1.0
	_castshadowFade ("shadow Fade", Float) = 1.0
	_castshadowColor ("Shadow Color", Color) = (0,0,0,1)

	_suimono_uvx ("uvx", Float) = 1.0
	_suimono_uvy ("uvy", Float) = 1.0

	_suimono_uv2x ("uvx2", Float) = 1.0
	_suimono_uv2y ("uvy2", Float) = 1.0

	_suimono_uv3x ("uvx3", Float) = 1.0
	_suimono_uv3y ("uvy3", Float) = 1.0
	
	_suimono_uv4x ("uvx4", Float) = 1.0
	_suimono_uv4y ("uvy4", Float) = 1.0

	_suimono_DeepWaveHeight ("Deep Wave Height", Float) = 1.0
	_suimono_DetailHeight ("Detail Wave Height", Float) = 1.0
	_suimono_detScale ("Detail Scale", Float) = 1.0

	_useDynamicReflections ("Use DynamicReflections", Float) = 1.0
	
}



Subshader 
{ 














// ---------------------------------
//   SURFACE REFLECTIONS
// ---------------------------------
Tags {"RenderType"="Transparent" "Queue"="Transparent"}
Cull Back
Blend SrcAlpha OneMinusSrcAlpha
ZWrite On


CGPROGRAM
#pragma target 3.0
//#include "SuimonoFunctionsMobile.cginc"
#pragma surface surf SuimonoSurface noambient alpha
#pragma glsl



sampler2D _Surface1;
sampler2D _WaveLargeTex;
fixed _BumpStrength;
fixed _dScaleX;
fixed _dScaleY;
fixed _Phase;
fixed _WaveHeight;
fixed _WaveShoreHeight;
fixed _WaveScale;
fixed _WaveShoreScale;
fixed _MaskAmt;
fixed _ShoreAmt;
fixed _TimeX;
fixed _TimeY;
fixed _DTimeX;
fixed _DTimeY;
fixed _DTimeX2;
fixed _DTimeY2;
fixed _DetailHeight;
fixed _suimono_DeepWaveHeight;
fixed _suimono_DetailHeight;
fixed _SuimonoIsLinear;
sampler2D _WaveMap;
sampler2D _WaveTex;
sampler2D _FlowMap;
fixed _MasterScale;
fixed _FlowScale;
fixed _FlowShoreScale;
fixed halfCycle;
fixed flowMapOffset0;
fixed flowMapOffset1;
fixed flowOffX;
fixed flowOffY;
fixed shoreOffX;
fixed shoreOffY;
fixed shoreWaveOffX;
fixed shoreWaveOffY;
fixed detailScale;
fixed waveScale;
fixed normalShore;
fixed shoreWaveScale;
fixed _suimono_uvx;
fixed _suimono_uvy;

fixed _suimono_uv2x;
fixed _suimono_uv2y;
fixed _suimono_uv3x;
fixed _suimono_uv3y;
fixed _suimono_uv4x;
fixed _suimono_uv4y;

fixed _DepthAmt;




fixed4 _HighColor;
fixed4 _LowColor;
fixed4 _DepthColor;
fixed4 _DepthColorR;
fixed4 _DepthColorG;
fixed4 _DepthColorB;
fixed4 _DynReflColor;
fixed4 _FoamColor;
fixed _SpecScatterWidth;
fixed _SpecScatterAmt;
fixed _RimPower;
sampler2D _Ramp2D;
sampler2D _ReflectionTex;
fixed _OverallTrans;
fixed _OverallBright;

fixed _ReflectStrength;
fixed _ReflDist;
fixed _ReflBlend;

fixed4 origBGColor;
fixed4 depthColor;
fixed4 reflectColor;
fixed4 reflectCUBE;
//fixed4 reflectBDRF;
fixed4 reflectCubeColor;
fixed _RefrStrength;
fixed _RefrShift;
fixed4 refractColor;
fixed edgeFactor;
fixed foamFactor;
fixed _FoamSpread;
fixed4 _SpecColorH;
fixed4 _SpecColorL;
fixed _blurSamples;
fixed _BlurSpread;
fixed _HeightFoamAmount;
fixed _HeightFoamSpread;
fixed _FoamHeight;
fixed _ShadowAmt;


fixed _useDynamicReflections;

//tenkoku variables
fixed4 _Tenkoku_SkyColor;
fixed4 _Tenkoku_HorizonColor;
fixed4 _Tenkoku_GlowColor;
fixed _Tenkoku_Ambient;

//shadow variables
fixed _castshadowEnabled;
fixed _castshadowStrength;
fixed _castshadowFade;
fixed4 _castshadowColor;

fixed mask;
fixed mask1;
fixed mask2;
fixed mask3;


inline fixed4 LightingSuimonoSurface (SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
{

	// PHYSICAL BASED RENDERING
	
	fixed4 c;
	fixed _roughness = clamp(1.0-(_SpecScatterWidth/10.0),0.1,1.0);
	
	//------------------------------
	//##  WORLD LIGHT FUNCTIONS  ##
	//------------------------------
	// REMAP LIGHT
	// For all intents and purposes, this is a hax, and has
	// no place in a Physically-based syste, :D
	half4 inLight = _LightColor0;
	half4 outLight = inLight;
	half3 albedoColor = s.Albedo;

	
	//-------------------------------
	//##  LIGHT TERM CALCULATION  ##
	//-------------------------------
	//s.Normal = normalize(s.Normal);
	half NdotV = dot(s.Normal,viewDir);
	half cNdotV = max(0,dot(s.Normal,viewDir));
	half h = max(0,dot(s.Normal,normalize(lightDir+viewDir)));
	
	
	//---------------------------
	//##  INDEX OF REFRACTION  ##
	//---------------------------
	// set f0 of dielectrics to default value 0f 0.255 for water
	half3 f0 = half3(0.255,0.255,0.255);

	
	//---------------------------
	//##  REFLECTANCE TERM  ##
	//---------------------------
	half3 reflectance = normalize(lightDir + viewDir)*(outLight.rgb*lightDir*max(0,dot(s.Normal,lightDir)));
	half3 b_reflectance = normalize(lightDir + viewDir)*(outLight.rgb*lightDir*min(0,dot(s.Normal,lightDir)));


	//---------------------------
	//##  FRESNEL CALULATION  ##
	//---------------------------
	half3 fresnel;
	
	// Schlick function
	half3 f_schlick = f0+(1.0-f0)*pow((dot(s.Normal,normalize(lightDir+viewDir))),5);
	f_schlick *= f0+(1.0-f0)*pow((1.0-NdotV),5);
	f_schlick = max(f_schlick,f0+(1.0-f0)*pow((1.0-NdotV),5));
	f_schlick = saturate(f_schlick);
	
	fresnel = f_schlick;


	//--------------------------------------
	//##  NORMAL DISTRIBUTION FUNCTIONS  ##
	//--------------------------------------
	half ndf = 1.0;

	// Phong
	// This is the closest match to the built-in NDF used in Unity 5 Standard Shader
	// Phong is best matched for hard/gloss plastics, rubber, and other man-made materials
	//float m = pow(8192.0,(1.0-_roughness));
	//half ndf_phong = ((m+2.0)/6.2837)*pow(max(0,dot(s.Normal,normalize(lightDir+viewDir))),m);
	//ndf = ndf_phong;

	// GGX (Trowbrige and Reitz)
	// This NDF has a longer falloff tail than Phong does, and
	// is more useful in natural environments, skin, wood, metal etc.
	float ms = pow(_roughness,2.5);
	half ndf_ggx = (ms*ms)/pow((h*h)*((ms*ms)-1.0)+1.0,2.0);
	ndf = ndf_ggx;


	//---------------------------
	//##  GEOMETRY FUNCTIONS  ##
	//---------------------------
	half gf = 1.0;
	half gf_implicit = max(0,dot(s.Normal,lightDir))*cNdotV;
	gf = gf_implicit;


	//-----------------------------
	//##  FINAL COMBINATION  ##
	//-----------------------------
	outLight *= atten;
	ndf *= _SpecColorH.a;
	fresnel = saturate(lerp(-0.5,1.0,fresnel));
	
	s.Albedo = lerp(s.Albedo,_LowColor.rgb,_LowColor.a);
	c.rgb = s.Albedo * outLight.rgb;
	
	c.rgb = lerp(c.rgb*0.5,c.rgb,gf);
	c.rgb = lerp(c.rgb,reflectCUBE.rgb*_DynReflColor.rgb,fresnel.r*_DynReflColor.a)*atten;
	c.rgb = saturate(c.rgb);
	c.rgb += (ndf*_SpecColorH.rgb*outLight.rgb);
	c.rgb *= _OverallBright;
	
	//Alpha
	c.a = saturate((s.Alpha*_OverallTrans)+(fresnel*_DynReflColor.a*mask)+ndf);	
	
	return c;
	
}




struct Input {
	float4 screenPos;	
	float2 uv_Surface1;
	float2 uv_WaveLargeTex;
	float3 worldRefl;
    INTERNAL_DATA
};


fixed _EdgeBlend;
samplerCUBE _CubeTex;
samplerCUBE _CubeBDRF;
fixed _isForward;
fixed _UVReversal;
fixed suimonoHeight;
fixed _ShallowFoamAmt;


void surf (Input IN, inout SurfaceOutput o) {
	 
	//Calculate Normal
	fixed3 waveFac;
	fixed3 wfa;
	fixed3 wfb;
	fixed wfMult = 0.15;
	fixed2 waveSpd = fixed2(_suimono_uv3x,_suimono_uv3y);
	fixed2 waveSpdb = fixed2(_suimono_uv4x,_suimono_uv4y);
	wfa = normalize(UnpackNormal(tex2D(_WaveLargeTex,fixed2(IN.uv_Surface1.x*wfMult+waveSpd.x,IN.uv_Surface1.y*wfMult+waveSpd.y))));
	wfb = normalize(UnpackNormal(tex2D(_WaveLargeTex,fixed2(IN.uv_Surface1.x*wfMult-waveSpdb.x-0.5,IN.uv_Surface1.y*wfMult-waveSpdb.y-0.5))));
	waveFac = normalize(fixed3(wfa.xy + wfb.xy, wfa.z*wfb.z)); //blend function
	
	
	fixed3 waveFac1;
	fixed2 waveSpd1 = fixed2(_suimono_uvx,_suimono_uvy);
	fixed2 waveSpd1b = fixed2(_suimono_uv2x,_suimono_uv2y);
	wfa = normalize(UnpackNormal(tex2D(_WaveLargeTex,fixed2(IN.uv_WaveLargeTex.x+waveSpd1.x,IN.uv_WaveLargeTex.y+waveSpd1.y))));
	wfb = normalize(UnpackNormal(tex2D(_WaveLargeTex,fixed2(IN.uv_WaveLargeTex.x-waveSpd1b.x-0.5,IN.uv_WaveLargeTex.y-waveSpd1b.y-0.5))));
	waveFac1 = normalize(fixed3(wfa.xy + wfb.xy, wfa.z*wfb.z)); //blend function

	//fixed3 waveFac2;
	//fixed wf2Mult = 5.0;
	//fixed2 waveSpd2 = float2(_suimono_uvx,_suimono_uvy);
	//fixed2 waveSpd2b = float2(_suimono_uv2x,_suimono_uv2y);
	//wfa = normalize(UnpackNormal(tex2D(_WaveLargeTex,float2(IN.uv_WaveLargeTex.x*wf2Mult+waveSpd2.x,IN.uv_WaveLargeTex.y*wf2Mult+waveSpd2.y))));
	//wfb = normalize(UnpackNormal(tex2D(_WaveLargeTex,float2(IN.uv_WaveLargeTex.x*wf2Mult-waveSpd2b.x-0.5,IN.uv_WaveLargeTex.y*wf2Mult-waveSpd2b.y-0.5))));
	//waveFac2 = normalize(float3(wfa.xy + wfb.xy, wfa.z*wfb.z)); //blend function


	//fixed3 waveFac3;
	//fixed wf3Mult = 10.0;
	//fixed2 waveSpd3 = fixed2(_suimono_uvx,_suimono_uvy);
	//wfa = normalize(UnpackNormal(tex2D(_WaveLargeTex,fixed2(IN.uv_WaveLargeTex.x*wf3Mult+waveSpd3.x,IN.uv_WaveLargeTex.y*wf3Mult+waveSpd3.y))));
	//wfb = normalize(UnpackNormal(tex2D(_WaveLargeTex,fixed2(IN.uv_WaveLargeTex.x*wf3Mult-waveSpd3.x-0.5,IN.uv_WaveLargeTex.y*wf3Mult-waveSpd3.y-0.5))));
	//waveFac3 = normalize(fixed3(wfa.xy + wfb.xy, wfa.z*wfb.z)); //blend function
	//wfb = normalize(UnpackNormal(tex2D(_WaveLargeTex,fixed2(IN.uv_WaveLargeTex.x*wf3Mult-waveSpd3.x-0.25,IN.uv_WaveLargeTex.y*wf3Mult))));
	//waveFac3 = normalize(fixed3(waveFac3.xy + wfb.xy, waveFac3.z*wfb.z)); //blend function
	
	//fixed3 waveFac4;
	//fixed wf4Mult = 12.0;
	//fixed2 waveSpd4 = fixed2(_suimono_uvx*4.0,_suimono_uvy*4.0);
	//wfa = normalize(UnpackNormal(tex2D(_WaveLargeTex,fixed2(IN.uv_WaveLargeTex.x*wf4Mult+waveSpd4.x,IN.uv_WaveLargeTex.y*wf4Mult+waveSpd4.y))));
	//wfb = normalize(UnpackNormal(tex2D(_WaveLargeTex,fixed2(IN.uv_WaveLargeTex.x*wf4Mult-waveSpd4.x-0.5,IN.uv_WaveLargeTex.y*wf4Mult-waveSpd4.y-0.5))));
	//waveFac4 = normalize(fixed3(wfa.xy + wfb.xy, wfa.z*wfb.z)); //blend function
	//wfb = normalize(UnpackNormal(tex2D(_WaveLargeTex,fixed2(IN.uv_WaveLargeTex.x*wf4Mult-waveSpd4.x-0.25,IN.uv_WaveLargeTex.y*wf4Mult))));
	//waveFac4 = normalize(fixed3(waveFac4.xy + wfb.xy, waveFac4.z*wfb.z)); //blend function
	
	
	fixed3 norm1 = waveFac;
	norm1 = lerp(fixed3(0,0,1),norm1,_suimono_DeepWaveHeight/10.0);
	//norm1 = lerp(norm1,fixed3(0,0,1),flow.r*normalShore);

	//fixed3 norm2 = waveFac1*0.3;
	fixed3 norm2 = lerp(fixed3(0,0,1),waveFac1,_suimono_DetailHeight);
	//wfb = lerp(fixed3(0,0,1),waveFac2*0.3,_BumpStrength);
	//norm2 = normalize(fixed3(norm2.xy + wfb.xy, norm2.z*wfb.z)); //blend function
	//wfb = lerp(fixed3(0,0,1),waveFac3,_BumpStrength);
	//norm2 = normalize(fixed3(norm2.xy + wfb.xy, norm2.z*wfb.z)); //blend function
	//norm2 = lerp(fixed3(0,0,1),norm2,_suimono_DetailHeight/3.0); //fade out with height setting
	

	norm1 = normalize(norm1);
	norm2 = normalize(norm2)*0.3;
 	o.Normal = normalize(fixed3(norm1.xy + norm2.xy, norm1.z*norm2.z)); //blend function
 	//o.Normal = norm1;
 	
 	

	//set UVs
	fixed4 uv0 = IN.screenPos; uv0.xy;
	uv0.x -= (0.05*_RefrStrength*o.Normal.x)*(1.0-edgeFactor);
	uv0.z -= (0.05*_RefrStrength*o.Normal.z)*(1.0-edgeFactor);
	uv0.y += (0.2*_RefrStrength*o.Normal.y)*(1.0-edgeFactor);
	
	//calculate distance mask
	mask = saturate((uv0.w - lerp(60.0,20.0,(_ReflDist/50.0)))*_ReflBlend);
	//mask1 = saturate((uv0.w - lerp(160.0,20.0,(5.0/25.0)))*0.002);
	mask2 = saturate((uv0.w - lerp(0.0,20.0,(5.0/25.0)))*0.01);
	//mask3 = saturate((uv0.w - lerp(-150.0,60.0,(10.0/25.0)))*0.01);
	//maskcastshadow = saturate((uv0.w - lerp(0.0,60.0,(_castshadowFade/100.0)))*0.01);
	
	//o.Normal = lerp(o.Normal,lerp(o.Normal,fixed3(0,0,1),0.7),mask1);

	//o.Normal = norm1;
	
	// decode cube / mobile reflection
	//fixed3 cubeRef = texCUBE(_CubeTex, WorldReflectionVector(IN, o.Normal)).rgb;
	//reflectCUBE.rgb = cubeRef.rgb;
	//reflectCUBE.rgb = fixed3(0.9,0.9,1.0);//cubeRef.rgb;
	fixed3 cubeRef = texCUBE(_CubeTex, WorldReflectionVector(IN, lerp(o.Normal,half3(0,0,o.Normal.z),1.0))).rgb;
	reflectCUBE.rgb = cubeRef.rgb;
	
	//add final detail normal (preferred blend function)
	//fixed3 AddNDet = lerp(lerp(waveFac4*2.0,fixed3(0,0,1),1.0-_BumpStrength),fixed3(0,0,1),mask3);
 	//o.Normal = normalize(fixed3(o.Normal.xy + AddNDet.xy, o.Normal.z*AddNDet.z)); //whiteout function

	o.Albedo = _DepthColorB.rgb;
	o.Alpha = _DepthColorB.a;// * _OverallTrans;
	o.Gloss = 0.0;
	o.Specular = 0.0;

}
ENDCG








}
//FallBack "Diffuse"
}
