extends Control

@onready var microscopio: TextureRect = $Microscopio
@onready var amostra_sangue: TextureRect = $Amostra_sangue
@onready var hemacia: TextureRect = $Hemacia

@onready var explicacao: Label = $"Explicação"

@onready var botao_ampliar: Button = $Ampliar
@onready var botao_hipotonico: Button = $"Hipotonico"
@onready var botao_isotonico: Button = $Isotonico
@onready var botao_hipertonico: Button = $Hipertonico

@onready var feedback_panel: Panel = $FeedbackPanel
@onready var feedback_titulo: Label = $FeedbackPanel/FeedbackTitulo
@onready var feedback_texto: Label = $FeedbackPanel/FeedbackTexto
@onready var botao_Continuar: Button = $FeedbackPanel/Continuar

# Configura a animação das celula de acordo com o meio
var hipotonico_realizado := false
var isotonico_realizado := false
var hipertonico_realizado := false

var experimento_em_andamento := false

func _ready() -> void:
	# Estado inicial das imagens.
	microscopio.show()
	amostra_sangue.hide()
	hemacia.hide()

	# Estado inicial dos botões.
	botao_hipotonico.hide()
	botao_isotonico.hide()
	botao_hipertonico.hide()

	# Texto inicial.
	explicacao.text = "A amostra de sangue será estudada ao microscópio\npara observar o comportamento das hemácias\nem diferentes meios osmóticos.\nClique em AMPLIAR."
	
	# Conexões.
	botao_ampliar.pressed.connect(_ampliar_amostra)
	
	# Configuração do botão "continuar"
	feedback_panel.hide()
	botao_Continuar.pressed.connect(_on_continuar_pressed)


func _ampliar_amostra() -> void:
	microscopio.show()
	amostra_sangue.show()
	hemacia.show()

	botao_ampliar.hide()

	# Libera os experimentos.
	botao_hipotonico.show()
	botao_isotonico.show()
	botao_hipertonico.show()

	explicacao.text = "Observe as hemácias presentes na amostra de sangue.\nUma delas está destacada para acompanhar\nas alterações provocadas pelos diferentes meios osmóticos."


func _on_isotonico_pressed() -> void:
	if experimento_em_andamento:
		return

	experimento_em_andamento = true

	botao_hipotonico.disabled = true
	botao_isotonico.disabled = true
	botao_hipertonico.disabled = true

	hemacia.scale = Vector2.ONE

	var tween := create_tween()

	tween.tween_property(
		hemacia,
		"scale",
		Vector2(1.08, 1.08),
		0.5
	)

	tween.tween_property(
		hemacia,
		"scale",
		Vector2.ONE,
		0.5
	)

	await tween.finished

	isotonico_realizado = true

	feedback_titulo.text = "MEIO ISOTÔNICO"

	feedback_texto.text = "A entrada e a saída de água permanecem equilibradas. A hemácia mantém aproximadamente seu volume."

	feedback_panel.show()


func _on_hipertonico_pressed() -> void:
	if experimento_em_andamento:
		return

	experimento_em_andamento = true

	botao_hipotonico.disabled = true
	botao_isotonico.disabled = true
	botao_hipertonico.disabled = true

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

	feedback_titulo.text = "MEIO HIPERTÔNICO"

	feedback_texto.text = "A hemácia perde água por osmose e diminui de volume, podendo apresentar crenação."

	feedback_panel.show()


func _on_hipotonico_pressed() -> void:
	if experimento_em_andamento:
		return

	experimento_em_andamento = true

	botao_hipotonico.disabled = true
	botao_isotonico.disabled = true
	botao_hipertonico.disabled = true

	hemacia.pivot_offset = hemacia.size / 2.0
	hemacia.scale = Vector2.ONE

	var tween := create_tween()

	tween.tween_property(
		hemacia,
		"scale",
		Vector2(1.2, 1.2),
		2.0
	)

	await tween.finished

	hipotonico_realizado = true

	feedback_titulo.text = "MEIO HIPOTÔNICO"

	feedback_texto.text = "A água entrou na hemácia\npor osmose. O aumento\ndo volume pode provocar\nlise celular."

	feedback_panel.show()
	
func _on_continuar_pressed() -> void:

	feedback_panel.hide()

	hemacia.scale = Vector2.ONE

	experimento_em_andamento = false

	botao_hipotonico.disabled = hipotonico_realizado
	botao_isotonico.disabled = isotonico_realizado
	botao_hipertonico.disabled = hipertonico_realizado

	if hipotonico_realizado and isotonico_realizado and hipertonico_realizado:
		experimentos_concluidos()
		
func experimentos_concluidos() -> void:

	botao_hipotonico.hide()
	botao_isotonico.hide()
	botao_hipertonico.hide()

	explicacao.text = "Os três experimentos foram concluídos!\nAgora vamos revisar o que você aprendeu."

	print("TODOS OS EXPERIMENTOS CONCLUÍDOS")
