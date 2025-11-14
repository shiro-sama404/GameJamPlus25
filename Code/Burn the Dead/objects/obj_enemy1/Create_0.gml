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

// Configurações de alcance melhoradas
alcance_deteccao = 100;  // Distância para detectar o player
alcance_ataque = 35;     // Distância para atacar
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

// Sobrescrever função de morte
morrer = function() {
    // Destruir o inimigo quando morre
    instance_destroy();
}

// Sobrescrever função de morte
morrer = function() {
    // Destruir o inimigo quando morre
    instance_destroy();
}

// Importar funções específicas do inimigo
checa_area = method(self, enemy_checa_area);
estado_parado = method(self, enemy_estado_parado);
estado_andando = method(self, enemy_estado_andando);
estado_persegue = method(self, enemy_estado_persegue);
estado_ataque = method(self, enemy_estado_ataque);

estado = estado_andando;