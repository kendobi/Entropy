Shader "Clouds" {
    Properties {
        _BaseColor ("BaseColor", Color) = (1,1,1,1)
        _Shading ("Shading Color", Color) = (0, 0, 0, 0.5)
        _DepthColor ("DepthIntensity", Float ) = 0.5
        _PerlinNormalMap ("PerlinNormalMap", 2D) = "white" {}
        _Tiling ("Tiling", Float ) = 3000
        _Density ("Density", Float ) = -0.25
        _Alpha ("Alpha", Float ) = 5
        _AlphaCut ("AlphaCut", Float ) = 0.01
        _TimeMult ("Speed", Float ) = 0.1
        _TimeMultSecondLayer ("SpeedSecondLayer", Float ) = 4
        _WindDirection ("WindDirection", Vector) = (1,0,0,0)
        _DepthBlendMult ("Depth Blend Intensity", Range (0, 10)) = 2
        _EdgeBlend ("Edge Blend", Range (0, 10)) = 2
        //X, Y, Z are used to inverse normals at a specific slice pos to render the fake upper side of the cloud like he is supposed to be if geometry was double sided
        //W is used as the exact slice wich should be rendered when casting shadows
        [HideInInspector]_CloudNormalsDirection ("_CloudNormalsDirection", Vector) = (1, 1, -1, 0)
    }
    SubShader {
        Tags {
            "Queue"="Transparent-1"
            "RenderType"="Transparent"
            "IgnoreProjector"="True"
        }
        LOD 200
        Pass {
            Name "ForwardBase"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            //On = more accurate blending between different alpha objects but slower to render
            ZWrite On
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            //#pragma exclude_renderers xbox360 ps3 flash d3d11_9x 
            #pragma target 3.0
            #pragma glsl
            
            
            #pragma multi_compile DEPTHBLEND_ON DEPTHBLEND_OFF
            #pragma multi_compile LIGHTING_ON LIGHTING_OFF
            #pragma multi_compile HORIZONBLEND_ON HORIZONBLEND_OFF
            #pragma multi_compile NORMALIZED_ON NORMALIZED_OFF
            
            
            uniform fixed4 _TimeEditor;
            uniform fixed _TimeMult;
            uniform fixed _TimeMultSecondLayer;
            uniform fixed _Tiling;
            uniform fixed _Density;
            uniform fixed4 _BaseColor;
            uniform fixed _Alpha;
            uniform fixed _AlphaCut;
            uniform fixed _DepthColor;
            uniform sampler2D _PerlinNormalMap;
            uniform fixed4 _WindDirection;
            #if DEPTHBLEND_ON
            	uniform sampler2D _CameraDepthTexture;
            	uniform fixed _DepthBlendMult;
            #endif
            #if HORIZONBLEND_ON
            	uniform fixed _EdgeBlend;
            #endif
            uniform half4 _LightColor0;
            uniform fixed4 _Shading;
            uniform fixed4 _CloudNormalsDirection;
            
            
            
            struct VertexInput {
                half4 vertex : POSITION;
                half4 vertexColor : COLOR;
                half3 normal : NORMAL;
                #if LIGHTING_ON
                	half4 tangent : TANGENT;
                #endif
                #if HORIZONBLEND_ON
                	float2 texcoord0 : TEXCOORD0;
                #endif
            };
            
            
            
            struct VertexOutput {
                half4 pos : SV_POSITION;
                half4 posWorld : TEXCOORD5;
                half3 normalDir : TEXCOORD1;
                half4 vertexColor : COLOR;
                #if LIGHTING_ON
                	half3 tangentDir : TEXCOORD2;
                	half3 binormalDir : TEXCOORD3;
                #endif
                #if DEPTHBLEND_ON
                	half4 projPos : TEXCOORD4;
                #endif
                #if HORIZONBLEND_ON
                	float2 uv0 : TEXCOORD0;
                #endif
            };
            
            
            
            VertexOutput vert (VertexInput v) {
                VertexOutput o;
                o.normalDir = mul(half4(v.normal,0), _World2Object).xyz;
                o.posWorld = mul(_Object2World, v.vertex);
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                o.vertexColor = v.vertexColor;
                #if LIGHTING_ON
                	o.tangentDir = normalize( mul( _Object2World, half4( v.tangent.xyz, 0.0 ) ).xyz );
                	o.binormalDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                #endif
                #if DEPTHBLEND_ON
               		o.projPos = ComputeScreenPos (o.pos);
                	COMPUTE_EYEDEPTH(o.projPos.z);
                #endif
                #if HORIZONBLEND_ON
                	o.uv0 = v.texcoord0;
                #endif
                return o;
            }
            
            
            
            fixed4 frag(VertexOutput i) : COLOR {
            	//-----------------------------\\
            	//Animation, morphing and alpha||
                //-----------------------------//
                
                fixed2 baseAnimation = (_Time.g + _TimeEditor.g) * 0.001 * _WindDirection.rb;
                fixed2 uvAnimation = baseAnimation * _TimeMult;
                fixed2 uvAnimation2 = baseAnimation * _TimeMultSecondLayer;
                
                fixed2 worldUV = i.posWorld.rb / _Tiling;

                fixed2 newUV = worldUV + uvAnimation;
                fixed2 newUV2 = fixed2(0.0,0.5) + (worldUV + uvAnimation2);
                
                fixed4 cloudTexture = tex2D(_PerlinNormalMap, newUV);
                fixed4 cloudTexture2 = tex2D(_PerlinNormalMap, newUV2);
                
                
                #if DEPTHBLEND_ON
                	float sceneZ = max(0,LinearEyeDepth (UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)))) - _ProjectionParams.g);
                	float partZ = max(0,i.projPos.z - _ProjectionParams.g);
					fixed cloudMorph = ((saturate(cloudTexture.a + _Density) * i.vertexColor.a) - cloudTexture2.a) * _Alpha * (saturate((sceneZ-partZ)/partZ)*_DepthBlendMult);
                #endif
                #if DEPTHBLEND_OFF
                	fixed cloudMorph = ((saturate(cloudTexture.a + _Density) * i.vertexColor.a) - cloudTexture2.a) * _Alpha;
                #endif
                
                #if HORIZONBLEND_ON
        			cloudMorph *= pow(saturate(1-length(i.uv0*2.0+-1.0)), _EdgeBlend);
        		#endif
                fixed cloudAlphaCut = cloudMorph -_AlphaCut;
                
                
                clip(saturate(ceil(cloudAlphaCut)) - 0.5);
                
                
                //-------------------\\
            	//Colors and lighting||
                //-------------------//
                
                fixed fakeDepth = saturate(_DepthColor+(i.vertexColor.b * _CloudNormalsDirection.g+1)/2);
                #if LIGHTING_ON
                	half3x3 tangentTransform = half3x3( i.tangentDir, i.binormalDir, i.normalDir);
                
                	half3 normalLocal = ((cloudTexture.rgb * i.vertexColor.a) - cloudTexture2.rgb) * _CloudNormalsDirection.rgb * float3(1, 1, i.vertexColor.b*1);
                	half3 normalDirection =  normalize(mul(normalLocal, tangentTransform));
                	//half3 lightDirection = _WorldSpaceLightPos0.xyz; 0.5*dot(node_4,node_5)+0.5
                	#if NORMALIZED_ON
                	fixed shadingRamp = (1.0 - (( 1.0 - max(0, 0.5*dot(_WorldSpaceLightPos0.xyz, normalDirection)+0.5)) * _Shading.a)) * fakeDepth;
                	#endif
                	#if NORMALIZED_OFF
                	fixed shadingRamp = (1.0 - (( 1.0 - max(0, dot(_WorldSpaceLightPos0.xyz, normalDirection))) * _Shading.a)) * fakeDepth;
                	#endif
                #endif
                #if LIGHTING_OFF
                	fixed shadingRamp = fakeDepth;
                #endif
                
                fixed3 finalColor = lerp( _Shading.rgb, _BaseColor.rgb, shadingRamp) * _LightColor0.rgb;
                return fixed4(finalColor, cloudMorph);
            }
            ENDCG
        }
        
        
        //-------------\\
        //SHADOW CASTER||
        //-------------//

        Pass {
            Name "ShadowCaster"
            Tags {
                "LightMode"="ShadowCaster"
            }
            Cull off
            Offset 1, 1
            Fog{Mode Off}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            //#pragma exclude_renderers xbox360 ps3 flash d3d11_9x 
            #pragma target 3.0
            #pragma glsl
            
            uniform half4 _TimeEditor;
            uniform fixed _TimeMult;
            uniform fixed _Tiling;
            uniform fixed _TimeMultSecondLayer;
            uniform fixed _Density;
            uniform fixed _Alpha;
            uniform fixed _AlphaCut;
            uniform fixed _DepthColor;
            uniform sampler2D _PerlinNormalMap;
            uniform fixed4 _WindDirection;
            uniform fixed4 _CloudNormalsDirection;
			
            struct VertexInput {
                half4 vertex : POSITION;
                half4 vertexColor : COLOR;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                half4 posWorld : TEXCOORD5;
                half4 vertexColor : COLOR;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o;
                o.posWorld = mul(_Object2World, v.vertex);
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                o.vertexColor = v.vertexColor;

                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
				fixed cloudAlphaCut = 0;
				if(i.vertexColor.a > _CloudNormalsDirection.w-0.0001){
                	fixed2 baseAnimation = (_Time.g + _TimeEditor.g) * 0.001 * _WindDirection.rb;
	                fixed2 uvAnimation = baseAnimation * _TimeMult;
	                fixed2 uvAnimation2 = baseAnimation * _TimeMultSecondLayer;
	                
	                fixed2 worldUV = i.posWorld.rb / _Tiling;

	                fixed2 newUV = worldUV + uvAnimation;
	                fixed2 newUV2 = fixed2(0.0,0.5) + (worldUV + uvAnimation2);
	                
	                fixed4 cloudTexture = tex2Dlod(_PerlinNormalMap, fixed4(newUV,0,0));
	                fixed4 cloudTexture2 = tex2Dlod(_PerlinNormalMap, fixed4(newUV2,0,0));
	                
					fixed cloudMorph = ((saturate(cloudTexture.a + _Density) * i.vertexColor.a) - cloudTexture2.a) * _Alpha;
	                cloudAlphaCut = cloudMorph -_AlphaCut;
	                
                }
                clip(saturate(ceil(cloudAlphaCut)) - 0.5); 
				SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    CustomEditor "CloudInspector"
}