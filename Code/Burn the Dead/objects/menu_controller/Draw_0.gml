// drawing sets
draw_set_font(fnt_menu);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

for(var i = 0; i < array_length(menu_options); i++)
{
	var yy = menu_y_start + (i * menu_spacing);
	var current_scale = scale_current[i];
	
	var draw_color = c_white;
	if (i == menu_index)
	{
		draw_color = c_yellow;
	}
	
	draw_set_colour(draw_color);
	
	draw_text_transformed(
		menu_x,
		yy,
		menu_options[i],
		current_scale,
		current_scale,
		0
	);
}

draw_set_color(c_white);