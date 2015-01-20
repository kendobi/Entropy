//Version=1.1
Shader"UNOShader/Unlit Library/Self-Illumin/Diffuse Glow Reflection Rim LightmapTexture ShadowAmbient "
{
	Properties
	{
		_DiffuseColor ("Tint", Color) = (1,1,1,1)
		_DiffuseTex ("Texture", 2D) = "white" {}
		_MainTex ("Glow Hack", 2D) = "white" {}
		_Color ("Glow Hack", Color) = (1,1,1,1)
		_Illum ("Glow Hack", 2D) = "white" {}
		_GlowColor ("Tint", Color) = (1,.7,.3,0)
		_GlowTex ("Texture (A)Mask", 2D) = "white" {}
		_GlowV ("Visual Intensity", Range(1,10) ) = 1
		_EmissionLM ("LightmapBake Intensity", Range(1,20) ) = 2
		_Cube ("Cubemap(A)Luminance", Cube) = "white" {}
		_RefAmount ("Opacity", Range (0, 1)) = 1
		_RefBias ("Bias", Range (0, 5)) = 1
		_RefLum ("Luminance", Range (0, 5)) = 0
		_LightmapTex ("Texture", 2D) = "gray" {}
		_LightmapOpacity ("Opacity", Range (0,1)) = 1
		_RimColor ("Color (A)Opacity", Color) = (1,1,1,1)
		_RimBias ("Bias", Range (0, 5)) = 1
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
			"RenderType" = "Opaque"
			"Queue" = "Geometry"
		}
		Pass
			{
			Tags
			{
				"RenderType" = "Opaque"
				"Queue" = "Geometry"
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

			fixed4 _DiffuseColor;
			sampler2D _DiffuseTex;
			float4 _DiffuseTex_ST;
			float4x4 _MatrixDiffuse;

			fixed4 _GlowColor;
			sampler2D _GlowTex;
			float4 _GlowTex_ST;
			fixed _GlowV;
			float4x4 _MatrixGlow;

			samplerCUBE _Cube;
			fixed _RefAmount;
			fixed _RefBias;
			fixed _RefLum;

			fixed4 _RimColor;
			fixed _RimBias;

			sampler2D _LightmapTex;
			float4 _LightmapTex_ST;
			float _LightmapOpacity;
			struct customData
			{
				float4 vertex : POSITION;
				half3 normal : NORMAL;
				fixed2 texcoord : TEXCOORD0;
				fixed4 texcoord1 : TEXCOORD1;
			};
			struct v2f // = vertex to fragment ( pass vertex data to pixel pass )
			{
				float4 pos : SV_POSITION;
				fixed4 uv : TEXCOORD0;
				fixed2 uv2 : TEXCOORD1;
				fixed2 uv3 : TEXCOORD3;
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
				o.uv.xy =		TRANSFORM_TEX (v.texcoord, _DiffuseTex); // this allows you to offset uvs and such
				o.uv3.xy =	TRANSFORM_TEX (v.texcoord, _GlowTex); // this allows you to offset uvs and such
				o.uv.xy = 	mul(_MatrixDiffuse, fixed4(o.uv.xy,0,1)); // this allows you to rotate uvs and such with script help
				o.uv3.xy = 	mul(_MatrixGlow, fixed4(o.uv3.xy,0,1)); // this allows you to rotate uvs and such with script help
				o.uv2 = 	v.texcoord1; //--- regular uv2
				TRANSFER_VERTEX_TO_FRAGMENT(o) // This sets up the vertex attributes required for lighting and passes them through to the fragment shader.
				o.refl = -reflect( normalize (viewN),normalize(worldN));
				o.Ndot.x = ( 1-(clamp((dot(viewDir, v.normal)*_RefBias),0,1)) ) * _RefAmount;
				o.Ndot.y = ( 1-(clamp((dot(viewDir, v.normal)*_RimBias),0,1)) )* _RimColor.a;
				return o;
			}

			fixed4 frag (v2f i) : COLOR  // i = in gets info from the out of the v2f vert
			{
				fixed4 result = fixed4(1,1,1,0);
				fixed4 T_Diffuse = tex2D(_DiffuseTex, i.uv.xy);
				fixed4 Cubemap = texCUBE(_Cube, i.refl);
				fixed4 GlowColor = _GlowColor;
				fixed4 T_Glow = tex2D (_GlowTex,i.uv3.xy);
				fixed4 Lightmap = tex2D(_LightmapTex, i.uv2);
				result = _DiffuseColor * T_Diffuse;
				fixed RefAmount = i.Ndot.x;
				result = lerp (result ,result + fixed4(Cubemap.rgb +(_RefLum*Cubemap.a),Luminance(Cubemap.xyz).rrrr.a)+(_RefLum*Cubemap.a), RefAmount);
				fixed RimAmount = i.Ndot.y;
				result = lerp (result, _RimColor, RimAmount);
				fixed ShadowMask = LIGHT_ATTENUATION(i); // This gets the shadow and attenuation values combined.
				result = lerp(result,result * (UNITY_LIGHTMODEL_AMBIENT * 2),(1 - ShadowMask));
				result = lerp(result,result * fixed4((8 * Lightmap.a) * Lightmap.rgb,1),_LightmapOpacity);
				fixed4 GlowResult = GlowColor * T_Glow;
				fixed GlowAmount = GlowColor.a * T_Glow.a;
				result = lerp (result,fixed4(GlowResult.rgb * _GlowV,1),GlowAmount);
				return result;
			}
			ENDCG
		}//-------------------------------Pass-------------------------------
		UsePass "UNOShader/Helpers/Shadows/SHADOWCAST"
		UsePass "UNOShader/Helpers/Shadows/SHADOWCOLLECTOR"
	} //-------------------------------SubShader-------------------------------
	Fallback "UNOShader/Helpers/VertexUnlit"
	CustomEditor "UNOShaderUnlit_MaterialEditor"
}