// 1. Checar se o jogo está pausado
if (global.game_state == PAUSED_STATE) {
    
    // Diminuir o temporizador de input
    time_input = max(0, time_input - 1);

    // keyboard inputs
    if (time_input == 0) 
	{
        var _change_selection = false;

        if (keyboard_check(vk_down) || keyboard_check(ord("S"))) 
		{
            pause_index++;
            _change_selection = true;
        }
        else if (keyboard_check(vk_up) || keyboard_check(ord("W"))) 
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
    if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space))
	{
        scr_pause_logic(pause_options);
    }
    
    // --- C. Ação da Seleção (Mouse) - Implementação no Draw GUI
    // A detecção de clique do mouse será feita no evento Draw GUI ao desenhar os botões.
}

// pause menu action
if (keyboard_check_pressed(vk_escape)) {
    if (global.game_state == GAMING_STATE) 
	{
        global.game_state = PAUSED_STATE;
    } 
	else 
	{
        global.game_state = GAMING_STATE;
    }
}