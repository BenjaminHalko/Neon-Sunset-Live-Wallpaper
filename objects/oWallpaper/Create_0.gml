/// @desc Setup Scene

#region Uniforms
uBloom_TexelSize = shader_get_uniform(shBloom,"g_TexelSize");

uNoise_Time = shader_get_uniform(shNoise,"g_Time");
uNoise_NoiseFX = shader_get_uniform(shNoise,"g_NoiseFX");
uNoise_TextureSize = shader_get_uniform(shNoise,"g_TextureResolution");
uNoise_Texture = shader_get_sampler_index(shNoise,"g_Texture");

uClouds_Time = shader_get_uniform(shCloudsBG,"g_Time");
uClouds_ColClouds = shader_get_uniform(shCloudsBG,"g_ColorClouds");
uClouds_ColHorizon = shader_get_uniform(shCloudsBG,"g_ColorHorizon");
uClouds_TextureSize = shader_get_uniform(shCloudsBG,"g_TextureResolution");
uClouds_Texture = shader_get_sampler_index(shCloudsBG,"g_Texture");

uSun_Time = shader_get_uniform(shNeonSun,"g_Time");
uSun_ColTop = shader_get_uniform(shNeonSun,"g_ColorSunTop");
uSun_ColBottom = shader_get_uniform(shNeonSun,"g_ColorSunBottom");

uGrid_Time = shader_get_uniform(shNeonGrid,"g_Time");
uGrid_MountainScale = shader_get_uniform(shNeonGrid,"g_MountainScale");
uGrid_ColNear = shader_get_uniform(shNeonGrid,"g_ColorGridNear");
uGrid_ColFar = shader_get_uniform(shNeonGrid,"g_ColorGridFar");
uGrid_ColBack = shader_get_uniform(shNeonGrid,"g_ColorGridBackground");
uGrid_ShadingAmount = shader_get_uniform(shNeonGrid,"g_ShadingAmount");
#endregion

#region Get Textures
noiseTexture = sprite_get_texture(sNoise, 0);
cloudTexture = sprite_get_texture(sCloudsBG, 0);
#endregion

#region Vertex Format
vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_texcoord();
vFormat = vertex_format_end();
#endregion

#region Screen
vScreenBuffer = vertex_create_buffer();
vertex_begin(vScreenBuffer, vFormat);
VertexAddPoint(vScreenBuffer,0,0,0,0,0);
VertexAddPoint(vScreenBuffer,room_width,0,0,1,0);
VertexAddPoint(vScreenBuffer,0,room_height,0,0,1);

VertexAddPoint(vScreenBuffer,room_width,0,0,1,0);
VertexAddPoint(vScreenBuffer,0,room_height,0,0,1);
VertexAddPoint(vScreenBuffer,room_width,room_height,0,1,1);
vertex_end(vScreenBuffer);
#endregion

#region Grid
var _gridSizeX = 0.04 * 1.176;
var _gridSizeY = 0.04;
var _num = 50;
var _widthHalf = _gridSizeX*_num/2;
var _heightHalf = _gridSizeY*_num/2;
var _gridOffsetY = -0.132;
var _gridOffsetZ = _heightHalf - 1.275;

vGridBuffer = vertex_create_buffer();
vertex_begin(vGridBuffer,vFormat);
for(var j = _num-1; j >= 0; j--) {
	for(var i = _num-1; i >= 0; i--) {
		VertexAddPoint(vGridBuffer,i*_gridSizeX-_widthHalf,_gridOffsetY,-j*_gridSizeY+_gridOffsetZ,i/_num,j/_num);
		VertexAddPoint(vGridBuffer,(i+1)*_gridSizeX-_widthHalf,_gridOffsetY,-j*_gridSizeY+_gridOffsetZ,(i+1)/_num,j/_num);
		VertexAddPoint(vGridBuffer,i*_gridSizeX-_widthHalf,_gridOffsetY,-(j+1)*_gridSizeY+_gridOffsetZ,i/_num,(j+1)/_num);
		
		VertexAddPoint(vGridBuffer,(i+1)*_gridSizeX-_widthHalf,_gridOffsetY,-j*_gridSizeY+_gridOffsetZ,(i+1)/_num,j/_num);
		VertexAddPoint(vGridBuffer,i*_gridSizeX-_widthHalf,_gridOffsetY,-(j+1)*_gridSizeY+_gridOffsetZ,i/_num,(j+1)/_num);	
		VertexAddPoint(vGridBuffer,(i+1)*_gridSizeX-_widthHalf,_gridOffsetY,-(j+1)*_gridSizeY+_gridOffsetZ,(i+1)/_num,(j+1)/_num);
	}
}
vertex_end(vGridBuffer);
#endregion

#region Sun
var _sunSize = 0.378;
var _sunZ = -0.711;
var _sunY = 0.08-_sunSize/2;
vSunBuffer = vertex_create_buffer();
vertex_begin(vSunBuffer,vFormat);
VertexAddPoint(vSunBuffer,-_sunSize/2,_sunSize+_sunY,_sunZ,0,0);
VertexAddPoint(vSunBuffer,+_sunSize/2,_sunSize+_sunY,_sunZ,1,0);
VertexAddPoint(vSunBuffer,-_sunSize/2,_sunY,_sunZ,0,1);

VertexAddPoint(vSunBuffer,+_sunSize/2,_sunSize+_sunY,_sunZ,1,0);
VertexAddPoint(vSunBuffer,+_sunSize/2,_sunY,_sunZ,1,1);
VertexAddPoint(vSunBuffer,-_sunSize/2,_sunY,_sunZ,0,1);
vertex_end(vSunBuffer);
#endregion

#region Stars
partSystemStars = part_system_create(psStars);
part_system_automatic_draw(partSystemStars,false);
#endregion

#region Colors
colSunTop = ColorToArray(colSunTop);
colSunBottom = ColorToArray(colSunBottom);
colHorizon = ColorToArray(colHorizon);
colClouds = ColorToArray(colClouds);
colGridNear = ColorToArray(colGridNear);
colGridFar = ColorToArray(colGridFar);
colGridBack = ColorToArray(colGridBack);
#endregion

#region Sizing
width = window_get_width();
height = window_get_height();
#endregion

#region Surfaces
surfaceWorld = surface_create(room_width,room_height);
surfaceBloom = surface_create(room_width,room_height);
#endregion