/// @desc Create Surfaces & Manage Size

// Sizing
if (os_type == os_operagx) {
	var _width = browser_width;
	var _height = browser_height;

	if (_width != width or _height != height) {
		width = browser_width;
		height = browser_height;
		window_set_size(width,height);
	}
} else {
	width = window_get_width();
	height = window_get_height();
}

// Surfaces
if (!surface_exists(surfaceWorld)) surfaceWorld = surface_create(room_width,room_height);
if (!surface_exists(surfaceBloom)) surfaceBloom = surface_create(room_width,room_height);

