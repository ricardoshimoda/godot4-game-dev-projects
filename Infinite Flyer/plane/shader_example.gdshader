shader_type spatial;

void vertex() {
	VERTEX.y += sin(TIME + 10.0 * UV.x) * 0.5;
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
}

void light() {
	// Called for every pixel for every light affecting the material.
}
