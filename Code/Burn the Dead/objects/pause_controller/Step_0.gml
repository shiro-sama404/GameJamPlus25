// Inputs
var _key_up = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
var _key_down = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));
var _key_left = keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A"));
var _key_right = keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"));
var _key_confirm = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);
var _key_back = keyboard_check_pressed(vk_escape);


if (global.game_state == PAUSED_STATE)
{
    
    // Diminuir o temporizador de input
    time_input = max(0, time_input - 1);

    // keyboard inputs
    if (time_input == 0) 
	{
        var _change_selection = false;

        if (_key_down) 
		{
            pause_index++;
            _change_selection = true;
        }
        else if (_key_up) 
		{
            pause_index--;
            _change_selection = true;
        }

        if (_change_selection) 
		{
            // Limitar a seleção ao tamanho do array (Loop)
            var _num_options = array_length(pause_options);
            pause_index = pause_index mod _num_options;
            if (pause_index < 0) 
			{
                pause_index += _num_options;
            }
            // Resetar o temporizador
            time_input = delay_input;
        }
    }

	// action
    if (_key_confirm)
	{
        scr_pause_logic(pause_options);
    }
    // mouse detection will be implemented on drawGUI
}

if (global.game_state == OPTIONS_STATE)
{
    // VERTICAL NAVIGATION
    if (_key_up)
	{
        options_index = (options_index - 1 + array_length(options_list)) % array_length(options_list);
    }
	
    if (_key_down) 
	{
        options_index = (options_index + 1) % array_length(options_list);
    }
    
    var option = options_list[options_index];
    var _var_id = asset_get_index(option.var_name); // gets global var ID

    // HORIZONTAL NAVIGATON
    if (_key_left || _key_right) {
        
        if (option.type == "toggle")
        {
            var _val = !variable_global_get(_var_id); 
            variable_global_set(_var_id, _val);
            
            if (option.var_name == "global.fullscreen_on") 
			{
                 window_set_fullscreen(_val); 
            }
        }
        else if (option.type == "switcher") 
        {
            var _current_idx = variable_global_get(_var_id);
            
			// update the index in mod
            var _new_idx = (_current_idx + (key_right ? 1 : -1) + array_length(option.values)) % array_length(option.values);
            variable_global_set(_var_id, _new_idx);
        }
        else if (option.type == "slider")
        {
            var _val = variable_global_get(_var_id);
            var _new_val = _val + (key_right ? option.step : -option.step);
            
            // Limits the value and updates the variable and audio
            _new_val = clamp(_new_val, option.min, option.max);
            variable_global_set(_var_id, _new_val);
            audio_master_gain(_new_val / 10); 
        }
    }
    
    // if ESCAPE is pressed, go back to pause menu
    if (_key_back) 
	{
        global.game_state = PAUSED_STATE;
        pause_index = 1;
    }
}

// pause menu action
if (_key_back) 
{
    if (global.game_state == GAMING_STATE) 
	{
        global.game_state = PAUSED_STATE;
    } 
	else 
	{
        global.game_state = GAMING_STATE;
    }
}

