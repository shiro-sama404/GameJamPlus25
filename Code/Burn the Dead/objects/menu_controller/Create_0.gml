menu_options = [
	"JOGAR",
	"OPÇÕES",
	"SAIR"
];

menu_index = 0;

menu_spacing = 60;

// scale configs
scale_default = 1;
scale_hover = 1.2;
scale_current = [];
	
// initializing scale for all options
for (var i = 0; i < array_length(menu_options); i++)
{
	scale_current[i] = scale_default;
}

// mouse state
mouse_on_menu = false;
