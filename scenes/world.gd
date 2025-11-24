class_name World extends Node2D

@onready var level_timer: Timer = %LevelTimer
@onready var time_label: Label = $TimeLabel

static var player : Player


static var current_level: int

func _ready() -> void:
	player = %Player
	level_timer.timeout.connect(_on_level_time_timeout)


func _physics_process(delta: float) -> void:
	time_label.text = "Reinforcements arrive in: " + str(int(level_timer.time_left))

func _on_level_time_timeout():
	print("Game ended")
