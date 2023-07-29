varying vec2 v_TexCoord;

uniform sampler2D g_Texture; // {"material":"ui_editor_properties_albedo","default":"clouds_512"}

uniform vec3 g_ColorClouds; // {"material":"clouds","default":"0.05 0.15 0.4","type":"color"}
uniform vec3 g_ColorHorizon; // {"material":"horizon","default":"0.05 0.15 0.4","type":"color"}

uniform float g_Time;

varying vec4 v_TexCoordClouds;

const float M_PI = 3.14159265359;

void main() {
	vec3 albedo = vec3(0, 0, 0);
	
	float cloud0 = texture2D(g_Texture, fract(v_TexCoordClouds.xy)).r;
	float cloud1 = texture2D(g_Texture, fract(v_TexCoordClouds.zw)).r;
	
	float cloudBlend = cloud0 * cloud1;

	albedo = g_ColorClouds * cloudBlend;
	
	albedo += (g_ColorClouds * 0.5 + albedo) * pow(smoothstep(0.5, 0.0, v_TexCoord.y), 2.0) * 2.0;
	
	float horizonBend = 1.0 - cos(clamp(v_TexCoord.x * 2.0 - 0.5, 0.0, 1.0) * 2.0 * M_PI);
	vec2 horizonDelta = (v_TexCoord.xy - vec2(0.5, 0.6)) * vec2(0.5, 1.5 - horizonBend * 0.3);
	float distanceToCenter = length(horizonDelta);
	albedo += g_ColorHorizon * pow(smoothstep(0.5, 0.0, distanceToCenter), 2.0) * 2.0;
	
	gl_FragColor.a = 1.0;
	gl_FragColor.rgb = vec3(albedo);
}
