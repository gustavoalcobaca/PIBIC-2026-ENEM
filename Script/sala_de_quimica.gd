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
@onready var experimento = $ExperimentoUI/Experimento

@onready var resultado = $ExperimentoUI/AlternativasUI/Resultado
@onready var botao_recomecar = $ExperimentoUI/AlternativasUI/BotaoRecomecar

@onready var alternativas_ui = $ExperimentoUI/AlternativasUI
@onready var lista_alternativas = $ExperimentoUI/AlternativasUI/ListaAlternativas

@onready var botao_agitar = $ExperimentoUI/BotaoAgitar
@onready var botao_lentamente = $ExperimentoUI/BotaoLentamente
@onready var status_experimentos = $ExperimentoUI/StatusExperimentos

# ==================================================
# CONTROLE DO EXPERIMENTO
# ==================================================

var agitou := false
var lentamente := false

# ==================================================
# CONTROLE DE IMAGEM DE TRASIÇÃO DO EXPERIMENTO
# ==================================================
var imagens = [
	preload("res://Assets/experimento inicial.png"),
	preload("res://Assets/experimento agitar.png"),
	preload("res://Assets/experimento adicionar.png"),
	preload("res://Assets/experimento final.png")
]

# ==================================================
# CONTROLE DE IMAGEM DE TRASIÇÃO DO EXPERIMENTO
# ==================================================

func atualizar_experimento():

	if agitou and lentamente:
		experimento.texture = imagens[3]

	elif agitou:
		experimento.texture = imagens[1]

	elif lentamente:
		experimento.texture = imagens[2]

	else:
		experimento.texture = imagens[0]

# ==================================================
# CONTROLE DOS BOTÕES DE EXPERIMENTOS
# ==================================================

func _agitar():

	if agitou:
		return

	agitou = true

	print("Experimento 1: AGITAR")

	atualizar_experimento()
	atualizar_status()

func _adicionar_lentamente():

	if lentamente:
		return

	lentamente = true

	print("Experimento 2: ADICIONAR LENTAMENTE")

	atualizar_experimento()
	atualizar_status()
	
	
# ==================================================
# ALTERNATIVAS
# ==================================================

var alternativas = [
	"A) solubilidade e densidade.",
	"B) densidade e viscosidade.",
	"C) viscosidade e solubilidade.",
	"D) miscibilidade e viscosidade.",
	"E) solubilidade e miscibilidade."
]

var resposta_correta := 0

# Configura a reposta correta do sistema de alternativas 
func criar_alternativas():

	for i in range(alternativas.size()):

		var botao := Button.new()

		botao.text = alternativas[i]

		botao.pressed.connect(_responder.bind(i))

		lista_alternativas.add_child(botao)
	

func _responder(indice:int):

	if indice == resposta_correta:

		resultado.text = "Resposta correta! Experimento concluído."
		resultado.visible = true

		# Esconde as alternativas
		lista_alternativas.visible = false

	else:

		resultado.text = "Resposta incorreta. Tente novamente."
		resultado.visible = true

		botao_recomecar.visible = true
func _ready():
	
	# Botão voltar 
	botao_voltar.pressed.connect(_voltar)
	
	# Configuração dos botões da questão
	botao_iniciar.pressed.connect(_iniciar_questao)
	botao_cancelar.pressed.connect(_cancelar_questao)
	
	botao_agitar.pressed.connect(_agitar)
	botao_lentamente.pressed.connect(_adicionar_lentamente)

	# Return caso erar questão
	resultado.visible = false
	botao_recomecar.visible = false
	botao_recomecar.pressed.connect(_recomecar)

	criar_alternativas()

	# A questão começa escondida.
	questao_ui.visible = false

	# O experimento também começa escondido.
	experimento_ui.visible = false
	
	# A luz de objetos
	luz.energy = 0.0
	
	# Visibilidade das alternativas
	alternativas_ui.visible = false
	
	



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

	# Reseta o experimento

	agitou = false
	lentamente = false

	alternativas_ui.visible = false

	atualizar_experimento()
	atualizar_status()

# ==================================================
# CANCELAR QUESTÃO
# ==================================================

func _cancelar_questao():

	questao_ui.visible = false


# ==================================================
# SISTEMA DE RETORNO 
# ==================================================

func _recomecar():

	resultado.visible = false
	botao_recomecar.visible = false

	lista_alternativas.visible = true

	agitou = false
	lentamente = false

	atualizar_experimento()
	atualizar_status()

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
# ATULIZAÇÃO DE STATUS DE ATIVIDADE
# ==================================================
func atualizar_status():

	var feitos := 0

	if agitou:
		feitos += 1

	if lentamente:
		feitos += 1

	status_experimentos.text = "Experimentos: " + str(feitos) + "/2"
	
	if feitos == 2:
		alternativas_ui.visible = true
