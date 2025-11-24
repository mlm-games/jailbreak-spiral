class_name Enemy extends CharacterBody2D

enum EnemyType {PunchEnemy, BatonEnemy, PistolEnemy, GuardEnemy}

@export var speed = 120

var enemy_type: EnemyType
var dodge_tween : Tween
var attack_tween : Tween

static var punch_timer = Timer.new() 

@onready var state_chart: StateChart = %StateChart

func _ready() -> void:
	%DetectionArea2D.area_entered.connect(attack_if_player_in_range.bind())
	%DetectionArea2D.area_exited.connect(chase_if_player_left_range.bind())
	
	%Hand.set_collision_mask_value(3, true)

func _physics_process(delta: float) -> void:
	look_at(World.player.global_position)
	
	%Hand.look_at_position = World.player.position

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

func punch_player() -> void:
	if !%AttackAnim.is_playing():
		%AttackAnim.play("punch")
	if attack_tween: attack_tween.kill()
	attack_tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_loops()
	attack_tween.tween_property(%Hand, "position", %Hand.position + (Vector2(0, 40)).rotated(%Hand.rotation), 0.2667)
	attack_tween.tween_property(%Hand, "position", %Hand.position + (Vector2(-10, 0)).rotated(%Hand.rotation), 0.2667)
	attack_tween.tween_property(%Hand, "position", %Hand.position + (Vector2(0, 0)).rotated(%Hand.rotation), 0.2667)
	await attack_tween.loop_finished
	state_chart.send_event("attack_ended")


func _on_dodge_state_entered() -> void:
	dodge()

func dodge() -> void:
	if dodge_tween: dodge_tween.kill()
	dodge_tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	dodge_tween.tween_property(self, "position", self.position + (Vector2(-40, 0)).rotated(self.rotation), 0.4)
	dodge_tween.tween_property(self, "position", self.position + (Vector2(-10, 10)).rotated(self.rotation), 0.4)
	dodge_tween.tween_property(self, "position", self.position + (Vector2(0, 0)).rotated(self.rotation), 0.4)
	await dodge_tween.finished
	state_chart.send_event("dodge_ended")


func _on_attack_state_entered() -> void:
	punch_player()



func _on_attack_state_exited() -> void:
	if attack_tween.get_loops_left() != 1: 
		attack_tween.set_loops(1)
		await attack_tween.finished
		attack_tween.kill()
		%Hand.position = Vector2.ZERO
