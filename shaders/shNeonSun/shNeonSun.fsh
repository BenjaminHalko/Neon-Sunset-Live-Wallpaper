varying vec2 v_TexCoord;

uniform float g_Time;
uniform vec3 g_ColorSunTop; // {"material":"colorsuntop","default":"1 0.85 0.05","type":"color"}
uniform vec3 g_ColorSunBottom; // {"material":"colorsunbottom","default":"1 0 0.35","type":"color"}

void main() {
	float sunSize = 0.05;
	float sunSizeSqrt = sqrt(sunSize);
	float blendSunColor = (v_TexCoord.y + sunSize * 2.5) / sunSizeSqrt;
	vec4 colorSun = vec4(mix(g_ColorSunTop, g_ColorSunBottom, blendSunColor), 0.0);
	float sunRadius = dot(v_TexCoord.xy, v_TexCoord.xy);
	colorSun.a = 1.0 - step(0.05, sunRadius);
	float glowAlpha = pow(smoothstep(0.08, 0.045, sunRadius), 2.0);
	
	float barPos = v_TexCoord.y + 0.1;

	float sunCutOut = 1.0 - clamp(smoothstep(0.0, 0.005, barPos) * smoothstep(1.0 - barPos * 9.0, 1.0 - barPos * 8.0, sin(barPos * 200.0 + g_Time)), 0.0, 1.0);
	float sunCutOutSmooth = 1.0 - clamp(smoothstep(0.0, 0.05, barPos) * smoothstep(-1.0 - barPos * 8.0, 1.0 - barPos * 8.0, sin(barPos * 200.0 + g_Time)), 0.0, 1.0);
	
	gl_FragColor.rgb = g_ColorSunBottom;
	gl_FragColor.rgb = mix(gl_FragColor.rgb, colorSun.rgb, colorSun.a * sunCutOut);
	
	gl_FragColor.a = max(glowAlpha * sunCutOutSmooth, colorSun.a * sunCutOut);
}