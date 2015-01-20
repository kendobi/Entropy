//Version=1.1
Shader"UNOShader/Unlit Library/VertexCol LightmapUnity ShadowAmbient "
{
	Properties
	{
		_ColorBase ("Color (A)Opacity", Color) = (1,1,1,1)
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

			sampler2D unity_Lightmap; //Far lightmap.
			float4 unity_LightmapST; //Lightmap atlasing data.
			sampler2D unity_LightmapInd; //Near lightmap (indirect lighting only).
			fixed _UNOShaderLightmapOpacity;
			struct customData
			{
				float4 vertex : POSITION;
				half3 normal : NORMAL;
				fixed4 texcoord1 : TEXCOORD1;
				fixed4 color : COLOR;
			};
			struct v2f // = vertex to fragment ( pass vertex data to pixel pass )
			{
				float4 pos : SV_POSITION;
				fixed4 vc : COLOR;
				fixed2 uv2 : TEXCOORD1;
				LIGHTING_COORDS(5, 6)
			};
			v2f vert (customData v)
			{
				v2f o;
				o.pos = 	mul (UNITY_MATRIX_MVP, v.vertex);
				o.vc = v.color;
				o.uv2 = 	v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw; //Unity matrix lightmap uvs
				TRANSFER_VERTEX_TO_FRAGMENT(o) // This sets up the vertex attributes required for lighting and passes them through to the fragment shader.
				return o;
			}

			fixed4 frag (v2f i) : COLOR  // i = in gets info from the out of the v2f vert
			{
				fixed4 result = fixed4(1,1,1,0);
				fixed4 Lightmap = fixed4(DecodeLightmap(tex2D(unity_Lightmap, i.uv2)),1);
				result = fixed4(result.rgb * i.vc.rgb, result.a);
				fixed ShadowMask = LIGHT_ATTENUATION(i); // This gets the shadow and attenuation values combined.
				result = lerp(result,result * (UNITY_LIGHTMODEL_AMBIENT * 2),(1 - ShadowMask));
				#ifdef LIGHTMAP_ON
				result = lerp(result,result * Lightmap, _UNOShaderLightmapOpacity);
				#endif
				result = fixed4(result.rgb,result.a * i.vc.a);
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