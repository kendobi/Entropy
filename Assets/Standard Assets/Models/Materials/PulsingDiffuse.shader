// Shader created with Shader Forge v1.06 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.06;sub:START;pass:START;ps:flbk:,lico:1,lgpr:1,nrmq:1,limd:1,uamb:True,mssp:True,lmpd:False,lprd:False,rprd:False,enco:False,frtr:True,vitr:True,dbil:False,rmgx:True,rpth:1,hqsc:True,hqlp:False,tesm:0,blpr:0,bsrc:0,bdst:1,culm:2,dpts:2,wrdp:True,dith:0,ufog:False,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.325,fgcg:0.2665441,fgcb:0.4264706,fgca:1,fgde:0.1,fgrn:10000,fgrf:100000,ofsf:0,ofsu:0,f2p0:False;n:type:ShaderForge.SFN_Final,id:8198,x:32719,y:32712,varname:node_8198,prsc:2|emission-4255-OUT,voffset-9311-OUT;n:type:ShaderForge.SFN_Subtract,id:8378,x:31158,y:32510,varname:node_8378,prsc:2|A-2058-OUT,B-8689-OUT;n:type:ShaderForge.SFN_Vector1,id:8689,x:30931,y:32537,varname:node_8689,prsc:2,v1:0.5;n:type:ShaderForge.SFN_Abs,id:6262,x:31385,y:32574,varname:node_6262,prsc:2|IN-8378-OUT;n:type:ShaderForge.SFN_Frac,id:2058,x:30931,y:32369,varname:node_2058,prsc:2|IN-3202-OUT;n:type:ShaderForge.SFN_Panner,id:3751,x:30477,y:32229,varname:node_3751,prsc:2,spu:0,spv:-0.35;n:type:ShaderForge.SFN_ComponentMask,id:3202,x:30704,y:32300,varname:node_3202,prsc:2,cc1:1,cc2:-1,cc3:-1,cc4:-1|IN-3751-UVOUT;n:type:ShaderForge.SFN_Multiply,id:8936,x:31612,y:32710,cmnt:Triangle Wave,varname:node_8936,prsc:2|A-6262-OUT,B-2077-OUT;n:type:ShaderForge.SFN_Vector1,id:2077,x:31385,y:32742,varname:node_2077,prsc:2,v1:2;n:type:ShaderForge.SFN_Power,id:3842,x:31839,y:32846,cmnt:Panning gradient,varname:node_3842,prsc:2|VAL-8936-OUT,EXP-1829-OUT;n:type:ShaderForge.SFN_NormalVector,id:2704,x:32066,y:33334,prsc:2,pt:False;n:type:ShaderForge.SFN_Multiply,id:9311,x:32293,y:33164,varname:node_9311,prsc:2|A-3842-OUT,B-180-OUT,C-2704-OUT;n:type:ShaderForge.SFN_ValueProperty,id:180,x:32066,y:33166,ptovrint:False,ptlb:Bulge Scale,ptin:_BulgeScale,varname:_BulgeScale,prsc:2,glob:False,v1:0.2;n:type:ShaderForge.SFN_Tex2d,id:4649,x:31640,y:32339,ptovrint:False,ptlb:Diffuse,ptin:_Diffuse,varname:_Diffuse,prsc:2,tex:b66bceaf0cc0ace4e9bdc92f14bba709,ntxv:0,isnm:False;n:type:ShaderForge.SFN_ValueProperty,id:1829,x:31612,y:32878,ptovrint:False,ptlb:Bulge Shape,ptin:_BulgeShape,varname:_BulgeShape,prsc:2,glob:False,v1:10;n:type:ShaderForge.SFN_Color,id:6693,x:31612,y:32523,ptovrint:False,ptlb:color2,ptin:_color2,varname:node_4485,prsc:2,glob:False,c1:1,c2:0.9926471,c3:0.9926471,c4:1;n:type:ShaderForge.SFN_Multiply,id:4255,x:31884,y:32503,varname:node_4255,prsc:2|A-6693-RGB,B-4649-RGB;proporder:180-1829-4649-6693;pass:END;sub:END;*/

