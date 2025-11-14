// game states
#macro GAMING_STATE 0
#macro PAUSED_STATE 1
#macro OPTIONS_STATE 2

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

// --- Menu de Opções ---
options_index = 0;
options_spacing = 40;

// Definição das Opções
options_list = [
    { name: "Tela Cheia", type: "toggle", var_name: "global.fullscreen_on", values: ["Não", "Sim"] },
    { name: "Volume Mestre", type: "slider", var_name: "global.master_volume", min: 0, max: 10, step: 1 },
    { name: "Controle", type: "switcher", var_name: "global.control_type", values: ["Teclado", "Controle"] }
];

// Definição das Variáveis Globais (Valores Iniciais)
global.fullscreen_on = window_get_fullscreen(); 
global.master_volume = 5; 
global.control_type = 0; // 0 = Teclado, 1 = Controle

// Aplica a configuração inicial
audio_master_gain(global.master_volume / 10);