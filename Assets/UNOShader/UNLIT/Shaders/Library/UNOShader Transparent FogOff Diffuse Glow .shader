//Version=1.1
Shader"UNOShader/Unlit Library/Self-Illumin/Transparent FogOff Diffuse Glow "
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
			Fog {Mode Off}
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

			fixed4 _DiffuseColor;
			sampler2D _DiffuseTex;
			float4 _DiffuseTex_ST;
			float4x4 _MatrixDiffuse;

			fixed4 _GlowColor;
			sampler2D _GlowTex;
			float4 _GlowTex_ST;
			fixed _GlowV;
			float4x4 _MatrixGlow;
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
				fixed2 uv3 : TEXCOORD3;
				fixed4 lp : TEXCOORD7;
			};
			v2f vert (customData v)
			{
				v2f o;
				o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
				o.uv.xy = TRANSFORM_TEX (v.texcoord, _DiffuseTex); // this allows you to offset uvs and such
				o.uv3.xy = TRANSFORM_TEX (v.texcoord, _GlowTex); // this allows you to offset uvs and such
				o.uv.xy = mul(_MatrixDiffuse, fixed4(o.uv.xy,0,1)); // this allows you to rotate uvs and such with script help
				o.uv3.xy = mul(_MatrixGlow, fixed4(o.uv3.xy,0,1)); // this allows you to rotate uvs and such with script help
				return o;
			}

			fixed4 frag (v2f i) : COLOR  // i = in gets info from the out of the v2f vert
			{
				fixed4 result = fixed4(1,1,1,0);
				fixed4 T_Diffuse = tex2D(_DiffuseTex, i.uv.xy);
				fixed4 GlowColor = _GlowColor;
				fixed4 T_Glow = tex2D (_GlowTex,i.uv3.xy);
				result = _DiffuseColor * T_Diffuse;
				fixed4 GlowResult = GlowColor * T_Glow;
				fixed GlowAmount = GlowColor.a * T_Glow.a;
				result = lerp (result,fixed4(GlowResult.rgb * _GlowV,1),GlowAmount);
				return result;
			}
			ENDCG
		}//-------------------------------Pass-------------------------------
	} //-------------------------------SubShader-------------------------------
	Fallback "UNOShader/Helpers/VertexUnlit Transparent"
	CustomEditor "UNOShaderUnlit_MaterialEditor"
}