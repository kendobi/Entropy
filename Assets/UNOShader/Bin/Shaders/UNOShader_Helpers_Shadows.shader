Shader "UNOShader/Helpers/Shadows" 
{
	Properties 
	{
	_ColorBase ("Main Color", Color) = (1,1,1,1)
	
	_DiffuseTex ("Base (RGB) Trans (A)", 2D) = "Black" {}
	_DiffuseColor ("Main Color", Color) = (1,1,1,1)
	
	_DecalTex ("Base (RGB) Trans (A)", 2D) = "Black" {}
	_DecalColor ("Main Color", Color) = (1,1,1,1)
	
	_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
	}

	SubShader 
	{
		Pass 
		{
			Name "SHADOWCAST"
			Tags { "LightMode" = "ShadowCaster" }
			
			Fog {Mode Off}
			ZWrite On ZTest LEqual Cull Off
			Offset 1, 1

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_shadowcaster
			#include "UnityCG.cginc"


			struct v2f { 
				V2F_SHADOW_CASTER;
			};

			v2f vert( appdata_base v )
			{
				v2f o;
				TRANSFER_SHADOW_CASTER(o)
				return o;
			}

			float4 frag( v2f i ) : COLOR
			{
				SHADOW_CASTER_FRAGMENT(i)
			}

			ENDCG

		}
		
		// Pass to render object as a shadow collector
		Pass 
		{
			Name "SHADOWCOLLECTOR"
			Tags { "LightMode" = "ShadowCollector" }
			
			Fog {Mode Off}
			ZWrite On ZTest LEqual

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_shadowcollector 

			#define SHADOW_COLLECTOR_PASS
			#include "UnityCG.cginc"


			struct appdata {
				float4 vertex : POSITION;
			};

			struct v2f {
				V2F_SHADOW_COLLECTOR;
			};

			v2f vert (appdata v)
			{
				v2f o;
				TRANSFER_SHADOW_COLLECTOR(o)
				return o;
			}

			fixed4 frag (v2f i) : COLOR
			{
				SHADOW_COLLECTOR_FRAGMENT(i)
			}

			ENDCG

		}
		
	}//-- Subshader
}
