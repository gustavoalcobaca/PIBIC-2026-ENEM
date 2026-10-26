extends Node2D

# --- REFERÊNCIAS DOS NÓS ---
@onready var quiz_panel: Panel = $CanvasLayer/QuizPanel
@onready var question_label: Label = $CanvasLayer/QuizPanel/QuestionLabel
@onready var feedback_label: Label = $CanvasLayer/FeedbackLabel
@onready var restart_button: Button = $CanvasLayer/RestartButton

@onready var xenon: Node2D = $Xenon
@onready var xenon_shield_bar: ProgressBar = $Xenon/ShieldBar
@onready var fluor: Node2D = $Fluor
@onready var laser_line: Line2D = $LaserLine

# Botões das opções
@onready var btn_densidade: Button = %ButtonDensidade
@onready var btn_condutancia: Button = %ButtonCondutancia
@onready var btn_eletronegatividade: Button = %ButtonEletronegatividade
@onready var btn_estabilidade: Button = %ButtonEstabilidade
@onready var btn_ebulicao: Button = %ButtonEstabilidade
# --- VARIÁVEIS DE JOGO ---
var jogo_ativo: bool = false
var minigame_desbloqueado: bool = false

var resistencia_xenonio: float = 100.0
var max_resistencia: float = 100.0

# Flúor tem a maior eletronegatividade da Tabela Periódica (4.0 na escala Pauling)
var forca_eletronegatividade: float = 4.0 

func _ready() -> void:
	configurar_interface_inicial()
	conectar_sinais()

func configurar_interface_inicial() -> void:
	resistencia_xenonio = max_resistencia
	xenon_shield_bar.max_value = max_resistencia
	xenon_shield_bar.value = resistencia_xenonio
	
	quiz_panel.visible = true
	feedback_label.visible = false
	restart_button.visible = false
	laser_line.visible = false
	
	question_label.text = "Em 1962, conseguiu-se forçar o Xenônio a reagir com o Flúor.\nQual propriedade do Flúor justifica sua escolha?"
	
	jogo_ativo = false
	minigame_desbloqueado = false

func conectar_sinais() -> void:
	btn_densidade.pressed.connect(func(): _processar_resposta(false, "A Densidade não influencia a atração por elétrons."))
	btn_condutancia.pressed.connect(func(): _processar_resposta(false, "A Condutância elétrica não rompe a estabilidade do gás nobre."))
	btn_eletronegatividade.pressed.connect(func(): _processar_resposta(true, "CORRETO! A altíssima ELETRONEGATIVIDADE do Flúor (4.0) atrai os elétrons do Xenônio!"))
	btn_estabilidade.pressed.connect(func(): _processar_resposta(false, "A estabilidade nuclear diz respeito ao núcleo, não à camada de valência."))
	btn_ebulicao.pressed.connect(func(): _processar_resposta(false, "Ponto de ebulição é uma propriedade física, não reatividade química."))
	
	restart_button.pressed.connect(configurar_interface_inicial)

# --- FASE 1: QUIZ ---
func _processar_resposta(correta: bool, mensagem: String) -> void:
	feedback_label.visible = true
	feedback_label.text = mensagem
	
	if correta:
		feedback_label.modulate = Color.GREEN
		quiz_panel.visible = false
		minigame_desbloqueado = true
		feedback_label.text += "\n\n[SEGURE ESPAÇO / CLIQUE] para puxar os elétrons com a Força de Eletronegatividade!"
	else:
		feedback_label.modulate = Color.RED
		restart_button.visible = true

# --- FASE 2: MINIGAME DE ATRAÇÃO DE ELÉTRONS ---
func _process(delta: float) -> void:
	if not minigame_desbloqueado or resistencia_xenonio <= 0:
		return
		
	# Verifica se o jogador está pressionando o botão de ação (Espaço, Clique do mouse ou Toque)
	if Input.is_action_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_puxar_eletrons(delta)
	else:
		laser_line.visible = false

func _puxar_eletrons(delta: float) -> void:
	# Atualiza o raio visual de atração (Laser/Raio)
	laser_line.visible = true
	laser_line.clear_points()
	laser_line.add_point(fluor.global_position)
	laser_line.add_point(xenon.global_position)
	
	# Reduz a estabilidade do Xenônio proporcionalmente à Eletronegatividade do Flúor
	var dano = forca_eletronegatividade * 15.0 * delta
	resistencia_xenonio -= dano
	xenon_shield_bar.value = resistencia_xenonio
	
	# Efeito visual simples de tremor/vibração no Xenônio ao ser atacado
	xenon.position.x += randf_range(-1.0, 1.0)
	
	if resistencia_xenonio <= 0:
		_vitoria()

func _vitoria() -> void:
	laser_line.visible = false
	resistencia_xenonio = 0
	xenon_shield_bar.value = 0
	
	feedback_label.modulate = Color.GOLD
	feedback_label.text = "🎉 SUCESSO!\nVocê rompeu a camada de valência do Xenônio e formou o Difluoreto de Xenônio (XeF₂)!"
	restart_button.visible = true
