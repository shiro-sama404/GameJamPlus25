var _gui_center_x = display_get_gui_width() / 2;
var _gui_center_y = display_get_gui_height() / 2;

if (global.game_state == PAUSED_STATE || global.game_state == OPTIONS_STATE)
{
	
    // Desenho do Fundo Preto Transparente
    draw_set_alpha(0.5);
    draw_set_color(c_black);
    draw_rectangle(0, 0, 2*_gui_center_x, 2*_gui_center_y, false);
    draw_set_alpha(1);
    
    
    draw_set_font(fnt_menu);
}


switch (global.game_state)
{
	case PAUSED_STATE:

	    draw_set_halign(fa_center);
	    draw_set_font(menu_font); 

	    var _start_y = display_get_gui_height() / 2 - 50;
	    var _gap = 40; // spacing between options
	    var _num_options = array_length(pause_options);
	    var _mouse_over = false;

		 // Desenho da Caixa de Fundo (usando spr_back_box)
		draw_sprite_ext(spr_back_box, 0, _gui_center_x, _gui_center_y, 1, .75, 0, c_white, 1); 
		
		
	    // Desenho do Título
	    draw_set_font(fnt_title);
	    var _title = "JOGO PAUSADO";
	    draw_text(_gui_center_x, _gui_center_y - 150, _title);

		draw_set_font(menu_font);
		
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
	    if (_mouse_over)
		{
	        time_input = 0; // Permite o clique imediato do mouse, mas a seleção do mouse é dominante.
	    }
	break;

	case OPTIONS_STATE:
	    // ------------------------------------------------------------------------------------
		// DRAW EVENT (GUI)
		// Desenha o menu na camada da GUI
		// ------------------------------------------------------------------------------------

		draw_set_font(menu_font);
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);

		var _w = display_get_gui_width();
		var _h = display_get_gui_height();

		// Posição inicial do menu (centralizado)
		var _start_x = _w / 2;
		_start_y = menu_margin_top;

		// Desenho da Caixa de Fundo (usando spr_back_box)
		draw_sprite_ext(spr_back_box, 0, _gui_center_x, _gui_center_y, 2, .5, 0, c_white, 1); 

		// Desenho do Título
	    draw_set_font(fnt_title);
	    _title = "OPÇÕES";
	    draw_text(_gui_center_x, _gui_center_y - 125, _title);

		draw_set_font(menu_font);
		
		// h distance between slider and volume name
		var _gap_x = 50; 

		for (var i = 0; i < array_length(options); i++) 
		{
		    var _option = options[i];
		    var _y = _start_y + (i * menu_spacing);
		    var _is_selected = (i == current_option);
			
		    // Cor da opção: Amarelo se selecionada, Branco se não
		    draw_set_color(_is_selected ? menu_color_selected : menu_color_normal);
    
		    // -----------------------------------
		    // COLUNA ESQUERDA: Nome da Opção
		    // -----------------------------------
		    draw_set_halign(fa_right);
		    draw_text(_start_x - _gap_x, _y, _option.name);

		    // -----------------------------------
		    // COLUNA DIREITA: Valor da Opção
		    // -----------------------------------
		    draw_set_halign(fa_left);
    
		    // VARIÁVEIS COMUNS DE DESENHO DA COLUNA DIREITA
		    var _draw_x = _start_x + _gap_x;
		    var _draw_y = _y;
		    var _current_val_text = "";

		    switch (_option.type) {
		        case OPTION_TYPE.TOGGLE:
		            // ESTA É A CORREÇÃO PRINCIPAL: Garante que "values" existe
		            // Antes de tentar acessar o array values, verificamos o tipo.
            
		            // O erro original era aqui: array_length(_option.values)
		            // Se _option.values for undefined (como é no SLIDER), o GameMaker erra.
            
		            var _index = clamp(real(_option.current_val), 0, array_length(_option.values) - 1);
		            _current_val_text = _option.values[_index];
            
		            // Desenha a opção toggle (ex: Sim/Não)
		            draw_text(_draw_x, _draw_y, _current_val_text);
            
		            // Adiciona indicadores de alteração (< >) se selecionada
		            if (_is_selected) {
		                // Desenha o marcador de seleção à esquerda e à direita
		                draw_text(_draw_x - 30, _draw_y, "<");
		                draw_text(_draw_x + string_width(_current_val_text) + 30, _draw_y, ">");
		            }
		            break;
            
		        case OPTION_TYPE.SLIDER:
		            // Desenho da Slide Bar
            
		            // Configurações do Slider
		            var _slider_w = 200; // Largura da barra
		            var _slider_h = 10;  // Altura da barra
		            var _slider_x1 = _draw_x;
		            var _slider_y1 = _draw_y - _slider_h / 2;
		            var _slider_x2 = _draw_x + _slider_w;
		            var _slider_y2 = _draw_y + _slider_h / 2;
            
		            // Normaliza o valor atual (0 a 1)
		            var _norm_val = (_option.current_val - _option.min) / (_option.max - _option.min);
		            var _fill_x = _slider_x1 + (_slider_w * _norm_val); // Ponto de preenchimento

		            // 1. Desenha o fundo da barra (cinza)
		            draw_set_color(c_dkgray);
		            draw_rectangle(_slider_x1, _slider_y1, _slider_x2, _slider_y2, false);
            
		            // 2. Desenha o preenchimento da barra
		            draw_set_color(c_lime); // Cor de preenchimento (verde limão)
		            draw_rectangle(_slider_x1, _slider_y1, _fill_x, _slider_y2, false);
            
		            // 3. Desenha o contorno da barra
		            draw_set_color(_is_selected ? menu_color_selected : c_white); // Contorno branco ou amarelo
		            draw_rectangle(_slider_x1, _slider_y1, _slider_x2, _slider_y2, true);
            
		            // 4. Desenha o "thumb" (o marcador do slider)
		            draw_set_color(c_white);
		            draw_circle(_fill_x, _draw_y, _slider_h * 1.5, false); // Círculo do marcador
            
		            // 5. Desenha o valor percentual ao lado do slider
		            var _percent = string_format(_option.current_val * 100, 0, 0); // Ex: 50
		            draw_set_color(c_white);
		            draw_text(_slider_x2 + 30, _draw_y, _percent + "%");
            
		            break;
            
		        case OPTION_TYPE.ACTION:
		            // Opções de ação (apenas texto)
		            _current_val_text = ""; // Não há valor na coluna direita para AÇÃO
		            // Se for uma ação, desenha o nome da opção centralizado para destacar
		            draw_set_halign(fa_center);
		            draw_text(_start_x, _draw_y, _option.name);

		            // Adiciona indicadores de seleção se selecionada (para Ação)
		            if (_is_selected) {
		                draw_text(_start_x - string_width(_option.name)/2 - 30, _draw_y, ">");
		                draw_text(_start_x + string_width(_option.name)/2 + 30, _draw_y, "<");
		            }
		            break;
		    }
		}

		// ------------------------------------------------------------------------------------
		// Limpa configurações de desenho
		// ------------------------------------------------------------------------------------
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		draw_set_color(c_white);
	break;
}
