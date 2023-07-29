attribute vec3 in_Position;
attribute vec2 in_TexCoord;

varying vec2 v_TexCoord;
varying vec4 v_TexCoordClouds;

uniform float g_Time;
uniform vec2 g_TextureResolution;

const vec2 g_CloudSpeeds = vec2(0.0007,-0.0011);
const vec4 g_CloudScales = vec4(1.1,1.1,0.7,0.7);

void main() {
	vec4 object_space_pos = vec4( in_Position.x, in_Position.y, in_Position.z, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
	
	v_TexCoord.xy = in_TexCoord;
	
	float aspect = g_TextureResolution.x / g_TextureResolution.y;
	v_TexCoordClouds.xy = (in_TexCoord + g_Time * g_CloudSpeeds.x) * g_CloudScales.xy;
	v_TexCoordClouds.zw = (in_TexCoord + g_Time * g_CloudSpeeds.y) * g_CloudScales.zw;
	v_TexCoordClouds.xz *= aspect;
	v_TexCoordClouds.zw = vec2(-v_TexCoordClouds.x, v_TexCoordClouds.y);
}
