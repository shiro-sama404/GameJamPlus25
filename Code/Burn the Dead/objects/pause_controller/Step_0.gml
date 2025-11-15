// getting GUI dimensions
current_gui_height = display_get_gui_height();
menu_margin_top = current_gui_height /2.13;

// Inputs - Keyboard
var _key_up = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
var _key_down = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));
var _key_left = keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A"));
var _key_right = keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"));
var _key_confirm = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);
var _key_back = keyboard_check_pressed(vk_escape);

// Inputs - Gamepad
var _gp_up = gamepad_button_check_pressed(0, gp_padu) || gamepad_axis_value(0, gp_axislv) < -0.5;
var _gp_down = gamepad_button_check_pressed(0, gp_padd) || gamepad_axis_value(0, gp_axislv) > 0.5;
var _gp_left = gamepad_button_check_pressed(0, gp_padl) || gamepad_axis_value(0, gp_axislh) < -0.5;
var _gp_right = gamepad_button_check_pressed(0, gp_padr) || gamepad_axis_value(0, gp_axislh) > 0.5;
var _gp_confirm = gamepad_button_check_pressed(0, gp_face1); // A/Cross
var _gp_back = gamepad_button_check_pressed(0, gp_face2); // B/Circle

// Combine inputs
_key_up = _key_up || _gp_up;
_key_down = _key_down || _gp_down;
_key_left = _key_left || _gp_left;
_key_right = _key_right || _gp_right;
_key_confirm = _key_confirm || _gp_confirm;
_key_back = _key_back || _gp_back;

