
extends Control

@onready var microscopio: TextureRect = $Microscopio
@onready var amostra_sangue: TextureRect = $Amostra_sangue
@onready var hemacia: TextureRect = $Hemacia

@onready var explicacao: Label = $"Explicação"

@onready var botao_ampliar: Button = $Ampliar
@onready var botao_hipotonico: Button = $Hipotonico
@onready var botao_isotonico: Button = $Isotonico
@onready var botao_hipertonico: Button = $Hipertonico

@onready var feedback_panel: Panel = $FeedbackPanel
@onready var feedback_titulo: Label = $FeedbackPanel/FeedbackTitulo
@onready var feedback_texto: Label = $FeedbackPanel/FeedbackTexto
@onready var botao_Continuar: Button = $FeedbackPanel/Continuar

@onready var revisao_panel: Panel = $RevisaoPanel
@onready var titulo_revisao: Label = $RevisaoPanel/TituloRevisao
@onready var enunciado: Label = $RevisaoPanel/Enunciado

@onready var alternativa_a: Button = $RevisaoPanel/AlternativaA
@onready var alternativa_b: Button = $RevisaoPanel/AlternativaB
@onready var alternativa_c: Button = $RevisaoPanel/AlternativaC
@onready var alternativa_d: Button = $RevisaoPanel/AlternativaD

@onready var feedback_revisao: Label = $RevisaoPanel/FeedbackRevisao


# Controle dos experimentos
var hipotonico_realizado := false
var isotonico_realizado := false
var hipertonico_realizado := false

var experimento_em_andamento := false

# Controla a transição para a revisão
var aguardando_inicio_revisao := false


func _ready() -> void:
	# Estado inicial das imagens
	microscopio.show()
	amostra_sangue.hide()
	hemacia.hide()

	# Estado inicial dos botões
	botao_hipotonico.hide()
	botao_isotonico.hide()
	botao_hipertonico.hide()

	# Estado inicial dos painéis
	feedback_panel.hide()
	revisao_panel.hide()

	# Texto inicial
	explicacao.text = "A amostra de sangue será estudada ao microscópio\npara observar o comportamento das hemácias\nem diferentes meios osmóticos.\nClique em AMPLIAR."

	# Conexões
	botao_ampliar.pressed.connect(_ampliar_amostra)
	botao_Continuar.pressed.connect(_on_continuar_pressed)


func _ampliar_amostra() -> void:
	microscopio.show()
	amostra_sangue.show()
	hemacia.show()

	botao_ampliar.hide()

	# Libera os experimentos
	botao_hipotonico.show()
	botao_isotonico.show()
	botao_hipertonico.show()

	explicacao.show()
	explicacao.text = "Observe as hemácias presentes na amostra de sangue.\nUma delas está destacada para acompanhar\nas alterações provocadas pelos diferentes meios osmóticos."


# EXPERIMENTO ISOTÔNICO
func _on_isotonico_pressed() -> void:
	if experimento_em_andamento:
		return

	explicacao.hide()
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


# EXPERIMENTO HIPERTÔNICO
func _on_hipertonico_pressed() -> void:
	if experimento_em_andamento:
		return

	explicacao.hide()
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


# EXPERIMENTO HIPOTÔNICO
func _on_hipotonico_pressed() -> void:
	if experimento_em_andamento:
		return

	explicacao.hide()
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


# BOTÃO CONTINUAR
func _on_continuar_pressed() -> void:
	feedback_panel.hide()

	# Transição para a revisão
	if aguardando_inicio_revisao:
		aguardando_inicio_revisao = false

		preparar_revisao()
		revisao_panel.show()
		return

	# Restaura a hemácia
	hemacia.scale = Vector2.ONE

	experimento_em_andamento = false

	# Verifica se todos os experimentos foram concluídos
	if hipotonico_realizado and isotonico_realizado and hipertonico_realizado:
		experimentos_concluidos()
		return

	# Libera somente os experimentos ainda não realizados
	botao_hipotonico.disabled = hipotonico_realizado
	botao_isotonico.disabled = isotonico_realizado
	botao_hipertonico.disabled = hipertonico_realizado


# CONCLUSÃO DOS EXPERIMENTOS
func experimentos_concluidos() -> void:
	botao_hipotonico.hide()
	botao_isotonico.hide()
	botao_hipertonico.hide()
	botao_ampliar.hide()

	experimento_em_andamento = true
	aguardando_inicio_revisao = true

	feedback_titulo.text = "EXPERIMENTOS CONCLUÍDOS"

	feedback_texto.text = "Os três experimentos foram concluídos!\nAgora vamos revisar o que você aprendeu."

	feedback_panel.show()


# PREPARAÇÃO DA QUESTÃO
func preparar_revisao() -> void:
	titulo_revisao.text = "REVISÃO — OSMOSE"

	enunciado.text = "Uma amostra de sangue foi submetida a três soluções com concentrações diferentes. Durante o experimento, foram observadas alterações no volume das hemácias. Considerando os resultados observados, qual afirmação está correta?"

	alternativa_a.text = "A) No meio hipotônico, a hemácia perde água e diminui de volume."

	alternativa_b.text = "B) No meio isotônico, a entrada e a saída de água permanecem equilibradas, mantendo o volume da hemácia aproximadamente constante."

	alternativa_c.text = "C) No meio hipertônico, a água entra na hemácia, provocando seu aumento de volume."

	alternativa_d.text = "D) Nos três meios, a hemácia mantém o mesmo volume, pois sua membrana impede a passagem de água."

	feedback_revisao.text = ""
