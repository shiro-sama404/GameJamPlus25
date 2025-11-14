if (global.game_state == PAUSED_STATE || global.game_state == OPTIONS_STATE)
{
	var _gui_center_x = display_get_gui_width() / 2;
    var _gui_center_y = display_get_gui_height() / 2;
    
    // Desenho do Fundo Preto Transparente
    draw_set_alpha(0.5);
    draw_set_color(c_black);
    draw_rectangle(0, 0, 2*_gui_center_x, 2*_gui_center_y, false);
    draw_set_alpha(1);
    
    // Desenho da Caixa de Fundo (usando spr_back_box)
    draw_sprite_ext(spr_back_box, 0, _gui_center_x, _gui_center_y, 1, 1, 0, c_white, 1); 
    
    // Desenho do Título
    draw_set_font(fnt_title); // Assumindo uma fonte de título
    var _title = (global.game_state == PAUSED_STATE) ? "JOGO PAUSADO" : "OPÇÕES";
    draw_text(_gui_center_x, _gui_center_y - 150, _title);
    
    draw_set_font(fnt_menu);
}

if (global.game_state == PAUSED_STATE)
{

    draw_set_halign(fa_center);
    draw_set_font(fnt_menu); 

    var _start_y = display_get_gui_height() / 2 - 50;
    var _gap = 40; // spacing between options
    var _num_options = array_length(pause_options);
    var _mouse_over = false;

    // Loop which draws and veryfies mouse input
    for (var i = 0; i < _num_options; i++) 
	{
        var _option_str = pause_options[i];
        var _x = display_get_gui_width() / 2;
        var _y = _start_y + i * _gap;
        
        // defining a rectangle area so mouse can be detected
        var _mouse_area_l = _x - 200;
        var _mouse_area_r = _x + 200;
        var _mouse_area_t = _y - 15;
        var _mouse_area_b = _y + 15;
        
        // verifying if mouse is under this option
        if (point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), _mouse_area_l, _mouse_area_t, _mouse_area_r, _mouse_area_b))
		{
            draw_set_color(c_yellow); // mouse highlight color
            pause_index = i; // updating keyboard selection to be equal to the mouse
            _mouse_over = true;
            
            // action
            if (mouse_check_button_pressed(mb_left)) 
			{
                scr_pause_logic(i);
            }
        } 
        else if (i == pause_index)
		{
            draw_set_color(c_aqua); // highlighted keyboard color
        }
        else 
		{
            draw_set_color(c_white); // default color
        }

		// draw option text
        draw_text(_x, _y, _option_str);
    }
    
    // Se o mouse estiver sobre alguma opção, desativar o temporizador para
    // que o movimento do teclado não interrompa a seleção do mouse imediatamente.
    if (_mouse_over) {
        time_input = 0; // Permite o clique imediato do mouse, mas a seleção do mouse é dominante.
    }
}

if (global.game_state == OPTIONS_STATE)
{
    var _gui_center_x = display_get_gui_width() / 2;
    var _gui_center_y = display_get_gui_height() / 2;
    var _y_start_opt = _gui_center_y - 50; 
    var _col_x_name = _gui_center_x - 100; // Coluna do Nome
    var _col_x_value = _gui_center_x + 100; // Coluna do Valor
    
    // Lógica para detectar se o mouse está sobre a opção (para seleção visual)
    var mouse_gui_x = device_mouse_x_to_gui(0);
    var mouse_gui_y = device_mouse_y_to_gui(0);

    for (var i = 0; i < array_length(options_list); i++)
    {
        var _opt_y = _y_start_opt + (i * options_spacing);
        var _option = options_list[i];
        
        // Coloração: destaque a opção selecionada (teclado) OU sob o mouse
        var _is_hover = false; 
        var _mouse_area_t = _opt_y - 15;
        var _mouse_area_b = _opt_y + 15;
        // Use uma área ampla para o mouse
        if (point_in_rectangle(mouse_gui_x, mouse_gui_y, _gui_center_x - 300, _mouse_area_t, _gui_center_x + 300, _mouse_area_b)) {
             options_index = i; // Seleção visual com mouse
             _is_hover = true;
        }

        var draw_color = (i == options_index || _is_hover) ? c_aqua : c_white;
        draw_set_colour(draw_color);

        // --- Desenhar o Nome (Coluna 1) ---
        draw_set_halign(fa_right);
        draw_text(_col_x_name, _opt_y, _option.name);
        
        // --- Desenhar o Valor (Coluna 2) ---
        draw_set_halign(fa_left);
        draw_set_colour(c_white); 
        
        var _var_id = asset_get_index(_option.var_name);
        var _current_val = variable_global_get(_var_id);

        if (_option.type == "toggle" || _option.type == "switcher")
        {
            var _text = _option.values[_current_val];
            draw_text(_col_x_value, _opt_y, _text);
        }
        else if (_option.type == "slider")
        {
            // Lógica de Desenho e Interação do Slider (Volume)
            var _slider_width = 150;
            var _slider_height = 10;
            var _val_percent = _current_val / _option.max; 
            
            var _slider_x1 = _col_x_value; 
            var _slider_x2 = _slider_x1 + _slider_width;
            var _slider_y1 = _opt_y - (_slider_height / 2);
            var _slider_y2 = _slider_y1 + _slider_height;
            var _fill_x = _slider_x1 + (_slider_width * _val_percent); 

            // Barra Vazia
            draw_set_color(c_gray);
            draw_rectangle(_slider_x1, _slider_y1, _slider_x2, _slider_y2, false);
            
            // Barra Preenchida
            draw_set_color(c_lime);
            draw_rectangle(_slider_x1, _slider_y1, _fill_x, _slider_y2, false);
            
            // Marcador (Thumb)
            draw_set_color(c_yellow);
            draw_rectangle(_fill_x - 5, _slider_y1 - 5, _fill_x + 5, _slider_y2 + 5, false);
            
            // Valor numérico
            draw_set_color(c_white);
            draw_text(_slider_x2 + 20, _opt_y, string(_current_val));
            
            // --- Interação de Arraste/Clique do Mouse no Slider (no Draw GUI) ---
            var _mouse_area_l = _slider_x1 - 5; 
            var _mouse_area_r = _slider_x2 + 5; 

            if (point_in_rectangle(mouse_gui_x, mouse_gui_y, _mouse_area_l, _slider_y1 - 10, _mouse_area_r, _slider_y2 + 10) && 
                mouse_check_button(mb_left)) // Verifica se o mouse está clicado (para arrastar)
            {
                // Calcula o novo valor baseado na posição X do mouse
                var _new_x = clamp(mouse_gui_x, _slider_x1, _slider_x2);
                var _new_percent = (_new_x - _slider_x1) / _slider_width;
                
                var _new_val = round(_new_percent * _option.max / _option.step) * option.step;
                _new_val = clamp(_new_val, _option.min, _option.max);

                variable_global_set(_var_id, _new_val);
                audio_master_gain(_new_val / 10);
            }
        }
    }
}