/// @desc Clear Memory

vertex_delete_buffer(vGridBuffer);
vertex_delete_buffer(vSunBuffer);
vertex_delete_buffer(vScreenBuffer);

surface_free(surfaceWorld);
surface_free(surfaceBloom);

part_system_destroy(partSystemStars);