Shader "Custom/First-Calc" {
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
        float4 v0 = float4(1,2,3,4);
        half4 v1 = half4(-3,4,2,1);

        v1 = v0 * 2 - 1;
        v0.xy = v1.yx;
        v0.xy *= 2;
        v1.zw = v0.zz / 2;

        half c = dot(v0, v1);
        half l = length(v1);
        return saturate(v0 / c - sin(v1 * l));
      }

      ENDCG
    }
  }
}
