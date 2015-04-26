//Version=1.1
Shader"UNOShader/Unlit Library/FogOff Color Rim ShadowAmbient "
{
	Properties
	{
		_ColorBase ("Color (A)Opacity", Color) = (1,1,1,1)
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
			Fog {Mode Off}
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
			fixed4 _ColorBase;

			fixed4 _RimColor;
			fixed _RimBias;
			struct customData
			{
				float4 vertex : POSITION;
				half3 normal : NORMAL;
			};
			struct v2f // = vertex to fragment ( pass vertex data to pixel pass )
			{
				float4 pos : SV_POSITION;
				half3 refl : TEXCOORD2;
				half2 Ndot : TEXCOORD4;
				LIGHTING_COORDS(5, 6)
				fixed4 lp : TEXCOORD7;
			};
			v2f vert (customData v)
			{
				v2f o;
				half3 viewDir = 	normalize(ObjSpaceViewDir(v.vertex));
				o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
				TRANSFER_VERTEX_TO_FRAGMENT(o) // This sets up the vertex attributes required for lighting and passes them through to the fragment shader.
				o.Ndot.y = ( 1-(clamp((dot(viewDir, v.normal)*_RimBias),0,1)) )* _RimColor.a;
				return o;
			}

			fixed4 frag (v2f i) : COLOR  // i = in gets info from the out of the v2f vert
			{
				fixed4 result = fixed4(1,1,1,0);
				fixed4 ColorBase = _ColorBase;
				result = ColorBase;
				fixed RimAmount = i.Ndot.y;
				result = lerp (result, _RimColor, RimAmount);
				fixed ShadowMask = LIGHT_ATTENUATION(i); // This gets the shadow and attenuation values combined.
				result = lerp(result,result * (UNITY_LIGHTMODEL_AMBIENT * 2),(1 - ShadowMask));
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