
extends Control

# ==========================================
# CONFIGURAÇÃO DOS PARÂMETROS DO EXPERIMENTO
# ==========================================

@export_group("Velocidade")
@export var velocidade_inicial: float = 72.0
@export var velocidade_minima: float = 36.0
@export var velocidade_maxima: float = 108.0
@export var passo_velocidade: float = 5.0

@export_group("Tempo de reação")
@export var tempo_inicial: float = 0.5
@export var tempo_minimo: float = 0.0
@export var tempo_maximo: float = 2.0
@export var passo_tempo: float = 0.1

@export_group("Desaceleração")
@export var desaceleracao_inicial: float = 5.0
@export var desaceleracao_minima: float = 1.0
@export var desaceleracao_maxima: float = 10.0
@export var passo_desaceleracao: float = 0.5

@export_group("Régua visual")
@export var distancia_maxima_visual: float = 50.0
@export_range(0.0, 1.0) var inicio_regua_x: float = 0.08
@export_range(0.0, 1.0) var fim_regua_x: float = 0.93
@export_range(0.0, 1.0) var regua_y: float = 0.685

@export_group("Resposta")
@export var tolerancia_resposta: float = 0.1

# ==========================================
# REFERÊNCIAS AOS NÓS
# ==========================================

@onready var imagem_trilho: TextureRect = \
	get_node("ImagemTrilho")

@onready var area_imagem: Control = \
	get_node("WindowPanel/LayoutPrincipal/AreaImagem")

@onready var label_velocidade: Label = \
	get_node("WindowPanel/LayoutPrincipal/AreaImagem/ControleVelocidade/LinhaVelocidade/LabelVelocidade")

@onready var label_tempo: Label = \
	get_node("WindowPanel/LayoutPrincipal/AreaImagem/ControleTempo/LinhaTempo/LabelTempo")

@onready var label_desaceleracao: Label = \
	get_node("WindowPanel/LayoutPrincipal/AreaImagem/ControleDesaceleracao/LinhaDesaceleracao/LabelDesaceleracao")

@onready var marcador_x: Label = \
	get_node("WindowPanel/LayoutPrincipal/AreaImagem/MarcadorX")

@onready var campo_resposta: LineEdit = \
	get_node("WindowPanel/LayoutPrincipal/CampoResposta")

@onready var feedback_label: Label = \
	get_node("WindowPanel/LayoutPrincipal/FeedbackLabel")

@onready var btn_menos_vel: Button = \
	get_node("WindowPanel/LayoutPrincipal/AreaImagem/ControleVelocidade/LinhaVelocidade/BtnMenosVel")

@onready var btn_mais_vel: Button = \
	get_node("WindowPanel/LayoutPrincipal/AreaImagem/ControleVelocidade/LinhaVelocidade/BtnMaisVel")

@onready var btn_menos_tempo: Button = \
	get_node("WindowPanel/LayoutPrincipal/AreaImagem/ControleTempo/LinhaTempo/BtnMenosTempo")

@onready var btn_mais_tempo: Button = \
	get_node("WindowPanel/LayoutPrincipal/AreaImagem/ControleTempo/LinhaTempo/BtnMaisTempo")

@onready var btn_menos_desc: Button = \
	get_node("WindowPanel/LayoutPrincipal/AreaImagem/ControleDesaceleracao/LinhaDesaceleracao/BtnMenosDesc")

@onready var btn_mais_desc: Button = \
	get_node("WindowPanel/LayoutPrincipal/AreaImagem/ControleDesaceleracao/LinhaDesaceleracao/BtnMaisDesc")

@onready var btn_confirmar: Button = \
	get_node("WindowPanel/LayoutPrincipal/BtnConfirmar")

# ==========================================
# ESTADO DO EXPERIMENTO
# ==========================================

var velocidade_kmh: float
var tempo_reacao: float
var desaceleracao: float

var distancia_reacao: float = 0.0
var distancia_frenagem: float = 0.0
var distancia_total: float = 0.0

var resposta_confirmada: bool = false


func _ready() -> void:
	# Inicializa os valores.
	velocidade_kmh = velocidade_inicial
	tempo_reacao = tempo_inicial
	desaceleracao = desaceleracao_inicial

	# Conecta os botões.
	btn_menos_vel.pressed.connect(
		_alterar_velocidade.bind(-1)
	)
	btn_mais_vel.pressed.connect(
		_alterar_velocidade.bind(1)
	)

	btn_menos_tempo.pressed.connect(
		_alterar_tempo.bind(-1)
	)
	btn_mais_tempo.pressed.connect(
		_alterar_tempo.bind(1)
	)

	btn_menos_desc.pressed.connect(
		_alterar_desaceleracao.bind(-1)
	)
	btn_mais_desc.pressed.connect(
		_alterar_desaceleracao.bind(1)
	)

	btn_confirmar.pressed.connect(_confirmar_resposta)

	# Permite responder pressionando Enter.
	campo_resposta.text_submitted.connect(
		_ao_pressionar_enter
	)

	marcador_x.text = "X"
	feedback_label.text = "Configure o experimento e calcule a distância total."

	_atualizar_experimento()


