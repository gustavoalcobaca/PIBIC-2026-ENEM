extends Control

@onready var terminal = $Boot/Terminal
@onready var logo = $Boot/Logo
@onready var clique = $Boot/Clique
@onready var botao_voltar = $BotaoVoltar
@onready var anim = $AnimationPlayer
@onready var nome_input = $Boot/NomeOperador


var esperando_nome := false
var nome_operador := ""
var boot_finalizado := false
var serie := ""
var serie_escolhida := false


func _ready():
	
	terminal.bbcode_enabled = true
	
	$Desktop.visible = false
	$Boot/EscolhaSerie.visible = false
	
	nome_input.visible = false
	
	logo.visible = true
	terminal.visible = false
	
	clique.visible = true
	clique.text = ">> Pressione qualquer botão para iniciar"

	botao_voltar.pressed.connect(_voltar)
	
func _input(event):

	if event is InputEventMouseButton and event.pressed:

		if !terminal.visible:

			clique.visible = false
			logo.visible = false
			terminal.visible = true

			await boot()

		elif boot_finalizado:

			$Boot.visible = false
			$Desktop.visible = true

	elif event.is_action_pressed("ui_accept") and boot_finalizado:

		$Boot.visible = false
		$Desktop.visible = true
	
func _voltar():
	botao_voltar.disabled = true

	anim.play("sair_pc")

	await anim.animation_finished

	get_tree().change_scene_to_file("res://Cenas/telainicial.tscn")

func escrever_linha(texto: String, tempo: float = 3.0):
	terminal.append_text(texto + "\n")

	# Espera um frame para o RichTextLabel atualizar
	await get_tree().process_frame
	
	terminal.scroll_to_line(terminal.get_line_count() - 1)
	
	await get_tree().create_timer(tempo).timeout
	
func ok(tempo: float = 0.5):
	await escrever_linha("[color=#00FF66]OK[/color]", tempo)

func erro(tempo: float = 0.7):
	await escrever_linha("[color=#FF3B30]ERRO[/color]", tempo)

func falha(tempo: float = 0.9):
	await escrever_linha("[color=#FFA500]FALHA[/color]", tempo)

func aviso(texto: String, tempo: float = 1.0):
	await escrever_linha("[color=#FFD700]" + texto + "[/color]", tempo)

func info(texto: String, tempo: float = 1.0):
	await escrever_linha("[color=#00FF66]" + texto + "[/color]", tempo)

func sistema(texto: String, tempo: float = 1.0):
	await escrever_linha("[color=#00FF66]" + texto + "[/color]", tempo)

func comando(texto: String, tempo: float = 3.0):
	await escrever_linha("[color=#D0D0D0]" + texto + "[/color]", tempo)
	
	
func _on_nome_operador_text_submitted(texto: String):

	texto = texto.strip_edges()

	if texto.is_empty():

		nome_input.visible = false

		await erro()
		await comando("> Nome do operador inválido.")
		await aviso("> Digite um nome para continuar.")
		await escrever_linha("")
		await escrever_linha("")

		nome_input.clear()
		nome_input.visible = true
		nome_input.grab_focus()

		return

	nome_operador = texto
	nome_input.visible = false

	await comando("> Registrando operador...")
	await ok(0.5)
	await comando("> Operador registrado com sucesso.")
	await info("> Bem-vindo, " + nome_operador + ".")

	clique.text = ">> Clique para continuar <<"
	clique.visible = true

	boot_finalizado = true
	
	$Boot/EscolhaSerie.visible = true
	
func boot():

	terminal.clear()

	await sistema("ECOS v2.4", 0.7)
	await escrever_linha("")

	await comando("> Inicializando sistema...")
	await ok(0.4)

	await comando("> Carregando módulo Física...")
	await ok()

	await comando("> Carregando módulo Química...")
	await ok()

	await comando("> Carregando módulo Biologia...")
	await ok()

	await comando("> Verificando arquivos...")
	await ok()

	await comando("> Arquivo corrompido encontrado...")
	await erro()

	await comando("> Tentando restaurar...")
	await falha()

	await comando("> Aguardando operador...")
	await escrever_linha("")
	await escrever_linha("")
	

	
	nome_input.visible = true
	nome_input.clear()
	nome_input.grab_focus()

	clique.text = ">> Aguardando entrada do usuário... <<"
	clique.visible = true


func _on_1ano_pressed():
	serie = "1º Ano"
	$Boot/EscolhaSerie.visible = false # Replace with function body.

func _on_2ano_pressed():
	serie = "2º Ano"
	$Boot/EscolhaSerie.visible = false # Replace with function body.

func _on_3ano_pressed():
	serie = "3º Ano"
	$Boot/EscolhaSerie.visible = false # Replace with function body.
