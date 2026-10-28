extends Area2D
class_name BichoPau

signal foi_comido(inseto)

# Gene do inseto: 0.0 (muito visível/verde) até 1.0 (perfeito graveto/marrom)
var fitness: float = 0.0

@onready var sprite: Sprite2D = $Sprite2D

func inicializar(valor_fitness: float) -> void:
	fitness = clamp(valor_fitness, 0.0, 1.0)
	
	# Modula a cor do sprite baseado no fitness:
	# fitness 0.0 = Verde chamativo / fitness 1.0 = Marrom graveto
	var cor_verde := Color(0.2, 0.9, 0.2)
	var cor_graveto := Color(0.45, 0.3, 0.15)
	sprite.modulate = cor_verde.lerp(cor_graveto, fitness)
	
	# Altera a escala para simular o formato (mais fino se for mais graveto)
	var largura := lerp(1.5, 0.4, fitness)
	var altura := lerp(0.8, 1.8, fitness)
	sprite.scale = Vector2(largura, altura)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	# Quando o jogador clica no inseto (pássaro comendo)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		foi_comido.emit(self)
		queue_free()
