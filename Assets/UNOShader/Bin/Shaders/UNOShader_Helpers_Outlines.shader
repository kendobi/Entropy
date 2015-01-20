//Version=1
Shader"UNOShader/Helpers/Outlines"
{
	Properties
	{
		_OutlineTex ("Outline Texture", 2D) = "white" {}
		_Outline ("Outline Width", Range (0, .05)) = .01
		_OutlineX ("Outline X", Range (0, .05)) = .01
		_OutlineY ("Outline Y", Range (0, .05)) = .01
		_OutlineColor ("Outline Color", Color) = (1,1,1,1)
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
		//	"LightMode" = "ForwardBase"
		}
		Pass// Pass drawing outline
		{
            Name "BASIC"
            Tags
			{
			//--- "RenderType" sets the group that it belongs to type and uses: Opaque, Transparent,
			//--- TransparentCutout, Background, Overlay(Gui,halo,Flare shaders), TreeOpaque, TreeTransparentCutout, TreeBilboard,Grass, GrassBilboard.
			//--- "Queue" sets order and uses: Background (for skyboxes), Geometry(default), AlphaTest(?, water),
			//--- Transparent(draws after AlphaTest, back to front order), Overlay(effects,ie lens flares)
			//--- adding +number to tags "Geometry +1" will affect draw order. B=1000 G=2000 AT= 2450 T=3000 O=4000
			//"RenderType" = "Opaque"
			//"Queue" = "Transparent"
			//"LightMode" = "ForwardBase"
			}
            
            Cull Front
           	//Blend SrcAlpha OneMinusSrcAlpha -- transparency enable
           	
           
            CGPROGRAM
            #include "UnityCG.cginc"
            #pragma vertex vert
            #pragma fragment frag
 			
			fixed _Outline;
 			fixed4 _OutlineColor;
           	struct customData
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;

			};
            struct v2f
            {
                float4 pos : POSITION;
                float4 color : COLOR;
            };
           
            v2f vert(customData v)
            {
                v2f o;
                o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
                float3 norm   = mul ((float3x3)UNITY_MATRIX_IT_MV, v.normal);
                float2 offset = TransformViewToProjection(norm.xy);
                o.pos.xy += offset  * o.pos.z * _Outline ;
                //offset *  * _Outline
                o.color = _OutlineColor;
                return o;
            }
           
            half4 frag(v2f i) :COLOR
            {
                return i.color;
            }
                   
            ENDCG
        }// ------------------- Pass ---------------------------------------
        Pass// Pass drawing outline
		{
            Name "ADVANCED"
            Tags
			{
			//--- "RenderType" sets the group that it belongs to type and uses: Opaque, Transparent,
			//--- TransparentCutout, Background, Overlay(Gui,halo,Flare shaders), TreeOpaque, TreeTransparentCutout, TreeBilboard,Grass, GrassBilboard.
			//--- "Queue" sets order and uses: Background (for skyboxes), Geometry(default), AlphaTest(?, water),
			//--- Transparent(draws after AlphaTest, back to front order), Overlay(effects,ie lens flares)
			//--- adding +number to tags "Geometry +1" will affect draw order. B=1000 G=2000 AT= 2450 T=3000 O=4000
			//"RenderType" = "Opaque"
			//"Queue" = "Transparent"
			//"LightMode" = "ForwardBase"
			}
            
            Cull Front
           	//Blend SrcAlpha OneMinusSrcAlpha -- transparency enable
           	//Offset 10,0
           
            CGPROGRAM
            #include "UnityCG.cginc"
            #pragma vertex vert
            #pragma fragment frag
 			
 			sampler2D _OutlineTex;
			float4 _OutlineTex_ST;
			fixed _OutlineX;
			fixed _OutlineY;
 			fixed4 _OutlineColor;
           	struct customData
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float2 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
			};
            struct v2f
            {
                float4 pos : POSITION;
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
            };
           
            v2f vert(customData v)
            {
                v2f o;
                o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
                o.uv =		TRANSFORM_TEX (v.texcoord, _OutlineTex); // this allows you to offset uvs and such
                float3 norm   = mul ((float3x3)UNITY_MATRIX_IT_MV, v.normal);
                float2 offset = TransformViewToProjection(norm.xy);
                //o.pos.xy += offset  * o.pos.z * _Outline ;
                o.pos.x += offset.x  * o.pos.z * _OutlineX;
                o.pos.y += offset.y  * o.pos.z * _OutlineY;
                
                o.color = _OutlineColor;
                return o;
            }
           
            half4 frag(v2f i) :COLOR
            {
                fixed4 T_Outline = tex2D(_OutlineTex, i.uv);
                return i.color * T_Outline;
            }
                   
            ENDCG
        }// ------------------- Pass ---------------------------------------
	} //-------------------------------SubShader-------------------------------
	//Fallback "VertexLit" // for shadows
}