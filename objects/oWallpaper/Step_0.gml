/// @desc Create Surfaces & Manage Size

// Sizing
width = browser_width;
height = browser_height;

window_set_size(width,height);

// Surfaces
if (!surface_exists(surfaceWorld)) surfaceWorld = surface_create(room_width,room_height);
if (!surface_exists(surfaceBloom)) surfaceBloom = surface_create(room_width,room_height);

