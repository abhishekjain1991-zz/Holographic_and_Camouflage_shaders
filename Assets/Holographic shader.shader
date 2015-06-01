
Shader "Holographic" 
{
    Properties 
    {
      _InnerColor ("Inner Color", Color) = (1.0, 1.0, 1.0, 1.0)
      _RimColor ("Rim Color", Color) = (0.26,0.19,0.16,0.0)
      _RimPower ("Rim Power", Range(0.5,8.0)) = 3.0
      _RampTex ("Toon Ramp (RGB)", 2D) = "white" {}
    }
    SubShader 
    {
      Tags { "Queue" = "Transparent" }
 
      Cull Back
      Blend One One
 
      CGPROGRAM
     
      #pragma surface surf ABJ 
      #pragma target 3.0
      sampler2D _RampTex;
      inline fixed4 LightingABJ (SurfaceOutput s, fixed3 lightDir, fixed3 viewDir, fixed atten)
			{
				fixed3 h = normalize (lightDir + viewDir);
				
				fixed NdotL = dot(s.Normal, lightDir) * 0.5 + 0.5;
				fixed3 ramp = tex2D(_RampTex, float2(NdotL * atten)).rgb;
				
				float nh = max (0, dot (s.Normal, h));
				float spec = pow (nh, s.Gloss * 128) * s.Specular;
				
				fixed4 c;
				c.rgb = ((s.Albedo * ramp * _LightColor0.rgb + _LightColor0.rgb * spec) * (NdotL*atten * 2));
				c.a = s.Alpha;
				return c;
			}
      struct Input 
      {
          float3 viewDir;
      };
 
      float4 _InnerColor;
      float4 _RimColor;
      float _RimPower;
 
      void surf (Input IN, inout SurfaceOutput o) 
      {
          o.Albedo = _InnerColor.rgb;
          half rim = 1.0 - saturate(dot (normalize(IN.viewDir), o.Normal));
          o.Emission = _RimColor.rgb * pow (rim, _RimPower);
      }
      ENDCG
    } 
    Fallback "Diffuse"
  }