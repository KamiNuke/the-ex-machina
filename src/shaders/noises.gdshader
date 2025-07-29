shader_type canvas_item;
render_mode blend_mix;

uniform bool VerticalLines = false;
uniform float Speed = 0.1;
uniform float TextureStretchValue = 5;
uniform sampler2D NoiseTexture : repeat_enable;

//The shader was originally created using VisualShader
void vertex() {
// BooleanParameter:10
	bool n_out10p0 = VerticalLines;


// FloatParameter:8
	float n_out8p0 = Speed;


	vec2 n_out12p0;
// Expression:12
	n_out12p0 = vec2(0.0, 0.0);
	{
		UV.x -= TIME * n_out8p0;
		n_out12p0 = UV;
	}


	vec2 n_out7p0;
// Expression:7
	n_out7p0 = vec2(0.0, 0.0);
	{
		UV.y -= TIME * n_out8p0;
		n_out7p0 = UV;
	}


	vec2 n_out13p0;
// Switch:13
	n_out13p0 = mix(n_out7p0, n_out12p0, float(n_out10p0));


// Output:0
	UV = n_out13p0;


}

void fragment() {
// ParameterRef:9
	bool n_out9p0 = VerticalLines;


// Input:11
	vec2 n_out11p0 = UV;


// VectorDecompose:13
	float n_out13p0 = n_out11p0.x;
	float n_out13p1 = n_out11p0.y;


// FloatParameter:18
	float n_out18p0 = TextureStretchValue;


// Reroute:19
	float n_out19p0 = n_out18p0;


// FloatOp:12
	float n_out12p0 = n_out13p0 * n_out19p0;


// VectorCompose:14
	float n_in14p1 = 5.00000;
	vec2 n_out14p0 = vec2(n_out12p0, n_in14p1);


// VectorDecompose:7
	float n_out7p0 = n_out11p0.x;
	float n_out7p1 = n_out11p0.y;


// FloatOp:5
	float n_out5p0 = n_out7p1 * n_out19p0;


// VectorCompose:6
	float n_in6p0 = 5.00000;
	vec2 n_out6p0 = vec2(n_in6p0, n_out5p0);


	vec2 n_out15p0;
// Switch:15
	n_out15p0 = mix(n_out6p0, n_out14p0, float(n_out9p0));


	vec4 n_out3p0;
// Texture2D:3
	n_out3p0 = texture(NoiseTexture, n_out15p0);


// Output:0
	COLOR.a = n_out3p0.x;
}