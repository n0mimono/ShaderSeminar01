Shader "Custom/TextureMasking" {
  Properties {
    _MainTex ("Main Texture", 2D) = "white" {}
    _MaskTex ("Mask Texture", 2D) = "white" {}
    _Threshold ("Mask Threshold", Range(0,1)) = 0.5
  }
  SubShader {
    Pass {
      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag

      sampler2D _MainTex;
      sampler2D _MaskTex;
      float _Threshold;

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
        float4 col = tex2D(_MainTex, i.uv);
        float4 mask = tex2D(_MaskTex, i.uv);

        col = mask.r > _Threshold ? col : col * 0.2;
        return col;
      }
      ENDCG
    }
  }
}