Shader "Shader Forge/PulsingDiffuse" {
    Properties {
        _BulgeScale ("Bulge Scale", Float ) = 0.2
        _BulgeShape ("Bulge Shape", Float ) = 10
        _Diffuse ("Diffuse", 2D) = "white" {}
        _color2 ("color2", Color) = (1,0.9926471,0.9926471,1)
    }
    SubShader {
        Tags {
            "RenderType"="Opaque"
        }
        Pass {
            Name "PrePassBase"
            Tags {
                "LightMode"="PrePassBase"
            }
            Cull Off
            
            
            Fog {Mode Off}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_PREPASSBASE
            #include "UnityCG.cginc"
            #pragma exclude_renderers xbox360 ps3 flash d3d11_9x 
            #pragma target 3.0
            uniform fixed4 unity_Ambient;
            uniform float4 _TimeEditor;
            uniform float _BulgeScale;
            uniform float _BulgeShape;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = mul(_Object2World, float4(v.normal,0)).xyz;
                float4 node_7690 = _Time + _TimeEditor;
                v.vertex.xyz += (pow((abs((frac((o.uv0+node_7690.g*float2(0,-0.35)).g)-0.5))*2.0),_BulgeShape)*_BulgeScale*v.normal);
                o.posWorld = mul(_Object2World, v.vertex);
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
/////// Vectors:
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                
                float nSign = sign( dot( viewDirection, i.normalDir ) ); // Reverse normal if this is a backface
                i.normalDir *= nSign;
                normalDirection *= nSign;
                
                return fixed4( normalDirection * 0.5 + 0.5, max(0.5,0.0078125) );
            }
            ENDCG
        }
        Pass {
            Name "PrePassFinal"
            Tags {
                "LightMode"="PrePassFinal"
            }
            Cull Off
            ZWrite Off
            
            Fog {Mode Off}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_PREPASSFINAL
            #include "UnityCG.cginc"
            #pragma multi_compile_prepassfinal
            #pragma exclude_renderers xbox360 ps3 flash d3d11_9x 
            #pragma target 3.0
            uniform sampler2D _LightBuffer;
            #if defined (SHADER_API_XBOX360) && defined (HDR_LIGHT_PREPASS_ON)
                sampler2D _LightSpecBuffer;
            #endif
            uniform fixed4 unity_Ambient;
            uniform float4 _TimeEditor;
            uniform float _BulgeScale;
            uniform sampler2D _Diffuse; uniform float4 _Diffuse_ST;
            uniform float _BulgeShape;
            uniform float4 _color2;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = mul(_Object2World, float4(v.normal,0)).xyz;
                float4 node_2500 = _Time + _TimeEditor;
                v.vertex.xyz += (pow((abs((frac((o.uv0+node_2500.g*float2(0,-0.35)).g)-0.5))*2.0),_BulgeShape)*_BulgeScale*v.normal);
                o.posWorld = mul(_Object2World, v.vertex);
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
/////// Vectors:
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                
                float nSign = sign( dot( viewDirection, i.normalDir ) ); // Reverse normal if this is a backface
                i.normalDir *= nSign;
                normalDirection *= nSign;
                
////// Lighting:
////// Emissive:
                float4 _Diffuse_var = tex2D(_Diffuse,TRANSFORM_TEX(i.uv0, _Diffuse));
                float3 emissive = (_color2.rgb*_Diffuse_var.rgb);
                float3 finalColor = emissive;
                return fixed4(finalColor,1);
            }
            ENDCG
        }
        Pass {
            Name "ForwardBase"
            Tags {
                "LightMode"="ForwardBase"
            }
            Cull Off
            
            
            Fog {Mode Off}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma exclude_renderers xbox360 ps3 flash d3d11_9x 
            #pragma target 3.0
            uniform float4 _TimeEditor;
            uniform float _BulgeScale;
            uniform sampler2D _Diffuse; uniform float4 _Diffuse_ST;
            uniform float _BulgeShape;
            uniform float4 _color2;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = mul(_Object2World, float4(v.normal,0)).xyz;
                float4 node_4818 = _Time + _TimeEditor;
                v.vertex.xyz += (pow((abs((frac((o.uv0+node_4818.g*float2(0,-0.35)).g)-0.5))*2.0),_BulgeShape)*_BulgeScale*v.normal);
                o.posWorld = mul(_Object2World, v.vertex);
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
/////// Vectors:
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                
                float nSign = sign( dot( viewDirection, i.normalDir ) ); // Reverse normal if this is a backface
                i.normalDir *= nSign;
                normalDirection *= nSign;
                
////// Lighting:
////// Emissive:
                float4 _Diffuse_var = tex2D(_Diffuse,TRANSFORM_TEX(i.uv0, _Diffuse));
                float3 emissive = (_color2.rgb*_Diffuse_var.rgb);
                float3 finalColor = emissive;
                return fixed4(finalColor,1);
            }
            ENDCG
        }
        Pass {
            Name "ShadowCollector"
            Tags {
                "LightMode"="ShadowCollector"
            }
            Cull Off
            
            Fog {Mode Off}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_SHADOWCOLLECTOR
            #define SHADOW_COLLECTOR_PASS
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcollector
            #pragma exclude_renderers xbox360 ps3 flash d3d11_9x 
            #pragma target 3.0
            uniform float4 _TimeEditor;
            uniform float _BulgeScale;
            uniform float _BulgeShape;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                V2F_SHADOW_COLLECTOR;
                float2 uv0 : TEXCOORD5;
                float3 normalDir : TEXCOORD6;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = mul(_Object2World, float4(v.normal,0)).xyz;
                float4 node_3906 = _Time + _TimeEditor;
                v.vertex.xyz += (pow((abs((frac((o.uv0+node_3906.g*float2(0,-0.35)).g)-0.5))*2.0),_BulgeShape)*_BulgeScale*v.normal);
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                TRANSFER_SHADOW_COLLECTOR(o)
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
/////// Vectors:
                SHADOW_COLLECTOR_FRAGMENT(i)
            }
            ENDCG
        }
        Pass {
            Name "ShadowCaster"
            Tags {
                "LightMode"="ShadowCaster"
            }
            Cull Off
            Offset 1, 1
            
            Fog {Mode Off}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_SHADOWCASTER
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma exclude_renderers xbox360 ps3 flash d3d11_9x 
            #pragma target 3.0
            uniform float4 _TimeEditor;
            uniform float _BulgeScale;
            uniform float _BulgeShape;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                float2 uv0 : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = mul(_Object2World, float4(v.normal,0)).xyz;
                float4 node_417 = _Time + _TimeEditor;
                v.vertex.xyz += (pow((abs((frac((o.uv0+node_417.g*float2(0,-0.35)).g)-0.5))*2.0),_BulgeShape)*_BulgeScale*v.normal);
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
/////// Vectors:
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
