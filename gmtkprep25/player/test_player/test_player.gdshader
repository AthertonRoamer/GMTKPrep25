shader_type canvas_item;
uniform vec3 color = vec3(0.0, 0.0, 0.0);
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR = vec4(color, 1.0);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
