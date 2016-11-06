Shader "Custom/SimpleTexture" {
  Properties {
    _Tint ("Tint Color", Color) = (1,1,1,1)
    _MainTex ("Main Texture", 2D) = "white" {}
  }
  SubShader {
    Pass {
      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag

      float4 _Tint;
      sampler2D _MainTex;

      struct appdata {
        float4 vertex : POSITION;
        float2 texcoord : TEXCOORD0;
      };

      struct v2f {
        float4 pos : SV_POSITION;
        float2 uv : TEXCOORD0;
      };

      v2f vert(appdata v) {
        v2f o;
        o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
        o.uv = v.texcoord;
        return o;
      }

      fixed4 frag(v2f i) : SV_Target {
        fixed4 col = tex2D(_MainTex, i.uv);
        return col * _Tint;
      }
      ENDCG
    }
  }
}
