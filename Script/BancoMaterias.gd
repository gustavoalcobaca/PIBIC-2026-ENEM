
extends Node

# ==================================================
# BANCO DE MATÉRIAS
# ==================================================

var fisica: Dictionary = {}
var quimica: Dictionary = {}
var biologia: Dictionary = {}


func _ready() -> void:
	_inicializar_banco()


# ==================================================
# ESTRUTURA PADRÃO DE CADA ANO
# ==================================================

func _criar_ano() -> Dictionary:
	return {
		"progresso": 0,
		"concluidos": [],
		"proximo": "Em desenvolvimento...",
		"pendentes": [],
		"atividades": {},
		"atividades_concluidas": []
	}


# ==================================================
# INICIALIZAÇÃO
# ==================================================

func _inicializar_banco() -> void:

	for ano in ["1º Ano", "2º Ano", "3º Ano"]:
		fisica[ano] = _criar_ano()
		quimica[ano] = _criar_ano()
		biologia[ano] = _criar_ano()

	# Dados demonstrativos antigos de Física.
	fisica["3º Ano"]["concluidos"] = [
		"Cinemática",
		"Leis de Newton"
	]

	fisica["3º Ano"]["proximo"] = "Gravitação Universal"

	fisica["3º Ano"]["pendentes"] = [
		"Ondulatória",
		"Óptica"
	]

	# Cadastro das atividades disponíveis.

	cadastrar_atividade(
		"fisica",
		"1º Ano",
		"puzzle_frenagem",
		"Puzzle de Frenagem"
	)

	cadastrar_atividade(
		"quimica",
		"1º Ano",
		"experimento_misturas",
		"Experimento de Misturas"
	)

	cadastrar_atividade(
		"biologia",
		"1º Ano",
		"osmose_hemacias",
		"Osmose e Hemácias",
		
	)


# ==================================================
# LOCALIZAR MATÉRIA
# ==================================================

func _obter_materia(materia: String) -> Dictionary:

	match materia.to_lower():
		"fisica":
			return fisica

		"quimica":
			return quimica

		"biologia":
			return biologia

	return {}


# ==================================================
# CADASTRAR ATIVIDADE
# ==================================================

func cadastrar_atividade(
	materia: String,
	ano: String,
	id: String,
	nome: String,
	disponivel: bool = true
) -> bool:

	var banco := _obter_materia(materia)

	if banco.is_empty() or not banco.has(ano):
		push_warning("Matéria ou ano não encontrado.")
		return false

	if id.strip_edges().is_empty() or nome.strip_edges().is_empty():
		push_warning("ID ou nome da atividade inválido.")
		return false

	var dados: Dictionary = banco[ano]
	var atividades: Dictionary = dados["atividades"]

	if atividades.has(id):
		push_warning("Atividade já cadastrada: " + id)
		return false

	atividades[id] = {
		"nome": nome,
		"disponivel": disponivel
	}

	_atualizar_dados(dados)

	return true


# ==================================================
# ALTERAR DISPONIBILIDADE
# ==================================================

func definir_disponibilidade(
	materia: String,
	ano: String,
	id: String,
	disponivel: bool
) -> bool:

	var banco := _obter_materia(materia)

	if banco.is_empty() or not banco.has(ano):
		return false

	var dados: Dictionary = banco[ano]
	var atividades: Dictionary = dados["atividades"]

	if not atividades.has(id):
		return false

	atividades[id]["disponivel"] = disponivel

	_atualizar_dados(dados)

	return true


# ==================================================
# CONCLUIR ATIVIDADE
# ==================================================

func concluir_atividade(
	materia: String,
	ano: String,
	id: String
) -> bool:

	var banco := _obter_materia(materia)

	if banco.is_empty() or not banco.has(ano):
		return false

	var dados: Dictionary = banco[ano]
	var atividades: Dictionary = dados["atividades"]

	if not atividades.has(id):
		push_warning("Atividade não cadastrada.")
		return false

	if not atividades[id]["disponivel"]:
		push_warning("Atividade indisponível.")
		return false

	var concluidas: Array = dados["atividades_concluidas"]

	if concluidas.has(id):
		return false

	concluidas.append(id)

	_atualizar_dados(dados)

	return true


# ==================================================
# CALCULAR PROGRESSO
# ==================================================

func calcular_progresso(
	materia: String,
	ano: String
) -> int:

	var banco := _obter_materia(materia)

	if banco.is_empty() or not banco.has(ano):
		return 0

	var dados: Dictionary = banco[ano]
	var atividades: Dictionary = dados["atividades"]
	var concluidas: Array = dados["atividades_concluidas"]

	var total := 0
	var quantidade_concluida := 0

	for id in atividades:
		if atividades[id]["disponivel"]:
			total += 1

			if concluidas.has(id):
				quantidade_concluida += 1

	if total == 0:
		return 0

	return roundi(
		float(quantidade_concluida) / float(total) * 100.0
	)


# ==================================================
# ATUALIZAR DADOS DO PAINEL
# ==================================================

func _atualizar_dados(dados: Dictionary) -> void:

	var atividades: Dictionary = dados["atividades"]
	var concluidas: Array = dados["atividades_concluidas"]

	var nomes_concluidos: Array = []
	var nomes_pendentes: Array = []

	for id in atividades:
		var atividade: Dictionary = atividades[id]

		if not atividade["disponivel"]:
			continue

		if concluidas.has(id):
			nomes_concluidos.append(atividade["nome"])
		else:
			nomes_pendentes.append(atividade["nome"])

	dados["concluidos"] = nomes_concluidos
	dados["pendentes"] = nomes_pendentes

	if nomes_pendentes.is_empty():
		if nomes_concluidos.is_empty():
			dados["proximo"] = "Nenhuma atividade disponível"
		else:
			dados["proximo"] = "Todas as atividades concluídas"
	else:
		dados["proximo"] = nomes_pendentes[0]

	var total := nomes_concluidos.size() + nomes_pendentes.size()

	if total == 0:
		dados["progresso"] = 0
	else:
		dados["progresso"] = roundi(
			float(nomes_concluidos.size()) / float(total) * 100.0
		)
