/// @desc Draw Scene

#region Set Surface
surface_set_target(surfaceWorld);
draw_clear_alpha(c_black,0);
#endregion

#region Clouds
shader_set(shCloudsBG);
shader_set_uniform_f(uClouds_Time, current_time / 1000);
shader_set_uniform_f_array(uClouds_ColClouds, colClouds);
shader_set_uniform_f_array(uClouds_ColHorizon, colHorizon);
shader_set_uniform_f(uClouds_TextureSize, width, height);
texture_set_stage(uClouds_Texture, cloudTexture);
vertex_submit(vScreenBuffer,pr_trianglelist,-1);
shader_reset();
#endregion

#region Apply Camera
var _cam = camera_get_active();
camera_set_view_mat(_cam,matrix_build_lookat(0,0,0,0,0,-0.1,0,-1,0));
camera_set_proj_mat(_cam,matrix_build_projection_perspective_fov(50,width / height,0.1,10000));
camera_apply(_cam);
#endregion

#region Stars
shader_set(shStars);
part_system_drawit(partSystemStars);
shader_reset();
#endregion

#region Draw Sun
shader_set(shNeonSun);
shader_set_uniform_f(uSun_Time, current_time / 1000);
shader_set_uniform_f_array(uSun_ColTop, colSunTop);
shader_set_uniform_f_array(uSun_ColBottom, colSunBottom);
vertex_submit(vSunBuffer,pr_trianglelist,-1);
shader_reset();
#endregion

#region Grid
shader_set(shNeonGrid);
shader_set_uniform_f(uGrid_Time, current_time / 1000);
shader_set_uniform_f(uGrid_MountainScale, mountainScale);
shader_set_uniform_f_array(uGrid_ColNear, colGridNear);
shader_set_uniform_f_array(uGrid_ColFar, colGridFar);
shader_set_uniform_f_array(uGrid_ColBack, colGridBack);
shader_set_uniform_f(uGrid_ShadingAmount, shading);
vertex_submit(vGridBuffer,pr_trianglelist,-1);
shader_reset();
#endregion

#region Reset Surface
surface_reset_target();
#endregion

#region Bloom
surface_set_target(surfaceBloom);
draw_clear_alpha(c_black,0);
shader_set(shBloom);
shader_set_uniform_f(uBloom_TexelSize, 1 / room_width, 1 / room_height);
draw_surface(surfaceWorld,0,0);
shader_reset();
surface_reset_target();
#endregion

#region Noise
shader_set(shNoise);
shader_set_uniform_f(uNoise_Time, current_time / 1000);
shader_set_uniform_f(uNoise_NoiseFX, noiseFX);
shader_set_uniform_f(uNoise_TextureSize, width, height);
texture_set_stage(uNoise_Texture, noiseTexture);
draw_surface_ext(surfaceBloom,0,room_height,1,-1,0,c_white,1);
shader_reset();
#endregion