# ==========================================
# CONTROLES DE VELOCIDADE
# ==========================================

func _alterar_velocidade(direcao: int) -> void:
	velocidade_kmh = clampf(
		velocidade_kmh + passo_velocidade * direcao,
		velocidade_minima,
		velocidade_maxima
	)

	_atualizar_experimento()


# ==========================================
# CONTROLES DE TEMPO
# ==========================================

func _alterar_tempo(direcao: int) -> void:
	tempo_reacao = clampf(
		tempo_reacao + passo_tempo * direcao,
		tempo_minimo,
		tempo_maximo
	)

	_atualizar_experimento()


# ==========================================
# CONTROLES DE DESACELERAÇÃO
# ==========================================

func _alterar_desaceleracao(direcao: int) -> void:
	desaceleracao = clampf(
		desaceleracao + passo_desaceleracao * direcao,
		desaceleracao_minima,
		desaceleracao_maxima
	)

	_atualizar_experimento()


# ==========================================
# FÍSICA E ATUALIZAÇÃO VISUAL
# ==========================================

func _atualizar_experimento() -> void:
	# Converte km/h para m/s.
	var velocidade_ms: float = velocidade_kmh / 3.6

	# Calcula as distâncias.
	distancia_reacao = velocidade_ms * tempo_reacao

	distancia_frenagem = (
		velocidade_ms * velocidade_ms
		/ (2.0 * desaceleracao)
	)

	distancia_total = distancia_reacao + distancia_frenagem

	# Atualiza os valores mostrados na interface.
	label_velocidade.text = (
		"%d km/h" % int(round(velocidade_kmh))
	)

	label_tempo.text = (
		"%s s" % _decimal(tempo_reacao, 1)
	)

	label_desaceleracao.text = (
		"%s m/s²" % _decimal(desaceleracao, 1)
	)

	# Atualiza o marcador na régua.
	_atualizar_marcador()

	# Uma alteração nos parâmetros exige nova resposta.
	resposta_confirmada = false
	feedback_label.text = (
        "Parâmetros atualizados. Calcule o valor de X."
	)



func _atualizar_marcador() -> void:
	if distancia_maxima_visual <= 0.0:
		return
	var proporcao: float = clampf(
		distancia_total / distancia_maxima_visual,
		0.0,
		1.0
		)

	var proporcao_x: float = lerpf(
		inicio_regua_x,
		fim_regua_x,
		proporcao
)

	# Coordenada do ponto sobre a imagem do trilho.
	var ponto_local := Vector2(
		imagem_trilho.size.x * proporcao_x,
		imagem_trilho.size.y * regua_y
)

	# Converte para coordenadas globais da interface.
	var ponto_global: Vector2 = (
		imagem_trilho.get_global_transform_with_canvas()
		* ponto_local
		)

	# Converte para o sistema de coordenadas do pai do marcador.
	var pai_marcador := marcador_x.get_parent() as Control

	if pai_marcador == null:
		push_warning("O pai de MarcadorX precisa ser um Control.")
		return

	var ponto_pai: Vector2 = (
	pai_marcador.get_global_transform_with_canvas()
	.affine_inverse()
	* ponto_global
	)

	marcador_x.position = ponto_pai - marcador_x.size / 2.0


# ==========================================
# VALIDAÇÃO DA RESPOSTA
# ==========================================

func _confirmar_resposta() -> void:
	var texto: String = campo_resposta.text.strip_edges()
	texto = texto.replace(",", ".")

	if texto.is_empty() or not texto.is_valid_float():
		feedback_label.text = (
            "Digite uma distância válida em metros."
		)
		return

	var resposta: float = texto.to_float()

	if resposta < 0.0:
		feedback_label.text = (
            "A distância não pode ser negativa."
		)
		return

	resposta_confirmada = true

	if absf(resposta - distancia_total) <= tolerancia_resposta:
		feedback_label.text = (
            "CORRETO! Distância total: %s m."
			% _decimal(distancia_total, 2)
		)
	else:
		feedback_label.text = (
            "Ainda não. Considere a distância de reação "
			+ "e a distância de frenagem."
		)


func _ao_pressionar_enter(_texto: String) -> void:
	_confirmar_resposta()


# ==========================================
# FORMATAÇÃO NUMÉRICA
# ==========================================

func _decimal(valor: float, casas: int) -> String:
	if casas == 1:
		return ("%.1f" % valor).replace(".", ",")

	return ("%.2f" % valor).replace(".", ",")
