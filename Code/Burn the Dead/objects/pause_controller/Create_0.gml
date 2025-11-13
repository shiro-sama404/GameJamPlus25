// game states
#macro GAMING_STATE 0
#macro PAUSED_STATE 1

global.game_state = GAMING_STATE;

// options.
pause_options = [
    "Voltar ao Jogo",
    "Opções",
    "Voltar para o Menu",
    "Sair para Área de Trabalho"
];

// selected option
pause_index = 0; 

// input timer (avoid too fast option selection)
time_input = 0;
delay_input = 8;