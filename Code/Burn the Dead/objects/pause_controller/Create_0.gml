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

// ------------------------------------------------------------------------------------
// CREATE EVENT
// Inicialização das variáveis e da estrutura do menu
// ------------------------------------------------------------------------------------

// Variáveis de controle de navegação
current_option = 0;
menu_margin_top = display_get_gui_height() / 2.13;
menu_spacing = 50;

// Fonte e cores
menu_font = fnt_menu; // Certifique-se de que esta fonte existe no seu projeto
menu_color_normal = c_white;
menu_color_selected = c_yellow;
menu_backbox_sprite = spr_back_box; // Sprite da "back box"

// Tipos de opções
// Utilizados para definir como a opção deve ser desenhada e interagir.
enum OPTION_TYPE {
    TOGGLE,     // Opção de ligar/desligar ou selecionar de uma lista (Ex: Sim/Não, Teclado/Controle)
    SLIDER,     // Opção de valor contínuo (Ex: Volume)
    ACTION,     // Opção que executa uma ação e fecha o menu (Ex: Sair do Jogo)
}

// ------------------------------------------------------------------------------------
// ESTRUTURA DO MENU
// ------------------------------------------------------------------------------------

options = [
    {
        name: "Tela Cheia",
        type: OPTION_TYPE.TOGGLE,
        values: ["Não", "Sim"],
        current_val: 0, // 0 = Não, 1 = Sim
        script: function(_value) {
            var _fullscreen = (_value == 1);
            window_set_fullscreen(_fullscreen);
            // Armazena a configuração de tela cheia para persistência, se necessário
            // global.is_fullscreen = _fullscreen;
        }
    },
    {
        name: "Volume",
        type: OPTION_TYPE.SLIDER,
        min: 0,
        max: 1,
        step: 0.1,
        current_val: 0.5, // Valor inicial: 50%
        script: function(_value) {
            audio_master_gain(_value);
            // Armazena a configuração de volume para persistência, se necessário
            // global.master_volume = _value;
        }
    },
    {
        name: "Controles",
        type: OPTION_TYPE.TOGGLE,
        values: ["Teclado", "Controle"],
        current_val: 0, // 0 = Teclado, 1 = Controle
        script: function(_value) {
            // Lógica para alternar entre teclado e controle
            // global.control_scheme = _value;
        }
    }
];

// ------------------------------------------------------------------------------------
// Inicialização do Volume e Tela Cheia na criação
// ------------------------------------------------------------------------------------
// Aplica as configurações iniciais
options[0].script(options[0].current_val); // Tela Cheia
options[1].script(options[1].current_val); // Volume