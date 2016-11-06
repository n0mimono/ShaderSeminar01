Shader "Custom/SimpleColor" {
  Properties {
    _Color ("Color", Color) = (1,1,1,1)
  }
  
  SubShader {
    Pass {
      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag

      float4 _Color;

      float4 vert(float4 vertex : POSITION) : SV_POSITION {
        float4 pos = mul(UNITY_MATRIX_MVP, vertex);
        return pos;
      }

      fixed4 frag(float4 pos : SV_POSITION) : SV_Target {
        return _Color;
      }

      ENDCG
    }
  }
}
