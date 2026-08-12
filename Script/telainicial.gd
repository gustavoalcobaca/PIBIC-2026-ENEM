extends Control

@onready var botao_computador = $BotaoComputador
@onready var anim = $AnimationPlayer
@onready var clique = $Clique


func _ready():
	print("Cena carregada")
	botao_computador.pressed.connect(_entrar_no_pc)
	clique.visible = false

func _porta_sala():

	if !DadosOperador.cadastro_concluido:
		clique.text = ">> Faça o cadastro no computador."
		clique.visible = true

		await get_tree().create_timer(2.0).timeout

		clique.visible = false
		return

	

func _entrar_no_pc():
	print("Botão clicado")
	botao_computador.disabled = true
	anim.play("entrar_pc")

	await anim.animation_finished

	print("Mudando de cena")
	get_tree().change_scene_to_file("res://Cenas/computador.tscn")
