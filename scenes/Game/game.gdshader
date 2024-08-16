shader_type canvas_item;
uniform float value = 0.0;
uniform float brig : hint_range(0.0, 1.0);
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
void fragment() { 
	COLOR = textureLod(screen_texture, SCREEN_UV, value);
	COLOR.rgb *= brig;
}