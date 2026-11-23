
extends Control

@onready var botao_voltar = $BotaoVoltar
@onready var botao_trilho = $BotaoTrilho
@onready var luz = $BotaoTrilho/PointLight2D


func _ready():
	botao_voltar.pressed.connect(_voltar)
	botao_trilho.pressed.connect(_abrir_trilho)

	_atualizar_atividades()


func _atualizar_atividades() -> void:
	var ano_selecionado: String = DadosOperador.conteudo

	# Consulta as atividades de Física da série selecionada.
	var dados_ano: Dictionary = BancoMaterias.fisica.get(
		ano_selecionado,
		{}
	)

	var atividades: Dictionary = dados_ano.get(
		"atividades",
		{}
	)

	# Verifica se o Puzzle de Frenagem está cadastrado
	# e disponível para a série selecionada.
	var puzzle: Dictionary = atividades.get(
		"puzzle_frenagem",
		{}
	)

	var disponivel: bool = puzzle.get(
		"disponivel",
		false
	)

	# Controla a visibilidade do botão.
	botao_trilho.visible = disponivel


func _voltar():
	botao_voltar.disabled = true

	get_tree().change_scene_to_file(
		"res://Cenas/computador.tscn"
	)


func _abrir_trilho():
	# Confere novamente antes de permitir o acesso.
	_atualizar_atividades()

	if not botao_trilho.visible:
		return

	get_tree().change_scene_to_file(
		"res://Cenas/cenas de fisica/PuzzleFrenagem.tscn"
	)


func _on_botao_trilho_mouse_entered() -> void:
	luz.energy = 1.0


func _on_botao_trilho_mouse_exited() -> void:
	luz.energy = 0.0
