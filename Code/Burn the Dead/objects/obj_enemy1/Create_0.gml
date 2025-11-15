// Herdar propriedades da entidade
event_inherited();

// Configurações específicas do inimigo
vida_maxima = 100;
vida_atual = vida_maxima;
dano = 10;

// Configurar hurtbox do inimigo
hurtbox_x1 = -12;
hurtbox_y1 = -28;
hurtbox_x2 = 12;
hurtbox_y2 = 0;
my_hurtbox = new scr_hurtbox(hurtbox_x1, hurtbox_y1, hurtbox_x2, hurtbox_y2);

randomise();

my_x = x;
my_y = y;

// Configurações de alcance melhoradas (ajustadas para sprite maior do player)
alcance_deteccao = 120;  // Distância para detectar o player (aumentado)
alcance_ataque = 50;     // Distância para atacar (aumentado para sprite maior)
velocidade_perseguicao = 1.0;

//debug
ponto_x = 0;
ponto_y = 0;
//debug

espera_estado = game_get_speed(gamespeed_fps)*2;
timer_estado = espera_estado;

area_ranged = alcance_deteccao;

alvo = noone;

timer_ataque = espera_estado;

// Cooldown após causar knockback no player
knocback_cooldown = 0;
knocback_cooldown_tempo = 90; // 1.5 segundos a 60fps

// Estado de recuperação após ataque
recuperacao_ativa = false;
recuperacao_timer = 0;
recuperacao_duracao = 30; // 0.5 segundos a 60fps

// Variáveis para controle da animação de morte
morte_animacao_completa = false;
morte_timer_fade = 0;
morte_fade_duracao = 180; // 3 segundos a 60fps
morte_alpha = 1.0;

// Sobrescrever função de morte
morrer = function() {
    // Som de morte do inimigo - escolher aleatoriamente entre os dois sons
    var _som_morte = choose(snd_enemy_death1, snd_enemy_death2);
    audio_play_sound(_som_morte, 1, false);
    
    // Mudar para estado de morte ao invés de destruir imediatamente
    estado = estado_morte;
    sprite_index = spr_enemy_death;
    image_index = 0;
    
    // Parar movimento
    velh = 0;
    velv = 0;
    velz = 0;
}

// Importar funções específicas do inimigo
checa_area = method(self, enemy_checa_area);
estado_parado = method(self, enemy_estado_parado);
estado_andando = method(self, enemy_estado_andando);
estado_persegue = method(self, enemy_estado_persegue);
estado_ataque = method(self, enemy_estado_ataque);
estado_morte = method(self, enemy_estado_morte);

estado = estado_andando;