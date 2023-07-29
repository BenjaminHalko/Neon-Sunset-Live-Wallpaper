attribute vec3 in_Position;
attribute vec2 in_TextureCoord;

varying vec4 v_TexCoord;
varying vec4 v_TexCoordGlitch;
varying vec4 v_TexCoordNoise;
varying vec4 v_TexCoordVHSNoise;

uniform vec2 g_TextureResolution;
uniform float g_Time;

const float g_NoiseScale = 4.8; // {"material":"ui_editor_properties_scale","default":10,"range":[0.0, 20.0]}

void main() {
	vec4 object_space_pos = vec4( in_Position.x, in_Position.y, in_Position.z, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
	
	float aspect = g_TextureResolution.x / g_TextureResolution.y;
	
	float t = fract(g_Time);
	v_TexCoord = in_TextureCoord.xyxy;
	v_TexCoordNoise.xy = (in_TextureCoord.xy + t) * g_NoiseScale;
	v_TexCoordNoise.zw = (in_TextureCoord.xy - t * 2.5) * g_NoiseScale * 0.52;
	v_TexCoordNoise *= vec4(aspect, 1.0, aspect, 1.0);

	v_TexCoordVHSNoise.xy = v_TexCoordNoise.xy * vec2(0.01, 1.0);
	v_TexCoordVHSNoise.zw = v_TexCoordNoise.zw * vec2(0.001, 0.2);
	
	v_TexCoordNoise.xz *= 0.5;
	
	v_TexCoordGlitch = in_TextureCoord.xyxy;
	
	vec3 glitchOffset = smoothstep(-0.5, 0.5, sin(g_Time * vec3(7.0, 13.0, 5.0) * 3.0)) * vec3(0.0003, 0.0003, 0.0002);
	v_TexCoordGlitch.xz += glitchOffset.xy + vec2(0.0005, -0.0005);
	//v_TexCoord.x += glitchOffset.z;
}
