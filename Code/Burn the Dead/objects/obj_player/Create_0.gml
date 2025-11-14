// Herdar propriedades da entidade
event_inherited();

// Configurações específicas do player
vida_maxima = 100;
vida_atual = vida_maxima;
dano = 25;

velh = 0;
velv = 0;
velz = 0;

z = 0;

vel_max = 2;
vel_pulo = 4;
grav = .15;
face = 1;
buffer_attack = false;
my_damage = noone;

// Configurar hurtbox do player
hurtbox_x1 = -8;
hurtbox_y1 = -40;
hurtbox_x2 = 8;
hurtbox_y2 = 0;
my_hurtbox = new scr_hurtbox(hurtbox_x1, hurtbox_y1, hurtbox_x2, hurtbox_y2);

up		= noone;
down	= noone;
left	= noone;
right	= noone;
jump	= noone;
attack	= noone;
dash	= noone;

// Timer para controlar vibração
vibration_timer = 0;

// Sistema de combo para vibração
combo_count = 0;
combo_timer = 0;
combo_timeout = 90; // 1.5 segundos para resetar combo (60fps * 1.5)
ultimo_ataque_frame = 0;

// Variáveis do dash
dash_disponivel = true;
dash_cooldown = 60; // 1 segundo a 60fps
dash_timer = 0;
dash_ativo = false;
dash_duracao = 12; // Duração do dash em frames
dash_timer_ativo = 0;
dash_velocidade = 8; // Velocidade do dash
dash_direcao = 0; // Direção do dash (-1 esquerda, 1 direita)

// Lista para armazenar posições do rastro
dash_trail = [];
dash_trail_max = 8; // Máximo de rastros

// Sobrescrever função de morte
morrer = function() {
    // Reiniciar o jogo quando o player morre
    game_restart();
}

// Importar funções específicas do player
controla_player = method(self, player_controla);
estado_idle = method(self, player_estado_idle);
estado_walk = method(self, player_estado_walk);
estado_ataque = method(self, player_estado_ataque);
estado_pulo = method(self, player_estado_pulo);
estado_jump_kick = method(self, player_estado_jump_kick);
estado_jump_kick2 = method(self, player_estado_jump_kick2);
estado_dash = method(self, player_estado_dash);

estado = estado_walk;

