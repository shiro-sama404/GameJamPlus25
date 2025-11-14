if (global.game_state == GAMING_STATE)
{

	// Mapping keyboard inputs
	var key_up = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
	var key_down = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));
	var key_confirm = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);
	
	// Mapping gamepad inputs
	var gp_up = gamepad_button_check_pressed(0, gp_padu) || gamepad_axis_value(0, gp_axislv) < -0.5;
	var gp_down = gamepad_button_check_pressed(0, gp_padd) || gamepad_axis_value(0, gp_axislv) > 0.5;
	var gp_confirm = gamepad_button_check_pressed(0, gp_face1); // A/Cross
	
	// Combine inputs
	key_up = key_up || gp_up;
	key_down = key_down || gp_down;
	key_confirm = key_confirm || gp_confirm;

	// 
	if (key_down)
	{
		menu_index++;
		if (menu_index >= array_length(menu_options))
		{
			menu_index = 0;	
		}
	}

	//
	if (key_up)
	{
		menu_index--;
		if (menu_index < 0)
		{
			menu_index = array_length(menu_options) - 1;
		}	
	}

	// Mouse interaction

	// "conecting" mouse with gui
	var _mouse_gui_x = device_mouse_x_to_gui(0);
	var _mouse_gui_y = device_mouse_y_to_gui(0);

	// 
	var _menu_center_x = display_get_gui_width() / 2;
	var _menu_y_start = (display_get_gui_height() / 2) - 60;

	var _mouse_selection = -1;

	// verify if mouse is under some option and redefines menu_index
	for (var i = 0; i < array_length(menu_options); i++)
	{
		// starting by GUI reference
		var yy = _menu_y_start + (i * menu_spacing);
	
		var text_width = string_width(menu_options[i]);
		var text_height = string_height("A");
	
		// collision text area
		var box_left = _menu_center_x - (text_width * scale_current[i]) / 2;
		var box_right = _menu_center_x + (text_width * scale_current[i]) / 2;
		var box_top = yy - (text_height * scale_current[i]) / 2;
		var box_bottom = yy + (text_height * scale_current[i]) / 2;
	
		// veryfies if mouse is under the option
		if (point_in_rectangle(_mouse_gui_x, _mouse_gui_y, box_left, box_top, box_right, box_bottom))
		{
			_mouse_selection = i;
			menu_index = i;
		
			if (mouse_check_button_pressed(mb_left))
			{
				key_confirm = true;
			}
			break;
		}
	
	}

	// Scale logic
	for (var i = 0; i < array_length(menu_options); i++)
	{
		var target_scale = scale_default;
	
		if (i == menu_index)
		{
			target_scale = scale_hover;
		}
	
		scale_current[i] = lerp(scale_current[i], target_scale, 0.2);
	
	}

	// Execution 

	if (key_confirm)
	{
		switch(menu_index)
		{
			case 0:
				room_goto_next();
				break;
			case 1: // opções
				global.game_state = OPTIONS_STATE;
				break;
			case 2: // leave
				game_end();
				break;
			
		}
	}
}
