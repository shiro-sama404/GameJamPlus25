function scr_pause_logic(argument0)
{
	// argument0 é o índice da opção selecionada

	var _index = argument0;

	switch (_index) {
	    case 0: // "Voltar ao Jogo"
			// RETOMAR O JOGO: reativar todas as instâncias
			instance_activate_all();
			
	        global.game_state = GAMING_STATE;
	        break;

	    case 1: // "Opções"
			// Ir para menu de opções (mantém o jogo pausado)
			global.game_state = OPTIONS_STATE;
	        break;

	    case 2: // "Voltar para o Menu"
			// RETOMAR O JOGO antes de mudar de room
			instance_activate_all();
			
	        global.game_state = GAMING_STATE; 
	        room_goto(rm_menu); 
	        break;

	    case 3: // "Sair para Área de Trabalho"
	        game_end();
	        break;
	}
}
