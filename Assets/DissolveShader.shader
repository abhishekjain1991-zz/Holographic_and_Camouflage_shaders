Shader "MyDissolveShader"
{
	Properties
	{
		_MainTex("Main Texture", 2D) = "white"{}
		_DissolveMap("Dissolve Shape", 2D) = "white"{}
		
		_DissolveVal("Dissolve Value", Range(-0.2, 1.2)) = 1.2
		_LineWidth("Line Width", Range(0.0, 0.2)) = 0.1
		_RampTex ("Toon Ramp (RGB)", 2D) = "white" {}
		_LineColor("Line Color", Color) = (1.0, 1.0, 1.0, 1.0)

          _InnerColor ("Inner Color", Color) = (0.0, 0.0, 0.0, 1.0)
          _RimColor ("Rim Color", Color) = (0.26,0.19,0.16,0.0)
          _RimPower ("Rim Power", Range(0.5,8.0)) = 3.0

	}
	SubShader
	{
		Tags{  "Queue" = "Transparent"}
		Blend SrcAlpha OneMinusSrcAlpha
		//Cull Back
        //Blend One One
		CGPROGRAM
		
		#pragma surface surf ABJ 
	    #pragma target 3.0
		sampler2D _MainTex;
		sampler2D _DissolveMap;
		sampler2D _RampTex;
		float4 _LineColor;
		float _DissolveVal;
		float _LineWidth;
		float4 _InnerColor;
        float4 _RimColor;
        float _RimPower;
		
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
     			half2 uv_MainTex;
     			half2 uv_DissolveMap;
     			float3 viewDir;
     			
    		} ;

		void surf (Input IN, inout SurfaceOutput o) 
		{
			
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;

			half4 dissolve = tex2D(_DissolveMap, IN.uv_DissolveMap);

			half4 clear = half4(0.0);

		int isClear = int(dissolve.r - (_DissolveVal + _LineWidth) + 0.99);
		int isAtLeastLine = int(dissolve.r - (_DissolveVal) + 0.99);

			half4 altCol = lerp(_LineColor, clear, isClear);

			o.Albedo = lerp(o.Albedo, altCol, isAtLeastLine)+_InnerColor.rgb;
			
			o.Alpha = lerp(1.0, 0.0, isClear);

            half rim = 1.0 - saturate(dot (normalize(IN.viewDir), o.Normal));
            o.Emission = _RimColor.rgb * pow (rim, _RimPower);
			
		}
		ENDCG
	}
}
