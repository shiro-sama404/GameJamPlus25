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
	        // Aqui você chamaria o menu de opções (ex: room_goto(rm_opcoes) 
	        // ou mudar para um sub-estado de opções)
	        show_message("Abrir menu de Opções!");
	        break;

	    case 2: // "Voltar para o Menu"
	        global.game_state = GAMING_STATE; // Reseta o estado antes de mudar de Room
	        instance_activate_all();
	        room_goto(rm_menu); // Substitua pelo nome da sua Room do menu principal
	        break;

	    case 3: // "Sair para Área de Trabalho"
	        game_end();
	        break;
	}
}