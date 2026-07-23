extends Control

@onready var botao_computador = $BotaoComputador
@onready var botao_porta = $Button_porta_sala
@onready var anim = $AnimationPlayer

func _ready():
	print("Cena carregada")
	botao_computador.pressed.connect(_entrar_no_pc)
	botao_porta.pressed.connect(_porta_sala)

func _porta_sala():
	print("Sair da sala")
	botao_porta.disabled = true
	get_tree().change_scene_to_file("res://Cenas/sala_de_fisica.tscn")

func _entrar_no_pc():
	print("Botão clicado")
	botao_computador.disabled = true
	anim.play("entrar_pc")

	await anim.animation_finished

	print("Mudando de cena")
	get_tree().change_scene_to_file("res://Cenas/computador.tscn")
