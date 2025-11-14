function scr_pause_logic(argument0)
{
	// argument0 é o índice (menu_selecao) da opção selecionada

	var _index = argument0;

	switch (_index) {
	    case 0: // "Voltar ao Jogo"
	        global.game_state = GAMING_STATE;
			instance_activate_all();
	        break;

	    case 1: // "Opções"
			global.game_state = OPTIONS_STATE;
	        break;

	    case 2: // "Voltar para o Menu"
	        global.game_state = GAMING_STATE; 
	        instance_activate_all();
	        room_goto(rm_menu); 
	        break;

	    case 3: // "Sair para Área de Trabalho"
	        game_end();
	        break;
	}
}