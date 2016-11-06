Shader "Custom/First" {
  SubShader {
    Pass {
      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag

      float4 vert(float4 vertex : POSITION) : SV_POSITION {
        float4 pos = mul(UNITY_MATRIX_MVP, vertex);
        return pos;
      }

      fixed4 frag(float4 pos : SV_POSITION) : SV_Target {
        fixed4 col = float4(1,0,0,1);
        return col;
      }      

      ENDCG
    }
  }
}
