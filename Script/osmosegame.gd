extends Control

@onready var hemacia: TextureRect = $AreaExperimento/Hemacia

@onready var feedback_panel: Panel = $FeedbackPanel
@onready var feedback_titulo: Label = $FeedbackPanel/FeedbackTitulo
@onready var feedback_texto: Label = $FeedbackPanel/FeedbackTexto

@onready var questao_panel: Panel = $QuestaoPanel
@onready var resultado: Label = $QuestaoPanel/Resultado


# VARIÁVEIS DO EXPERIMENTO
var hipotonico_realizado := false
var isotonico_realizado := false
var hipertonico_realizado := false

# VARIÁVEIS DA QUESTÃO
var tentativas := 0
var questao_concluida := false


func _ready() -> void:
	feedback_panel.hide()
	questao_panel.hide()
	hemacia.pivot_offset = hemacia.size / 2.0
	

func _on_hipotonico_pressed() -> void:
	# Volta ao tamanho normal antes do experimento
	hemacia.scale = Vector2.ONE

	var tween := create_tween()

	tween.tween_property(
		hemacia,
		"scale",
		Vector2(1.7, 1.7),
		2.0
	)

	await tween.finished

	hipotonico_realizado = true

	mostrar_feedback(
		"MEIO HIPOTÔNICO",
		"A água entrou na hemácia por osmose. O aumento do volume pode provocar lise celular."
	)


func mostrar_feedback(titulo: String, texto: String) -> void:
	feedback_titulo.text = titulo
	feedback_texto.text = texto
	feedback_panel.show()


func _on_continuar_pressed() -> void:
	feedback_panel.hide()
	hemacia.scale = Vector2.ONE

	if hipotonico_realizado and isotonico_realizado and hipertonico_realizado:
		experimentos_concluidos()

func experimentos_concluidos() -> void:
	$instrucao.text = "Agora responda à questão."

	$AreaExperimento.hide()
	questao_panel.show()

	$AreaExperimento/Hipotonico.disabled = true
	$AreaExperimento/Isotonico.disabled = true
	$AreaExperimento/Hipertonico.disabled = true


func _on_isotonico_pressed() -> void:
	hemacia.scale = Vector2.ONE

	var tween := create_tween()

	tween.tween_property(
		hemacia,
		"scale",
		Vector2(1.08, 1.08),
		0.4
	)

	tween.tween_property(
		hemacia,
		"scale",
		Vector2.ONE,
		0.4
	)

	await tween.finished

	mostrar_feedback(
		"MEIO ISOTÔNICO",
		"A entrada e a saída de água permanecem equilibradas. A hemácia mantém aproximadamente o seu volume."
	 )


func _on_hipertonico_pressed() -> void:
	print("HIPERTÔNICO CLICADO")

	hemacia.scale = Vector2.ONE

	var tween := create_tween()

	tween.tween_property(
		hemacia,
		"scale",
		Vector2(0.60, 0.60),
		2.0
	)

	await tween.finished

	hipertonico_realizado = true

	mostrar_feedback(
		"MEIO HIPERTÔNICO",
		"A hemácia perde água por osmose e diminui de volume."
	)


func _on_alternativa_a_pressed() -> void:
	if questao_concluida:
		return

	tentativas += 1
	questao_concluida = true
	
	resultado.text = "Incorreto. No meio hipotônico, a água entra na hemácia por osmose"


func _on_alternativa_b_pressed() -> void:
	resultado.text = "✓ Correto! A água entra na hemácia por osmose, aumentando seu volume e podendo provocar lise celular."

func _on_alternativa_c_pressed() -> void:
	resultado.text = "Incorreto. A alteração observada ocorre principalmente pelo movimento de água por osmose."


func _on_alternativa_d_pressed() -> void:
	resultado.text = "Incorreto. O fenômeno observado envolve o movimento de água através da membrana."
	
	
	
