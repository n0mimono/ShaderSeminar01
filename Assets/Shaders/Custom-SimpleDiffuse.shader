Shader "Custom/SimpleDiffuse" {
  Properties {
    _Tint ("Tint Color", Color) = (1,1,1,1)
    _MainTex ("Main Texture", 2D) = "white" {}
  }
  SubShader {
    Pass {
      Tags { "LightMode"="ForwardBase" }

      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag
      #include "UnityCG.cginc"

      float4 _Tint;
      sampler2D _MainTex;

      struct appdata {
        float4 vertex : POSITION;
        float2 texcoord : TEXCOORD0;
        float4 normal : NORMAL;
      };

      struct v2f {
        float4 pos : SV_POSITION;
        float2 uv : TEXCOORD0;
        float3 normal : TEXCOORD1;
      };

      v2f vert(appdata v) {
        v2f o;
        o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
        o.uv = v.texcoord;
        o.normal = UnityObjectToWorldNormal(v.normal);

        return o;
      }

      fixed4 frag(v2f i) : SV_Target {
        half3 normalDir = normalize(i.normal);
        half3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
        half NdotL = max(0, dot(normalDir, lightDir));
        half diffuse = NdotL * 0.5 + 0.5;

        fixed4 col = tex2D(_MainTex, i.uv);
        return col * _Tint * diffuse;
      }
      ENDCG
    }
  }
}
