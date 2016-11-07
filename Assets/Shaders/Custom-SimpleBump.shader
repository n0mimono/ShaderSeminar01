Shader "Custom/SimpleBump" {
  Properties {
    _Tint ("Tint Color", Color) = (1,1,1,1)
    _MainTex ("Main Texture", 2D) = "white" {}
    _BumpTex ("Bump Texture", 2D) = "bump" {}
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
      sampler2D _BumpTex;

      struct appdata {
        float4 vertex : POSITION;
        float2 texcoord : TEXCOORD0;
        float4 normal : NORMAL;
        float4 tangent : TANGENT;
      };

      struct v2f {
        float4 pos : SV_POSITION;
        float2 uv : TEXCOORD0;
        float3 normal : TEXCOORD1;
        float3 tangent : TEXCOORD2;
        float3 bitangent : TEXCOORD3;
     };

      v2f vert(appdata v) {
        v2f o;
        o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
        o.uv = v.texcoord;

        o.normal = UnityObjectToWorldNormal(v.normal);
        o.tangent = normalize(mul(unity_ObjectToWorld, float4(v.tangent.xyz, 0)).xyz);
        o.bitangent = normalize(cross(o.normal, o.tangent) * v.tangent.w);

        return o;
      }

      fixed4 frag(v2f i) : SV_Target {
        i.normal = normalize(i.normal);
        float3x3 rotation = float3x3(i.tangent, i.bitangent, i.normal);
        float3 normalLocal = UnpackNormal(tex2D(_BumpTex, i.uv));
        float3 normalDir = normalize(mul(normalLocal, rotation));

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
