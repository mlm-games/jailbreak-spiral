class_name Enemy extends CharacterBody2D

enum EnemyType {PunchEnemy, BatonEnemy, PistolEnemy, GuardEnemy}

@export var speed = 120

var enemy_type: EnemyType

static var punch_timer = Timer.new() 

@onready var state_chart: StateChart = %StateChart

func _ready() -> void:
	%DetectionArea2D.area_entered.connect(attack_if_player_in_range.bind())
	%DetectionArea2D.area_exited.connect(chase_if_player_left_range.bind())

func attack_if_player_in_range(area: Area2D):
	if area is HitboxComponent:
		if area.get_parent() is Player:
			state_chart.send_event("player_in_range"); print("Player in range")

func chase_if_player_left_range(area: Area2D):
	if area is HitboxComponent:
		if area.get_parent() is Player:
			state_chart.send_event("player_left_range"); print("player_left_range")


func _on_get_in_range_state_physics_processing(delta: float) -> void:
	move_towards_player()


func move_towards_player() -> void:
	var direction : Vector2 = global_position.direction_to(World.player.global_position)
	velocity = direction * speed
	move_and_slide()


func _on_attack_state_processing(delta: float) -> void:
	punch_player()

func punch_player() -> void:
	if !%AttackAnim.is_playing():
		%AttackAnim.play("punch")
		print("player got punched")
