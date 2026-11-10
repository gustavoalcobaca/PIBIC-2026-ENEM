extends CharacterBody2D

# Força do Flúor baseada na propriedade periódica (Eletronegatividade)
var eletronegatividade: float = 4.0 # Valor real na escala Pauling (o maior da tabela!)
var forca_atracao: float = 50.0

func _process(delta: float) -> void:
	# Quando o jogador pressiona o botão de ação (ex: espaço ou clique)
	if Input.is_action_pressed("ui_accept"):
		puxar_eletrons(delta)

func puxar_eletrons(delta: float) -> void:
	# Pega o nó do Xenônio na cena
	var xenon = get_parent().get_node("Xenon")
	if xenon:
		# Aplica a força de eletronegatividade para drenar a estabilidade do Xenônio
		xenon.reduzir_estabilidade(eletronegatividade * forca_atracao * delta)
