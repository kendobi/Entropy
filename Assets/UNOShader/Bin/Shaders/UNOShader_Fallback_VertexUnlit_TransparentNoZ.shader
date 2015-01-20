Shader "UNOShader/Helpers/VertexUnlit Transparent No Z" 
{
	Properties
	{
		_ColorBase ("Color (A)Opacity", Color) = (1,1,1,1)
		_DiffuseColor ("Tint", Color) = (1,1,1,1)
		_DiffuseTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags
		{
		}
		Zwrite Off
		Offset -2.0,0
		Blend SrcAlpha OneMinusSrcAlpha // --- not needed when doing cutout
		Pass
			{
			Tags
			{
				"RenderType" = "Transparent"
				"Queue" = "Transparent"
				"LightMode" = "Vertex"
			}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			//#pragma multi_compile_fwdbase
			fixed4 _ColorBase;

			fixed4 _DiffuseColor;
			sampler2D _DiffuseTex;
			float4 _DiffuseTex_ST;
			float4x4 _MatrixDiffuse;

			struct customData
			{
				float4 vertex : POSITION;
				half3 normal : NORMAL;
				fixed2 texcoord : TEXCOORD0;
				fixed4 color : COLOR;
			};
			struct v2f // = vertex to fragment ( pass vertex data to pixel pass )
			{
				float4 pos : SV_POSITION;
				fixed4 vc : COLOR;
				fixed4 uv : TEXCOORD0;
			};
			v2f vert (customData v)
			{
				v2f o;
				o.pos = 	mul (UNITY_MATRIX_MVP, v.vertex);
				o.vc = v.color;
				o.uv.xy =		TRANSFORM_TEX (v.texcoord, _DiffuseTex); // this allows you to offset uvs and such
				o.uv.xy = 	mul(_MatrixDiffuse, fixed4(o.uv.xy,0,1)); // this allows you to rotate uvs and such with script help
				return o;
			}

			fixed4 frag (v2f i) : COLOR  // i = in gets info from the out of the v2f vert
			{
				fixed4 result = fixed4(1,1,1,0);
				fixed4 ColorBase = _ColorBase;
				fixed4 T_Diffuse = tex2D(_DiffuseTex, i.uv.xy);
				result = ColorBase;
				fixed4 DiffResult = _DiffuseColor * T_Diffuse;
				result = lerp(result,fixed4(DiffResult.rgb,1),T_Diffuse.a*_DiffuseColor.a);
				result = fixed4(result.rgb * i.vc.rgb, result.a);
				result = fixed4(result.rgb,result.a * i.vc.a);
				return result;
			}
			ENDCG
		}//-------------------------------Pass-------------------------------
	
		Zwrite Off
		Offset -2.0,0
		Blend SrcAlpha OneMinusSrcAlpha // --- not needed when doing cutout
		Pass
			{
			Tags
			{
				"RenderType" = "Transparent"
				"Queue" = "Transparent"
				"LightMode" = "VertexLM"
			}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			//#pragma multi_compile_fwdbase
			fixed4 _ColorBase;

			fixed4 _DiffuseColor;
			sampler2D _DiffuseTex;
			float4 _DiffuseTex_ST;
			float4x4 _MatrixDiffuse;

			sampler2D unity_Lightmap; //Far lightmap.
			float4 unity_LightmapST; //Lightmap atlasing data.
			sampler2D unity_LightmapInd; //Near lightmap (indirect lighting only).
			fixed _UNOShaderLightmapOpacity;
			struct customData
			{
				float4 vertex : POSITION;
				half3 normal : NORMAL;
				fixed2 texcoord : TEXCOORD0;
				fixed4 texcoord1 : TEXCOORD1;
				fixed4 color : COLOR;
			};
			struct v2f // = vertex to fragment ( pass vertex data to pixel pass )
			{
				float4 pos : SV_POSITION;
				fixed4 vc : COLOR;
				fixed4 uv : TEXCOORD0;
				fixed2 uv2 : TEXCOORD1;
			};
			v2f vert (customData v)
			{
				v2f o;
				o.pos = 	mul (UNITY_MATRIX_MVP, v.vertex);
				o.vc = v.color;
				o.uv.xy =		TRANSFORM_TEX (v.texcoord, _DiffuseTex); // this allows you to offset uvs and such
				o.uv.xy = 	mul(_MatrixDiffuse, fixed4(o.uv.xy,0,1)); // this allows you to rotate uvs and such with script help
				o.uv2 = 	v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw; //Unity matrix lightmap uvs
				return o;
			}

			fixed4 frag (v2f i) : COLOR  // i = in gets info from the out of the v2f vert
			{
				fixed4 result = fixed4(1,1,1,0);
				fixed4 ColorBase = _ColorBase;
				fixed4 T_Diffuse = tex2D(_DiffuseTex, i.uv.xy);
				fixed4 Lightmap = fixed4(DecodeLightmap(tex2D(unity_Lightmap, i.uv2)),1);
				result = ColorBase;
				fixed4 DiffResult = _DiffuseColor * T_Diffuse;
				result = lerp(result,fixed4(DiffResult.rgb,1),T_Diffuse.a*_DiffuseColor.a);
				result = fixed4(result.rgb * i.vc.rgb, result.a);
				result = lerp(result,result * Lightmap, _UNOShaderLightmapOpacity);
				result = fixed4(result.rgb,result.a * i.vc.a);
				return result;
			}
			ENDCG
		}//--- Pass ---
		
		Zwrite Off
		Offset -2.0,0
		Blend SrcAlpha OneMinusSrcAlpha // --- not needed when doing cutout
		Pass
			{
			Tags
			{
				"RenderType" = "Transparent"
				"Queue" = "Transparent"
				"LightMode" = "VertexLMRGBM"
			}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			//#pragma multi_compile_fwdbase
			fixed4 _ColorBase;

			fixed4 _DiffuseColor;
			sampler2D _DiffuseTex;
			float4 _DiffuseTex_ST;
			float4x4 _MatrixDiffuse;

			sampler2D unity_Lightmap; //Far lightmap.
			float4 unity_LightmapST; //Lightmap atlasing data.
			sampler2D unity_LightmapInd; //Near lightmap (indirect lighting only).
			fixed _UNOShaderLightmapOpacity;
			struct customData
			{
				float4 vertex : POSITION;
				half3 normal : NORMAL;
				fixed2 texcoord : TEXCOORD0;
				fixed4 texcoord1 : TEXCOORD1;
				fixed4 color : COLOR;
			};
			struct v2f // = vertex to fragment ( pass vertex data to pixel pass )
			{
				float4 pos : SV_POSITION;
				fixed4 vc : COLOR;
				fixed4 uv : TEXCOORD0;
				fixed2 uv2 : TEXCOORD1;
			};
			v2f vert (customData v)
			{
				v2f o;
				o.pos = 	mul (UNITY_MATRIX_MVP, v.vertex);
				o.vc = v.color;
				o.uv.xy =		TRANSFORM_TEX (v.texcoord, _DiffuseTex); // this allows you to offset uvs and such
				o.uv.xy = 	mul(_MatrixDiffuse, fixed4(o.uv.xy,0,1)); // this allows you to rotate uvs and such with script help
				o.uv2 = 	v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw; //Unity matrix lightmap uvs
				return o;
			}

			fixed4 frag (v2f i) : COLOR  // i = in gets info from the out of the v2f vert
			{
				fixed4 result = fixed4(1,1,1,0);
				fixed4 ColorBase = _ColorBase;
				fixed4 T_Diffuse = tex2D(_DiffuseTex, i.uv.xy);
				fixed4 Lightmap = fixed4(DecodeLightmap(tex2D(unity_Lightmap, i.uv2)),1);
				result = ColorBase;
				fixed4 DiffResult = _DiffuseColor * T_Diffuse;
				result = lerp(result,fixed4(DiffResult.rgb,1),T_Diffuse.a*_DiffuseColor.a);
				result = fixed4(result.rgb * i.vc.rgb, result.a);
				result = lerp(result,result * Lightmap, _UNOShaderLightmapOpacity);
				result = fixed4(result.rgb,result.a * i.vc.a);
				return result;
			}
			ENDCG
		}//--- Pass ---
	} //-------------------------------SubShader-------------------------------
	

}
