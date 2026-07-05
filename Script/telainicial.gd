extends Control

@onready var botao = $BotaoComputador
@onready var anim = $AnimationPlayer

func _ready():
	print("Cena carregada")
	botao.pressed.connect(_entrar_no_pc)

func _entrar_no_pc():
	print("Botão clicado")
	botao.disabled = true
	anim.play("entrar_pc")

	await anim.animation_finished

	print("Mudando de cena")

	get_tree().change_scene_to_file("res://Cenas/computador.tscn")
