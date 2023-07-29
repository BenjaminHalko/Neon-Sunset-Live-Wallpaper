attribute vec3 in_Position;
attribute vec2 in_TextureCoord;

uniform vec2 g_TexelSize;

varying vec2 v_TexCoord[5];

void main() {
	vec4 object_space_pos = vec4( in_Position.x, in_Position.y, in_Position.z, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
	
	v_TexCoord[0] = in_TextureCoord - g_TexelSize;
	v_TexCoord[1] = in_TextureCoord + g_TexelSize;
	v_TexCoord[2] = in_TextureCoord + vec2(-g_TexelSize.x, g_TexelSize.y);
	v_TexCoord[3] = in_TextureCoord + vec2(g_TexelSize.x, -g_TexelSize.y);
	v_TexCoord[4] = in_TextureCoord;
}
