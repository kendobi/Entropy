Shader "UNOShader/Helpers/Shadows Transparent" 
{
	Properties 
	{
	_ColorBase ("Main Color", Color) = (1,1,1,1)
	_MainTex ("Base (RGB) Trans (A)", 2D) = "Black" {}
	_DiffuseTex ("Base (RGB) Trans (A)", 2D) = "Black" {}
	_DiffuseColor ("Main Color", Color) = (1,1,1,1)
	
	_DecalTex ("Base (RGB) Trans (A)", 2D) = "Black" {}
	_DecalColor ("Main Color", Color) = (1,1,1,1)	
	
	_GlowTex ("Base (RGB) Trans (A)", 2D) = "Black" {}
	_GlowColor ("Main Color", Color) = (1,1,1,1)	
	}

	SubShader 
	{
		Pass 
		{
			Name "SHADOWCAST"
			Tags { "LightMode" = "ShadowCaster" }
			Offset 1, 1
			Fog {Mode Off}
			ZWrite On 
			ZTest LEqual 
			//Cull Off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_shadowcaster
			#include "UnityCG.cginc"

			uniform fixed4 _ColorBase;
			uniform sampler2D _DiffuseTex;
			uniform float4 _DiffuseTex_ST;
			uniform fixed4 _DiffuseColor;
			float4x4 _MatrixDiffuse;
			
			uniform sampler2D _DecalTex;
			uniform float4 _DecalTex_ST;
			uniform fixed4 _DecalColor;
			float4x4 _MatrixDecal;
			
			uniform sampler2D _GlowTex;
			uniform float4 _GlowTex_ST;
			uniform fixed4 _GlowColor;
			float4x4 _MatrixGlow;
			
			
			struct v2f 
			{ 
				V2F_SHADOW_CASTER;
				fixed2  uv : TEXCOORD5;
				fixed2  uv2 : TEXCOORD6;
				fixed2  uv3 : TEXCOORD7;
			};


			v2f vert( appdata_base v )
			{
				v2f o;
				TRANSFER_SHADOW_CASTER(o)
				o.uv = TRANSFORM_TEX(v.texcoord, _DiffuseTex);
				o.uv = 	mul(_MatrixDiffuse, fixed4(o.uv,0,1)); // this allows you to rotate uvs and such with script help
				
				o.uv2 = TRANSFORM_TEX(v.texcoord, _DecalTex);
				o.uv2 =	mul(_MatrixDecal, fixed4(o.uv2,0,1)); // this allows you to rotate uvs and such with script help
				
				o.uv3 = TRANSFORM_TEX(v.texcoord, _GlowTex);
				o.uv3 =	mul(_MatrixGlow, fixed4(o.uv3,0,1)); // this allows you to rotate uvs and such with script help
				
				return o;
			}

			

			float4 frag( v2f i ) : COLOR
			{
				fixed4 T_Diffuse = tex2D( _DiffuseTex, i.uv );
				fixed4 T_Decal = tex2D( _DecalTex, i.uv2 );
				fixed4 T_Glow = tex2D( _GlowTex, i.uv3 );
				fixed result = lerp( T_Diffuse.a * _DiffuseColor.a,1,T_Decal.a * _DecalColor.a );
				result = lerp( result,1,T_Glow.a * _GlowColor.a ) + _ColorBase.a;
				clip( result -.3 );
				
				SHADOW_CASTER_FRAGMENT(i)
			}
			ENDCG

		}// Pass
	
		// Pass to render object as a shadow collector
		Pass 
		{
			Name "SHADOWCOLLECTOR"
			Tags { "LightMode" = "ShadowCollector" }
			
			//Offset 1, 1
			Fog {Mode Off}
			ZWrite On ZTest LEqual 
			//Cull Off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_shadowcollector

			#define SHADOW_COLLECTOR_PASS
			#include "UnityCG.cginc"

			uniform fixed4 _ColorBase;
			uniform sampler2D _DiffuseTex;
			uniform float4 _DiffuseTex_ST;
			uniform fixed4 _DiffuseColor;
			float4x4 _MatrixDiffuse;
			
			uniform sampler2D _DecalTex;
			uniform float4 _DecalTex_ST;
			uniform fixed4 _DecalColor;
			float4x4 _MatrixDecal;
			
			uniform sampler2D _GlowTex;
			uniform float4 _GlowTex_ST;
			uniform fixed4 _GlowColor;
			float4x4 _MatrixGlow;
			

			struct v2f 
			{
				V2F_SHADOW_COLLECTOR;
				fixed2  uv : TEXCOORD5;
				fixed2  uv2 : TEXCOORD6;
				fixed2  uv3 : TEXCOORD7;
			};
			v2f vert (appdata_base v)
			{
				v2f o;
				TRANSFER_SHADOW_COLLECTOR(o)
				o.uv = TRANSFORM_TEX(v.texcoord, _DiffuseTex);
				o.uv = 	mul(_MatrixDiffuse, fixed4(o.uv,0,1)); // this allows you to rotate uvs and such with script help
				
				o.uv2 = TRANSFORM_TEX(v.texcoord, _DecalTex);
				o.uv2 =	mul(_MatrixDecal, fixed4(o.uv2,0,1)); // this allows you to rotate uvs and such with script help
				
				o.uv3 = TRANSFORM_TEX(v.texcoord, _GlowTex);
				o.uv3 =	mul(_MatrixGlow, fixed4(o.uv3,0,1)); // this allows you to rotate uvs and such with script help
				
				return o;
			}
			
			fixed4 frag (v2f i) : COLOR
			{
				fixed4 T_Diffuse = tex2D( _DiffuseTex, i.uv );
				fixed4 T_Decal = tex2D( _DecalTex, i.uv2 );
				fixed4 T_Glow = tex2D( _GlowTex, i.uv3 );
				fixed result = lerp( T_Diffuse.a * _DiffuseColor.a,1,T_Decal.a * _DecalColor.a );
				result = lerp( result,1,T_Glow.a * _GlowColor.a ) + _ColorBase.a;
				clip( result -.3 );

				
				SHADOW_COLLECTOR_FRAGMENT(i)
			}
			ENDCG

		}//-- Pass
		
		Pass 
		{
			Name "SHADOWCAST CULLOFF"
			Tags { "LightMode" = "ShadowCaster" }
			Offset 1, 1
			Fog {Mode Off}
			ZWrite On 
			ZTest LEqual 
			Cull Off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_shadowcaster
			#include "UnityCG.cginc"

			uniform fixed4 _ColorBase;
			uniform sampler2D _DiffuseTex;
			uniform float4 _DiffuseTex_ST;
			uniform fixed4 _DiffuseColor;
			float4x4 _MatrixDiffuse;
			
			uniform sampler2D _DecalTex;
			uniform float4 _DecalTex_ST;
			uniform fixed4 _DecalColor;
			float4x4 _MatrixDecal;
			
			uniform sampler2D _GlowTex;
			uniform float4 _GlowTex_ST;
			uniform fixed4 _GlowColor;
			float4x4 _MatrixGlow;
			
			struct v2f 
			{ 
				V2F_SHADOW_CASTER;
				fixed2  uv : TEXCOORD5;
				fixed2  uv2 : TEXCOORD6;
				fixed2  uv3 : TEXCOORD7;
			};


			v2f vert( appdata_base v )
			{
				v2f o;
				TRANSFER_SHADOW_CASTER(o)
				
				o.uv = TRANSFORM_TEX(v.texcoord, _DiffuseTex);
				o.uv = 	mul(_MatrixDiffuse, fixed4(o.uv,0,1)); // this allows you to rotate uvs and such with script help
				
				o.uv2 = TRANSFORM_TEX(v.texcoord, _DecalTex);
				o.uv2 =	mul(_MatrixDecal, fixed4(o.uv2,0,1)); // this allows you to rotate uvs and such with script help
				
				o.uv3 = TRANSFORM_TEX(v.texcoord, _GlowTex);
				o.uv3 =	mul(_MatrixGlow, fixed4(o.uv3,0,1)); // this allows you to rotate uvs and such with script help
				
				return o;
			}

			

			float4 frag( v2f i ) : COLOR
			{
				fixed4 T_Diffuse = tex2D( _DiffuseTex, i.uv );
				fixed4 T_Decal = tex2D( _DecalTex, i.uv2 );
				fixed4 T_Glow = tex2D( _GlowTex, i.uv3 );
				fixed result = lerp( T_Diffuse.a * _DiffuseColor.a,1,T_Decal.a * _DecalColor.a );
				result = lerp( result,1,T_Glow.a * _GlowColor.a ) + _ColorBase.a;
				clip( result -.3 );
				
				SHADOW_CASTER_FRAGMENT(i)
			}
			ENDCG

		}// Pass
	
		// Pass to render object as a shadow collector
		Pass 
		{
			Name "SHADOWCOLLECTOR CULLOFF"
			Tags { "LightMode" = "ShadowCollector" }
			
			//Offset 1, 1
			Fog {Mode Off}
			ZWrite On ZTest LEqual 
			Cull Off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_shadowcollector

			#define SHADOW_COLLECTOR_PASS
			#include "UnityCG.cginc"

			uniform fixed4 _ColorBase;
			uniform sampler2D _DiffuseTex;
			uniform float4 _DiffuseTex_ST;
			uniform fixed4 _DiffuseColor;
			float4x4 _MatrixDiffuse;
			
			uniform sampler2D _DecalTex;
			uniform float4 _DecalTex_ST;
			uniform fixed4 _DecalColor;
			float4x4 _MatrixDecal;
			
			uniform sampler2D _GlowTex;
			uniform float4 _GlowTex_ST;
			uniform fixed4 _GlowColor;
			float4x4 _MatrixGlow;
			

			struct v2f 
			{
				V2F_SHADOW_COLLECTOR;
				fixed2  uv : TEXCOORD5;
				fixed2  uv2 : TEXCOORD6;
				fixed2  uv3 : TEXCOORD7;
			};
			v2f vert (appdata_base v)
			{
				v2f o;
				TRANSFER_SHADOW_COLLECTOR(o)
				o.uv = TRANSFORM_TEX(v.texcoord, _DiffuseTex);
				o.uv = 	mul(_MatrixDiffuse, fixed4(o.uv,0,1)); // this allows you to rotate uvs and such with script help
				
				o.uv2 = TRANSFORM_TEX(v.texcoord, _DecalTex);
				o.uv2 =	mul(_MatrixDecal, fixed4(o.uv2,0,1)); // this allows you to rotate uvs and such with script help
				
				o.uv3 = TRANSFORM_TEX(v.texcoord, _GlowTex);
				o.uv3 =	mul(_MatrixGlow, fixed4(o.uv3,0,1)); // this allows you to rotate uvs and such with script help
				
				return o;
			}
			
			fixed4 frag (v2f i) : COLOR
			{
				fixed4 T_Diffuse = tex2D( _DiffuseTex, i.uv );
				fixed4 T_Decal = tex2D( _DecalTex, i.uv2 );
				fixed4 T_Glow = tex2D( _GlowTex, i.uv3 );
				fixed result = lerp( T_Diffuse.a * _DiffuseColor.a,1,T_Decal.a * _DecalColor.a );
				result = lerp( result,1,T_Glow.a * _GlowColor.a ) + _ColorBase.a;
				clip( result -.3 );
				
				SHADOW_COLLECTOR_FRAGMENT(i)
			}
			ENDCG

		}//-- Pass
		
	}//-- Subshader
}
