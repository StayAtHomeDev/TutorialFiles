shader_type spatial;

uniform vec3 color;

varying vec3 randomcolor;

void vertex() {
//	randomcolor = vec3(INSTANCE_CUSTOM.x,INSTANCE_CUSTOM.y,INSTANCE_CUSTOM.z); // Random Color
	if (INSTANCE_CUSTOM.x > 0.0) {
		randomcolor = vec3(.01,.45,.16);
	}
	else {
		randomcolor = vec3(.05,.66,.78);
	}
}

void fragment() {
	METALLIC = 0.0;
	ROUGHNESS = 0.01;
	ALBEDO = randomcolor;
}
