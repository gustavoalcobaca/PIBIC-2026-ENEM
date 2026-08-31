extends Control

# ==================================================
# REFERÊNCIAS
# ==================================================

@onready var botao_voltar = $BotaoVoltar
@onready var papel = $Papel

@onready var questao_ui = $QuestoesUI
@onready var experimento_ui = $ExperimentoUI

@onready var botao_iniciar = $QuestoesUI/Iniciar
@onready var botao_cancelar = $QuestoesUI/Cancelar

@onready var titulo = $QuestoesUI/Titulo
@onready var enunciado = $QuestoesUI/Enunciado

@onready var luz = $Papel/PointLight2D

@onready var botao_agitar = $ExperimentoUI/BotaoAgitar
@onready var botao_lentamente = $ExperimentoUI/BotaoLentamente
@onready var status_experimentos = $ExperimentoUI/StatusExperimentos

# ==================================================
# CONTROLE DO EXPERIMENTO
# ==================================================

var experimento_agitar_feito := false
var experimento_lento_feito := false

# ==================================================
# INICIALIZAÇÃO
# ==================================================

func _ready():

	botao_voltar.pressed.connect(_voltar)

	botao_iniciar.pressed.connect(_iniciar_questao)
	botao_cancelar.pressed.connect(_cancelar_questao)
	
	botao_agitar.pressed.connect(_agitar)
	botao_lentamente.pressed.connect(_adicionar_lentamente)
	
	# A questão começa escondida.
	questao_ui.visible = false

	# O experimento também começa escondido.
	experimento_ui.visible = false
	
	# A luz de objetos
	luz.energy = 0.0


# ==================================================
# BOTÃO VOLTAR
# ==================================================

func _voltar():

	botao_voltar.disabled = true

	get_tree().change_scene_to_file("res://Cenas/computador.tscn")

# ==================================================
# PAPEL / QUESTÃO
# ==================================================

func _abrir_questao():

	questao_ui.visible = true

# ==================================================
# INICIAR QUESTÃO
# ==================================================

func _iniciar_questao():

	print("Questão iniciada")

	questao_ui.visible = false
	experimento_ui.visible = true

# ==================================================
# CANCELAR QUESTÃO
# ==================================================

func _cancelar_questao():

	questao_ui.visible = false

# ==================================================
# BOTÃO DO PAPEL
# ==================================================

func _on_papel_pressed() -> void:

	_abrir_questao()
	
# Controla a liminosidade do objeto
func _on_papel_mouse_entered() -> void:
	luz.energy = 1.0

func _on_papel_mouse_exited() -> void:
	luz.energy = 0.0
	
# ==================================================
# BOTÃO AGITAR
# ==================================================
func _agitar():

	if experimento_agitar_feito:
		return

	experimento_agitar_feito = true

	print("Experimento 1: AGITAR")

	atualizar_status()
	
# ==================================================
# BOTÃO ADICINAR LENTAMENTE
# ==================================================
func _adicionar_lentamente():

	if experimento_lento_feito:
		return

	experimento_lento_feito = true

	print("Experimento 2: ADICIONAR LENTAMENTE")

	atualizar_status()
	
# ==================================================
# ATULIZAÇÃO DE STATUS DE ATIVIDADE
# ==================================================
func atualizar_status():

	var feitos := 0

	if experimento_agitar_feito:
		feitos += 1

	if experimento_lento_feito:
		feitos += 1

	status_experimentos.text = "Experimentos: " + str(feitos) + "/2"