switch(global.game_state)
{
	case PAUSED_STATE:
	    // Diminuir o temporizador de input
	    time_input = max(0, time_input - 1);

	    // keyboard inputs
	    if (time_input == 0) 
		{
	        var _change_selection = false;

	        if (_key_down) 
			{
		        // Som de navegação
		        audio_play_sound(snd_select, 1, false);
	            pause_index++;
	            _change_selection = true;
	        }
	        else if (_key_up) 
			{
		        // Som de navegação
		        audio_play_sound(snd_select, 1, false);
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
		    // Som de clique/confirmação
		    audio_play_sound(snd_click, 1, false);
	        scr_pause_logic(pause_index);
	    }
	    // mouse detection will be implemented on drawGUI
	break;

	case OPTIONS_STATE:
	    // ------------------------------------------------------------------------------------
		// STEP EVENT
		// Lógica de controle (Teclado e Mouse)
		// ------------------------------------------------------------------------------------

		// Diminuir o temporizador de input (mesmo sistema do menu pause)
		time_input = max(0, time_input - 1);

		// Largura da tela
		var _w = display_get_gui_width();
		// Posição inicial do menu (centralizado)
		var _start_x = _w / 2;
		var _start_y = menu_margin_top;

		// ------------------------------------------------------------------------------------
		// TECLADO (Navegação Vertical) - COM TIMER
		// ------------------------------------------------------------------------------------

		if (time_input == 0) {
			var _change_selection = false;
			
			if (_key_up) {
				// Som de navegação
				audio_play_sound(snd_select, 1, false);
			    current_option = (current_option - 1 + array_length(options)) % array_length(options);
			    _change_selection = true;
			}

			if (_key_down) {
				// Som de navegação
				audio_play_sound(snd_select, 1, false);
			    current_option = (current_option + 1) % array_length(options);
			    _change_selection = true;
			}
			
			if (_change_selection) {
				time_input = delay_input;
			}
		}

		// ------------------------------------------------------------------------------------
		// TECLADO (Alteração Horizontal) - COM TIMER
		// ------------------------------------------------------------------------------------
		var _option = options[current_option];

		if (time_input == 0 && (_key_left || _key_right)) {
		    switch (_option.type) {
		        case OPTION_TYPE.TOGGLE:
		            // Troca o valor da opção (ex: Sim/Não)
		            var _len = array_length(_option.values);
		            var _dir = (_key_right) ? 1 : -1;
            
		            _option.current_val = (_option.current_val + _dir + _len) % _len;
            
		            // Aplica o script da opção
		            _option.script(_option.current_val);
		            time_input = delay_input; // Adiciona delay
		            break;
            
		        case OPTION_TYPE.SLIDER:
		            // Altera o valor do slider
		            var _dir = (_key_right) ? 1 : -1;
		            var _new_val = _option.current_val + (_dir * _option.step);
            
		            // Garante que o valor está dentro dos limites (min/max)
		            _option.current_val = clamp(_new_val, _option.min, _option.max);
            
		            // Aplica o script da opção
		            _option.script(_option.current_val);
		            time_input = delay_input; // Adiciona delay
		            break;
            
		        case OPTION_TYPE.ACTION:
		            // Opções de ação podem ser ativadas com a seta para a direita, como um atalho
		            if (_key_right) {
		                _option.script();
		                // Opcional: current_option = 0;
		            }
		            break;
		    }
		}

		// Ativa a opção (Enter ou Espaço)
		if (_key_confirm) {
		    _option = options[current_option];
		    if (_option.type == OPTION_TYPE.ACTION) {
		        _option.script();
		    }
		    // Para opções TOGGLE, o Enter funciona como a seta direita (apenas troca)
		    if (_option.type == OPTION_TYPE.TOGGLE) {
		        var _len = array_length(_option.values);
		        _option.current_val = (_option.current_val + 1) % _len;
		        _option.script(_option.current_val);
		    }
		}

		// ------------------------------------------------------------------------------------
		// MOUSE (Navegação Vertical e Slide Bar)
		// ------------------------------------------------------------------------------------

		// Largura e altura da linha do menu para detecção de mouse (ajuste conforme a sua fonte)
		var _line_width = _w * 0.8; // Largura total de detecção
		var _line_height = menu_spacing;
		var _line_x_start = _start_x - (_line_width / 2);

		// Posição do mouse
		var _mx = device_mouse_x_to_gui(0);
		var _my = device_mouse_y_to_gui(0);
		var _mouse_pressed = mouse_check_button_pressed(mb_left);
		var _mouse_held = mouse_check_button(mb_left);

		// Iterar sobre as opções para detecção do mouse
		for (var i = 0; i < array_length(options); i++)
		{
		    _option = options[i];
		    var _line_y_start = _start_y + (i * menu_spacing) - (menu_spacing / 2);

		    // 1. Detecção da opção selecionada (qualquer clique na linha)
		    if (_mx > _line_x_start && _mx < _line_x_start + _line_width &&
		        _my > _line_y_start && _my < _line_y_start + _line_height) 
			{
        
		        // Se o mouse se moveu sobre a opção, ela é selecionada
		        if (current_option != i) 
				{
					// Som de navegação quando mouse seleciona opção diferente
					audio_play_sound(snd_select, 1, false);
		            current_option = i;
		        }

		        // 2. Lógica específica do SLIDER (arrastar)
		        if (_option.type == OPTION_TYPE.SLIDER) {
		            // A largura do slider será definida como 200 no Draw Event.
		            var _slider_w = 200;
		            var _slider_x_start = _start_x + 50; // Começa 50 pixels à direita do centro
		            var _slider_x_end = _slider_x_start + _slider_w;
            
		            // Verifica se o mouse está sobre a área do slider
		            if (_mx > _slider_x_start && _mx < _slider_x_end && _mouse_held) {
		                // Calcula o novo valor do slider com base na posição do mouse
		                var _t = clamp((_mx - _slider_x_start) / _slider_w, 0, 1); // 0 a 1
		                var _new_val = lerp(_option.min, _option.max, _t);
                
		                // Arredonda para o passo (step) mais próximo
		                _option.current_val = round(_new_val / _option.step) * _option.step;
		                _option.current_val = clamp(_option.current_val, _option.min, _option.max);
                
		                // Aplica a alteração (ex: altera o volume)
		                _option.script(_option.current_val);
		            }
		        }
        
		        // 3. Lógica para ações e toggles (clique)
		        if (_mouse_pressed) {
		            if (_option.type == OPTION_TYPE.ACTION) 
					{
						// Som de clique ao executar ação
						audio_play_sound(snd_click, 1, false);
		                _option.script();
		            }
					else if (_option.type == OPTION_TYPE.TOGGLE) 
					{
						// Som de clique ao alterar opção
						audio_play_sound(snd_click, 1, false);
		                // Ao clicar, muda a opção para o próximo valor
		                var _len = array_length(_option.values);
		                _option.current_val = (_option.current_val + 1) % _len;
		                _option.script(_option.current_val);
		            }
		        }
		    }
		}
		
		// Botão B/Back para voltar ao menu de pause
		if (_key_back) {
			global.game_state = PAUSED_STATE;
		}
	
	break;
}

// pause menu action - keyboard + gamepad
var _pause_key = keyboard_check_pressed(vk_escape) || gamepad_button_check_pressed(0, gp_start); // ESC or Start button

if (_pause_key) 
{
	// se estiver no menu
	if (room == rm_menu)
	{
		if (global.game_state == OPTIONS_STATE)
		{
			global.game_state = GAMING_STATE;
		}
	}
	else
	{
		// não está no menu - dentro do jogo
	    if (global.game_state == GAMING_STATE) 
		{
			// PAUSAR O JOGO: desativar todas as instâncias exceto controllers
	        instance_deactivate_all(true);
			instance_activate_object(pause_controller);
			
			// Ativar HUD somente se ele existir
			if (instance_exists(obj_hud)) {
				instance_activate_object(obj_hud);
			}
			
	        global.game_state = PAUSED_STATE;
	    } 
		else if (global.game_state == PAUSED_STATE)
		{
			// RETOMAR O JOGO: reativar todas as instâncias
			instance_activate_all();
			
	        global.game_state = GAMING_STATE;
	    }
		else if (global.game_state == OPTIONS_STATE)
		{
			// voltar do menu de options para pause
			global.game_state = PAUSED_STATE;	
		}
	}
	
}
