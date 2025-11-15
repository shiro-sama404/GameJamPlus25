// === SISTEMA DE CUTSCENE AVANÇADO ===
// Similar ao Graveyard Keeper / Papers Please

// Configurações da tela
gui_width = display_get_gui_width();
gui_height = display_get_gui_height();

// === ESTRUTURA DE DADOS DA CUTSCENE ===
// Usando cutscene de exemplo para demonstração
cutscene_data = [
    {
        text: "Tirana. O Coração pulsante do Império, alimentado pelo Aetherium. Uma maravilha de vapor e progresso... agora, um mausoléu de ferrugem e carne corrompida. Neste pesadelo mecânico, caminha a engenheira Avulli. Uma criadora de vida artificial... agora caçada pelos arquitetos da morte.",
        sprite: IMG_1794,
        sound: Cena1,
        callback: function(){
			audio_stop_sound(Cena1)
		}
    },
    {
        text: "Ela acreditava no trabalho. Próteses para reconstruir os veteranos feridos pela guerra. Uma mentira piedosa, contada por homens impiedosos. Seu trabalho é vital, Avulli. Você não está apenas construindo membros... está reconstruindo a esperança do Império. ...Mas a esperança pode ser facilmente transformada em uma arma.",
        sprite: spr_teste,
        sound: Cena2,
        callback: function(){
			audio_stop_sound(Cena2)
		}
    },
    {
        text: "O destino interveio. Um acidente. Uma vida inocente prestes a se extinguir.  Desafiando a ética e a morte, Avulli usou seu protótipo. O núcleo de energia único. Ela não estava apenas salvando seu animal de estimação... ela estava criando a chave.",
        sprite: spr_teste,
        sound: Cena3,
        callback: function(){
			audio_stop_sound(Cena3)
		}
    },
	{
        text: "A verdade, quando revelada, é brutal como aço frio. Não havia veteranos. Apenas máquinas de guerra. O protótipo funciona. Você provou seu valor, engenheira. Traga-nos o núcleo. Ele é propriedade do governo.",
        sprite: spr_teste,
        sound: Cena4,
        callback: function()
		{
			audio_stop_sound(Cena4)
		}
    },
		{
        text: "Quando ela recusou, o véu da civilização já estava em farrapos. O colapso da bolsa imobiliária havia sangrado as ruas... e a fome levou à Guerra Civil. Desesperada, a população invadiu os arsenais e laboratórios do governo. Mas não encontraram apenas armas. Encontraram os pecados do Império: exoarmaduras inacabadas, vírus experimentais... ...E a contaminação foi liberada. A Praga do Aetherium. Um acidente nascido do caos popular. Foi o que disseram na transmissão final. Uma mentira conveniente. A Guerra Civil foi a desculpa perfeita para o governo usar o caos como cobertura, testar suas armas e caçar a única coisa que importava. Agora, a engenheira está presa entre os monstros que o povo libertou... e os monstros que o governo ainda comanda. (Após o corte para preto) Ela deve lutar. Ela deve queimar os mortos. Pois em sua mochila, o pequeno coração mecânico pulsa... a única coisa no mundo que eles não podem ter.",
        sprite: spr_teste,
        sound: Cena5,
        callback: function()
		{
			audio_stop_sound(Cena5)
			room_goto_next()
		}
    }
];

// === VARIÁVEIS DE CONTROLE ===
current_step = 0;
cutscene_finished = false;

// === EFEITO DE DIGITAÇÃO ===
text_visible_length = 0;
text_speed = 2; // Caracteres por frame
text_typing_sound_timer = 0;

// === LAYOUT E POSICIONAMENTO ===
// Área da imagem (metade superior da tela)
image_area_y = 0;
image_area_height = gui_height * 0.6;
image_x = gui_width / 2;
image_y = image_area_height / 2;

// Área do texto (parte inferior) - centralizado verticalmente
text_area_y = image_area_height;
text_area_height = gui_height - image_area_height;
text_margin = 60;

// Posição do texto centralizada
text_x = gui_width / 2;
text_y = text_area_y + (text_area_height / 2);
text_width = gui_width - (text_margin * 2);

// === CONTROLES ===
accept_input = true;
skip_typing_input = false;

// === FUNÇÕES AUXILIARES ===

// Função para inicializar um passo da cutscene
inicializar_passo = function() {
    if (current_step >= array_length(cutscene_data)) {
        finalizar_cutscene();
        return;
    }
    
    text_visible_length = 0;
    text_typing_sound_timer = 0;
    
    var step_data = cutscene_data[current_step];
    
    // Tocar som se especificado
    if (step_data.sound != noone && audio_exists(step_data.sound)) {
        audio_play_sound(step_data.sound, 1, false);
    }
    
    // NÃO executar callback aqui - apenas quando avançar o passo
}

// Função para executar callback do passo atual
executar_callback_atual = function() {
    if (current_step < array_length(cutscene_data)) {
        var step_data = cutscene_data[current_step];
        if (step_data.callback != noone && is_method(step_data.callback)) {
            step_data.callback();
        }
    }
}

// Função para avançar para o próximo passo
avancar_passo = function() {
    // Executar callback do passo atual ANTES de avançar
    executar_callback_atual();
    
    current_step++;
    
    if (current_step < array_length(cutscene_data)) {
        inicializar_passo();
    } else {
        finalizar_cutscene();
    }
}

// Função para finalizar a cutscene
finalizar_cutscene = function() {
    cutscene_finished = true;
    instance_destroy();
}

// === INICIALIZAÇÃO ===
inicializar_passo();