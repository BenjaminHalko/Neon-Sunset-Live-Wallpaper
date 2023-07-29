/// @desc Create Surfaces & Manage Size

// Sizing
width = window_get_width();
height = window_get_height();

// Surfaces
if (!surface_exists(surfaceWorld)) surfaceWorld = surface_create(room_width,room_height);
if (!surface_exists(surfaceBloom)) surfaceBloom = surface_create(room_width,room_height);

