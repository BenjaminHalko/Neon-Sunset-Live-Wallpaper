function ColorToArray(_col) {
	return [color_get_red(_col)	/ 255, color_get_green(_col) / 255, color_get_blue(_col) / 255];
}

function VertexAddPoint(_buffer,_x,_y,_z,_u,_v) {
	vertex_position_3d(_buffer, _x, _y, _z);
	vertex_texcoord(_buffer, _u, _v);
}