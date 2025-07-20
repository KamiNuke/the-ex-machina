shader_type spatial;
render_mode cull_disabled;
uniform sampler2D m_texture;
uniform float speed = 1.0;

void vertex() {
	// Called for every vertex the material is visible on.
	    // Get rotation angle based on time
    float angle = TIME * speed;

    // Create rotation matrix for X-axis rotation
	mat3 rotation_matrix;
    rotation_matrix[0] = vec3(cos(angle), 0.0, sin(angle));  // First row
    rotation_matrix[1] = vec3(0.0, 1.0, 0.0);                // Second row
    rotation_matrix[2] = vec3(-sin(angle), 0.0, cos(angle)); // Third row

    // Apply the rotation to the vertex position
    VERTEX = rotation_matrix * VERTEX;
	
	
}

void fragment() {
	// Called for every pixel the material is visible on.
	
	ALBEDO = texture(m_texture, UV).rgb;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
