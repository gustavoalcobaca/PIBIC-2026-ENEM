extends HSlider

@onready var label = $"../Label"

func _ready():
	value_changed.connect(_on_ansiedade_changed)
	_on_ansiedade_changed(value)

func _on_ansiedade_changed(valor):
	label.text = "Ansiedade: " + str(int(valor)) + "%"
