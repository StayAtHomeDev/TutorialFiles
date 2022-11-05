shader_type spatial;

uniform vec4 underwater;
uniform vec4 grass;
uniform vec4 coast;
uniform vec4 snow;

varying vec3 randomcolor;

void vertex() {
	if (INSTANCE_CUSTOM.g > 0.1 ) { // Check for water vs land
		if (INSTANCE_CUSTOM.g > 0.8 ) {
			randomcolor = vec3(1,1,1);
		}
		else {
			randomcolor = vec3(0.18,0.47,0);
		}
	}
	else {
		if (INSTANCE_CUSTOM.g < 0.0 ) {
			randomcolor = vec3(0.44,0.22,0.13);
		}
		else {
			randomcolor = vec3(1,0.72,0.45);
		}
		
	}
}

void fragment() {
	METALLIC = 0.0;
	ROUGHNESS = 0.01;
	ALBEDO = randomcolor;
}
