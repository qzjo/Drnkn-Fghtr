extends ProgressBar

@onready var label: Label = $Label
@onready var boss: Boss = $"../../../Boss"

@onready var total = boss.health
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(total)
	max_value = total
	value = total
	label.text = "Boss Health" + str(value)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label.text = "Boss Health: " + str(value)



func _on_mobdied() -> void:
	value -= 1
