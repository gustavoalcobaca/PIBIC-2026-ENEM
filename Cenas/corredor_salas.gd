extends Control

@onready var anim = $AnimationPlayer


func _ready():

	anim.play("entrada")

	await anim.animation_finished

	await get_tree().create_timer(0.5).timeout

	#anim.play("saida")

	#await anim.animation_finished

	match DadosOperador.sala_destino:

		"fisica":
			get_tree().change_scene_to_file("res://Cenas/sala_de_fisica.tscn")
			print("fisica")

		"quimica":
			get_tree().change_scene_to_file("res://Cenas/sala_de_quimica.tscn")
			print("quimica")

		"biologia":
			get_tree().change_scene_to_file("res://Cenas/sala_de_biologia.tscn")
