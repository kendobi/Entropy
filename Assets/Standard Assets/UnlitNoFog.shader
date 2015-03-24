// Shader created with Shader Forge v1.06 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.06;sub:START;pass:START;ps:flbk:,lico:0,lgpr:1,nrmq:1,limd:0,uamb:True,mssp:True,lmpd:False,lprd:False,rprd:False,enco:False,frtr:True,vitr:True,dbil:False,rmgx:True,rpth:0,hqsc:True,hqlp:False,tesm:0,blpr:0,bsrc:0,bdst:1,culm:0,dpts:2,wrdp:True,dith:0,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:True,fgoc:True,fgod:True,fgor:False,fgmd:2,fgcr:0.9485294,fgcg:0.9485294,fgcb:0.9485294,fgca:1,fgde:0.01,fgrn:10000,fgrf:100000,ofsf:0,ofsu:0,f2p0:False;n:type:ShaderForge.SFN_Final,id:9344,x:33136,y:32740,varname:node_9344,prsc:2|emission-2916-OUT;n:type:ShaderForge.SFN_Tex2d,id:4718,x:32530,y:32679,ptovrint:False,ptlb:Diffuse,ptin:_Diffuse,varname:_Diffuse,prsc:2,tex:b66bceaf0cc0ace4e9bdc92f14bba709,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Color,id:3836,x:32502,y:32863,ptovrint:False,ptlb:color2,ptin:_color2,varname:node_4485,prsc:2,glob:False,c1:1,c2:0.9926471,c3:0.9926471,c4:1;n:type:ShaderForge.SFN_Multiply,id:2916,x:32774,y:32843,varname:node_2916,prsc:2|A-3836-RGB,B-4718-RGB;proporder:4718-3836;pass:END;sub:END;*/

Shader "Shader Forge/UnlitNoFog" {
    Properties {
        _Diffuse ("Diffuse", 2D) = "white" {}
        _color2 ("color2", Color) = (1,0.9926471,0.9926471,1)
    }
    SubShader {
        Tags {
            "RenderType"="Opaque"
        }
        Pass {
            Name "ForwardBase"
            Tags {
                "LightMode"="ForwardBase"
            }
            
            
            Fog {Mode Exp}
            Fog { Color (0.9485294,0.9485294,0.9485294,1) }
            Fog {Density 0.01}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma exclude_renderers xbox360 ps3 flash d3d11_9x 
            #pragma target 3.0
            uniform sampler2D _Diffuse; uniform float4 _Diffuse_ST;
            uniform float4 _color2;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
/////// Vectors:
////// Lighting:
////// Emissive:
                float4 _Diffuse_var = tex2D(_Diffuse,TRANSFORM_TEX(i.uv0, _Diffuse));
                float3 emissive = (_color2.rgb*_Diffuse_var.rgb);
                float3 finalColor = emissive;
                return fixed4(finalColor,1);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
