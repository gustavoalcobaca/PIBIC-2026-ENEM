extends Control

@onready var botao_voltar = $BotaoVoltar
@onready var botao_trilho = $BotaoTrilho
@onready var luz = $BotaoTrilho/PointLight2D
func _ready():
	botao_voltar.pressed.connect(_voltar)
	botao_trilho.pressed.connect(_abrir_trilho)

func _voltar():
	botao_voltar.disabled = true

#anim.play("sair_pc")

#await anim.animation_finished

	get_tree().change_scene_to_file("res://Cenas/computador.tscn") 

func _abrir_trilho():
	get_tree().change_scene_to_file("res://Cenas/PuzzleFrenagem.tscn")
	# abrir PuzzleFrenagem
# Controla a liminosidade do objeto


func _on_botao_trilho_mouse_entered() -> void:
	luz.energy = 1.0


func _on_botao_trilho_mouse_exited() -> void:
	luz.energy = 0.0
