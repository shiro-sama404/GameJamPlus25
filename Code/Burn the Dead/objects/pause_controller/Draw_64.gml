if (global.game_state == PAUSED_STATE) {
    // Black transparent background
    draw_set_alpha(0.5);
    draw_set_color(c_black);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    draw_set_alpha(1);

    draw_set_halign(fa_center);
    draw_set_font(fnt_menu); 

    var _start_y = display_get_gui_height() / 2 - 50;
    var _gap = 40; // spacing between options
    var _num_options = array_length(pause_options);
    var _mouse_over = false;

    // Loop which draws and veryfies mouse input
    for (var i = 0; i < _num_options; i++) {
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
            if (mouse_check_button_pressed(mb_left)) {
                scr_pause_logic(i);
            }
        } 
        else if (i == pause_index) {
            draw_set_color(c_aqua); // highlighted keyboard color
        }
        else {
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