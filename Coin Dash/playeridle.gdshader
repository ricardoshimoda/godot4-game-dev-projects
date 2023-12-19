shader_type canvas_item;

/*
uniform vec4 fill_color : source_color;
uniform bool active = false;*/
uniform vec4 line_color : source_color;
uniform float line_thickness : hint_range(0, 10) = 0.5; 

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 size = TEXTURE_PIXEL_SIZE *  line_thickness;
	float outline = texture(TEXTURE, UV + vec2(-size.x, 0)).a;
	outline += texture(TEXTURE, UV + vec2(0, size.y)).a;
	outline += texture(TEXTURE, UV + vec2(size.x, 0)).a;
	outline += texture(TEXTURE, UV + vec2(0, -size.y)).a;
	outline = min(outline, 1.0);
	
	vec4 color = texture(TEXTURE, UV);
	COLOR = mix(color, line_color, outline - color.a);
	/*
	if (active == true) {
		COLOR.rgb = fill_color.rgb;
	}*/
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
