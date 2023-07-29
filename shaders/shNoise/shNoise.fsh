varying vec4 v_TexCoord;
varying vec4 v_TexCoordGlitch;
varying vec4 v_TexCoordNoise;
varying vec4 v_TexCoordVHSNoise;

uniform sampler2D g_Texture; // {"material":"ui_editor_properties_noise","default":"util/noise"}

const float g_NoiseAlpha = 0.5; // {"material":"ui_editor_properties_strength","default":2,"range":[0.0, 5.0]}
const float g_NoisePower = 0.5; // {"material":"ui_editor_properties_power","default":0.5,"range":[0.0, 5.0]}
uniform float g_NoiseFX; // {"material":"noisefx","default":1.0}

#define BlendLinearDodge(base, blend) min(base + blend, vec3(1.0))
#define BlendOpacity(base, blend, F, O) mix(base, F(base, blend), O)
#define BlendSoftLightf(base, blend) ((blend < 0.5) ? (2.0 * base * blend + base * base * (1.0 - 2.0 * blend)) : (sqrt(base) * (2.0 * blend - 1.0) + 2.0 * base * (1.0 - blend)))
#define BlendSoftLight(base, blend) vec3(BlendSoftLightf(base.r, blend.r), BlendSoftLightf(base.g, blend.g), BlendSoftLightf(base.b, blend.b))

float greyscale(vec3 color) {
	return dot(color, vec3(0.11, 0.59, 0.3));
}

vec3 ApplyBlending(in vec3 A, in vec3 B, in float opacity) {
	return mix(A,BlendSoftLight(A,B),opacity);
}

void main() {
	vec4 orig = texture2D(gm_BaseTexture, v_TexCoord.xy);
	vec4 albedo;
	albedo.ga = orig.ga;
	albedo.r = texture2D(gm_BaseTexture, fract(v_TexCoordGlitch.xy)).r;
	albedo.b = texture2D(gm_BaseTexture, fract(v_TexCoordGlitch.zw)).b;
	
	vec3 noise = texture2D(g_Texture, fract(v_TexCoordNoise.xy)).rgb;
	vec3 noise2 = texture2D(g_Texture, fract(v_TexCoordNoise.zw)).gbr;
	
	noise = vec3(greyscale(noise));
	noise2 = vec3(greyscale(noise2));
	
	noise = clamp(noise * noise2, 0.0, 1.0);
	noise = pow(noise, vec3(g_NoisePower));
	
	float blend = g_NoiseAlpha;

	albedo.rgb = ApplyBlending(albedo.rgb, noise, blend * 0.4);
	albedo.rgb = BlendOpacity(albedo.rgb, smoothstep(0.7, 1.0, noise), BlendLinearDodge, blend);
	
	vec2 vhsNoise = texture2D(g_Texture, fract(v_TexCoordVHSNoise.xy)).rg;
	vec2 vhsNoise2 = texture2D(g_Texture, fract(v_TexCoordVHSNoise.zw)).rg;
	albedo.rgb += vec3(step(0.9, vhsNoise.x) * step(0.9, vhsNoise2.x) * vhsNoise.y * vhsNoise2.y);
	
	gl_FragColor = mix(orig, albedo, g_NoiseFX);
}