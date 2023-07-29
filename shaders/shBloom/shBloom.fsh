varying vec2 v_TexCoord[5];

const float g_BloomStrength = 0.5; // {"material":"bloomstrength","default":2,"range":[0,4]}
const float g_BloomThreshold = 0.36; // {"material":"bloomthreshold","default":0.65,"range":[0,0.999]}

void main() {
	vec4 baseCol = texture2D(gm_BaseTexture, v_TexCoord[4]);
	vec3 albedo = texture2D(gm_BaseTexture, v_TexCoord[0]).rgb +
					texture2D(gm_BaseTexture, v_TexCoord[1]).rgb +
					texture2D(gm_BaseTexture, v_TexCoord[2]).rgb +
					texture2D(gm_BaseTexture, v_TexCoord[3]).rgb;
	albedo *= 0.25;

	float scale = max(max(albedo.x, albedo.y), albedo.z);
	albedo *= clamp(scale - g_BloomThreshold, 0.0, 1.0);
	
	// http://stackoverflow.com/a/34183839
	float grayscale = dot(vec3(0.2989, 0.5870, 0.1140), albedo);
	float sat = 1.0;
	albedo = -grayscale * sat + albedo * (1.0 + sat);
	
	gl_FragColor = baseCol + vec4(max(vec3(0.0), albedo * g_BloomStrength), 1.0);
}
