Shader "UI/Custom-X9"
{
  Properties
  {
    [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
    _Color ("Tint", Color) = (1,1,1,1)
    
    _StencilComp ("Stencil Comparison", Float) = 8
    _Stencil ("Stencil ID", Float) = 0
    _StencilOp ("Stencil Operation", Float) = 0
    _StencilWriteMask ("Stencil Write Mask", Float) = 255
    _StencilReadMask ("Stencil Read Mask", Float) = 255

    _ColorMask ("Color Mask", Float) = 15

    [Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0  

    _BumpTex ("Normal Tex", 2D) = "bump" {}
  }

  SubShader
  {
    Tags
    { 
      "Queue"="Transparent" 
      "IgnoreProjector"="True" 
      "RenderType"="Transparent" 
      "PreviewType"="Plane"
      "CanUseSpriteAtlas"="True"
    }
    
    Stencil
    {
      Ref [_Stencil]
      Comp [_StencilComp]
      Pass [_StencilOp] 
      ReadMask [_StencilReadMask]
      WriteMask [_StencilWriteMask]
    }

    Cull Off
    Lighting Off
    ZWrite Off
    ZTest [unity_GUIZTestMode]
    Blend SrcAlpha OneMinusSrcAlpha
    ColorMask [_ColorMask]

    Pass
    {
      Tags { "LightMode" = "ForwardBase" }
      Name "Default"
    CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag
      #pragma target 2.0

      #include "UnityCG.cginc"
      #include "UnityUI.cginc"
      #include "Lighting.cginc"

      #pragma multi_compile __ UNITY_UI_ALPHACLIP
      
      struct appdata_t
      {
        float4 vertex   : POSITION;
        float4 color    : COLOR;
        float2 texcoord : TEXCOORD0;
        float3 normal   : NORMAL;
        float4 tangent  : TANGENT;
      };

      struct v2f
      {
        float4 vertex   : SV_POSITION;
        fixed4 color    : COLOR;
        half2 texcoord  : TEXCOORD0;
        float4 worldPosition : TEXCOORD1;
        float3 normal : TEXCOORD2;
        float3 tangent : TEXCOORD3;
        float3 bitangent : TEXCOORD4;
      };
      
      fixed4 _Color;
      fixed4 _TextureSampleAdd;
      float4 _ClipRect;

      v2f vert(appdata_t IN)
      {
        v2f OUT;
        OUT.worldPosition = IN.vertex;
        OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);

        OUT.texcoord = IN.texcoord;
        
        #ifdef UNITY_HALF_TEXEL_OFFSET
        OUT.vertex.xy += (_ScreenParams.zw-1.0) * float2(-1,1) * OUT.vertex.w;
        #endif
        
        OUT.color = IN.color * _Color;

        OUT.normal = UnityObjectToWorldNormal(IN.normal);
        OUT.tangent = normalize(mul(unity_ObjectToWorld, float4(IN.tangent.xyz, 0)).xyz);
        OUT.bitangent = normalize(cross(OUT.normal, OUT.tangent) * IN.tangent.w);

        return OUT;
      }

      sampler2D _MainTex;
      sampler2D _BumpTex;

      fixed4 frag(v2f IN) : SV_Target
      {
        half4 color = (tex2D(_MainTex, IN.texcoord) + _TextureSampleAdd) * IN.color;
        color.a = 0.8 > (color.r + color.g + color.b) / 3 ? color.a : 0;
        color.rgb *= _LightColor0.rgb;

        IN.normal = normalize(IN.normal);
        float3x3 tanTrans = float3x3(IN.tangent, IN.bitangent, IN.normal);
        half3 normal = 2 * tex2D(_BumpTex, IN.texcoord) - 1;
        half3 normalDir = normalize(mul(normal, tanTrans));

        half3 lightDir = _WorldSpaceLightPos0;

        half NdotL = max(0, dot(normalDir, lightDir));
        half diffuse = 0.5 * NdotL + 0.5;
        color.rgb *= diffuse;

        color.a *= UnityGet2DClipping(IN.worldPosition.xy, _ClipRect);
        
        #ifdef UNITY_UI_ALPHACLIP
        clip (color.a - 0.001);
        #endif

        return color;
      }
    ENDCG
    }
  }
}
