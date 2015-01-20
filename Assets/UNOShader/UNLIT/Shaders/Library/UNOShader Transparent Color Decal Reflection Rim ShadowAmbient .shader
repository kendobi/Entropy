//Version=1.1
Shader"UNOShader/Unlit Library/Transparent Color Decal Reflection Rim ShadowAmbient "
{
	Properties
	{
		_ColorBase ("Color (A)Opacity", Color) = (1,1,1,1)
		_DecalColor ("Tint", Color) = (1,1,1,1)
		_DecalTex ("Texture (A)Opacity", 2D) = "black" {}
		_MainTex ("Glow Hack", 2D) = "white" {}
		_Color ("Glow Hack", Color) = (1,1,1,1)
		_Cube ("Cubemap(A)Luminance", Cube) = "white" {}
		_RefAmount ("Opacity", Range (0, 1)) = 1
		_RefBias ("Bias", Range (0, 5)) = 1
		_RefLum ("Luminance", Range (0, 5)) = 0
		_RimColor ("Color (A)Opacity", Color) = (1,1,1,1)
		_RimBias ("Bias", Range (0, 5)) = 1
		_Cutoff ("Alpha cutoff", Range(0,1.001)) = 0.5
	}
	SubShader
	{
		Tags
		{
			//--- "RenderType" sets the group that it belongs to type and uses: Opaque, Transparent,
			//--- TransparentCutout, Background, Overlay(Gui,halo,Flare shaders), TreeOpaque, TreeTransparentCutout, TreeBilboard,Grass, GrassBilboard.
			//--- "Queue" sets order and uses: Background (for skyboxes), Geometry(default), AlphaTest(?, water),
			//--- Transparent(draws after AlphaTest, back to front order), Overlay(effects,ie lens flares)
			//--- adding +number to tags "Geometry +1" will affect draw order. B=1000 G=2000 AT= 2450 T=3000 O=4000
			"RenderType" = "Transparent"
			"Queue" = "Transparent"
		}
			Offset -1.0,0
			Blend SrcAlpha OneMinusSrcAlpha // --- not needed when doing cutout
		Pass
			{
			Tags
			{
				"RenderType" = "Transparent"
				"Queue" = "Transparent"
				"LightMode" = "ForwardBase"
			}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#pragma multi_compile_fwdbase
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "AutoLight.cginc"
			#include "Lighting.cginc"
			fixed4 _ColorBase;

			fixed4 _DecalColor;
			sampler2D _DecalTex;
			float4 _DecalTex_ST;
			float4x4 _MatrixDecal;

			samplerCUBE _Cube;
			fixed _RefAmount;
			fixed _RefBias;
			fixed _RefLum;

			fixed4 _RimColor;
			fixed _RimBias;
			struct customData
			{
				float4 vertex : POSITION;
				half3 normal : NORMAL;
				fixed2 texcoord : TEXCOORD0;
			};
			struct v2f // = vertex to fragment ( pass vertex data to pixel pass )
			{
				float4 pos : SV_POSITION;
				fixed4 uv : TEXCOORD0;
				half3 refl : TEXCOORD2;
				half2 Ndot : TEXCOORD4;
				LIGHTING_COORDS(5, 6)
			};
			v2f vert (customData v)
			{
				v2f o;
				half3 viewDir = 	normalize(ObjSpaceViewDir(v.vertex));
				half3 worldN = mul((float3x3)_Object2World, SCALED_NORMAL);
				half3 viewN = WorldSpaceViewDir(v.vertex);
				o.pos = 	mul (UNITY_MATRIX_MVP, v.vertex);
				o.uv.zw =	TRANSFORM_TEX (v.texcoord, _DecalTex); // this allows you to offset uvs and such
				o.uv.zw = 	mul(_MatrixDecal, fixed4(o.uv.zw,0,1)); // this allows you to rotate uvs and such with script help
				TRANSFER_VERTEX_TO_FRAGMENT(o) // This sets up the vertex attributes required for lighting and passes them through to the fragment shader.
				o.refl = -reflect( normalize (viewN),normalize(worldN));
				o.Ndot.x = ( 1-(clamp((dot(viewDir, v.normal)*_RefBias),0,1)) ) * _RefAmount;
				o.Ndot.y = ( 1-(clamp((dot(viewDir, v.normal)*_RimBias),0,1)) )* _RimColor.a;
				return o;
			}

			fixed4 frag (v2f i) : COLOR  // i = in gets info from the out of the v2f vert
			{
				fixed4 result = fixed4(1,1,1,0);
				fixed4 ColorBase = _ColorBase;
				fixed4 T_Decal = tex2D(_DecalTex, i.uv.zw);
				fixed4 Cubemap = texCUBE(_Cube, i.refl);
				result = ColorBase;
				fixed4 DecResult = _DecalColor * T_Decal;
				result = lerp(result,fixed4(DecResult.rgb,1),T_Decal.a*_DecalColor.a);
				fixed RefAmount = i.Ndot.x;
				result = lerp (result ,result + fixed4(Cubemap.rgb +(_RefLum*Cubemap.a),Luminance(Cubemap.xyz).rrrr.a)+(_RefLum*Cubemap.a), RefAmount);
				fixed RimAmount = i.Ndot.y;
				result = lerp (result, _RimColor, RimAmount);
				fixed ShadowMask = LIGHT_ATTENUATION(i); // This gets the shadow and attenuation values combined.
				result = lerp(result,result * (UNITY_LIGHTMODEL_AMBIENT * 2),(1 - ShadowMask));
				return result;
			}
			ENDCG
		}//-------------------------------Pass-------------------------------
		UsePass "UNOShader/Helpers/Shadows Transparent/SHADOWCAST"
		UsePass "UNOShader/Helpers/Shadows Transparent/SHADOWCOLLECTOR"
	} //-------------------------------SubShader-------------------------------
	Fallback "UNOShader/Helpers/VertexUnlit Transparent"
	CustomEditor "UNOShaderUnlit_MaterialEditor"
}