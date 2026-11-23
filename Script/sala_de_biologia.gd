
extends Control

@onready var Botao_voltar = $BotaoVoltar
@onready var luz = $Botaomicroscopio/PointLight2D
@onready var Botao_microscopio = $Botaomicroscopio


func _ready():
	Botao_voltar.pressed.connect(_voltar)
	Botao_microscopio.pressed.connect(_microscopio)

	_atualizar_atividades()


func _atualizar_atividades() -> void:
	var ano_selecionado: String = DadosOperador.conteudo

	# Consulta as atividades de Biologia da série selecionada.
	var dados_ano: Dictionary = BancoMaterias.biologia.get(
		ano_selecionado,
		{}
	)

	var atividades: Dictionary = dados_ano.get(
		"atividades",
		{}
	)

	# Verifica se Osmose e Hemácias está cadastrada e disponível.
	var osmose: Dictionary = atividades.get(
		"osmose_hemacias",
		{}
	)

	var disponivel: bool = osmose.get(
		"disponivel",
		false
	)

	Botao_microscopio.visible = disponivel


func _voltar():
	Botao_voltar.disabled = true

	get_tree().change_scene_to_file(
		"res://Cenas/computador.tscn"
	)


func _microscopio():
	# Confere novamente antes de permitir o acesso.
	_atualizar_atividades()

	if not Botao_microscopio.visible:
		return

	get_tree().change_scene_to_file(
		"res://Cenas/cenas de biologia/questão_biologia_1_ano1.tscn"
	)


func _on_botaomicroscopio_mouse_entered() -> void:
	luz.energy = 1.0


func _on_botaomicroscopio_mouse_exited() -> void:
	luz.energy = 0.0
