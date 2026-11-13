extends Control

@onready var Botao_voltar = $BotaoVoltar
@onready var luz = $Botaomicroscopio/PointLight2D
@onready var Botao_microscopio = $Botaomicroscopio

func _ready():
	Botao_voltar.pressed.connect(_voltar)
	Botao_microscopio.pressed.connect(_microscopio)
	
func _voltar():
	Botao_voltar.disabled = true

	#anim.play("sair_pc")

	#await anim.animation_finished

	get_tree().change_scene_to_file("res://Cenas/computador.tscn")

func _microscopio():
	get_tree().change_scene_to_file("res://Cenas/cenas de biologia/questão_biologia_1_ano1.tscn")


func _on_botaomicroscopio_mouse_entered() -> void:
	luz.energy = 1.0


func _on_botaomicroscopio_mouse_exited() -> void:
	luz.energy = 0.0
