extends CanvasLayer

# Controles de toque criados com apoio do ChatGPT.
var botoes: Dictionary = {}


func _ready() -> void:
	layer = 10
	visible = DisplayServer.is_touchscreen_available()

	_criar_botao("cima", "mover_cima", "^")
	_criar_botao("baixo", "mover_baixo", "v")
	_criar_botao("esquerda", "mover_esquerda", "<")
	_criar_botao("direita", "mover_direita", ">")
	_criar_botao("ataque", "atacar", "ATK")
	_criar_botao("reiniciar", "", "REIN.")

	botoes["reiniciar"].pressed.connect(_reiniciar)
	botoes["reiniciar"].hide()

	get_viewport().size_changed.connect(_posicionar)
	_posicionar()


func _process(_delta: float) -> void:
	botoes["reiniciar"].visible = get_parent().acabou


func _criar_botao(nome: String, acao: String, texto: String) -> void:
	var botao := TouchScreenButton.new()
	botao.name = nome
	botao.action = acao
	botao.passby_press = acao.begins_with("mover_")
	botao.texture_normal = _textura(Color(0.08, 0.10, 0.18, 0.7))
	botao.texture_pressed = _textura(Color(0.2, 0.7, 0.8, 0.9))

	var forma := RectangleShape2D.new()
	forma.size = Vector2(32, 32)
	botao.shape = forma

	add_child(botao)
	botoes[nome] = botao

	var legenda := Label.new()
	legenda.text = texto
	legenda.size = Vector2(32, 32)
	legenda.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	legenda.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	legenda.mouse_filter = Control.MOUSE_FILTER_IGNORE
	legenda.add_theme_font_size_override("font_size", 9)
	botao.add_child(legenda)


func _textura(cor: Color) -> GradientTexture2D:
	var gradiente := Gradient.new()
	gradiente.set_color(0, cor)
	gradiente.set_color(1, cor)

	var textura := GradientTexture2D.new()
	textura.width = 32
	textura.height = 32
	textura.gradient = gradiente
	return textura


func _posicionar() -> void:
	var tela := get_viewport().get_visible_rect().size

	botoes["cima"].position = Vector2(40, tela.y - 104)
	botoes["baixo"].position = Vector2(40, tela.y - 40)
	botoes["esquerda"].position = Vector2(8, tela.y - 72)
	botoes["direita"].position = Vector2(72, tela.y - 72)
	botoes["ataque"].position = Vector2(tela.x - 48, tela.y - 48)
	botoes["reiniciar"].position = Vector2(tela.x - 48, tela.y - 96)


func _reiniciar() -> void:
	if get_parent().acabou:
		get_tree().reload_current_scene.call_deferred()
