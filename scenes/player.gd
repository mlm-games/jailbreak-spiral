class_name Player extends CharacterBody2D

@onready var health_component: HealthComponent = get_node("HealthComponent")
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var state_chart: StateChart = %StateChart

var speed = 250

var attack_offset_val = Vector2(40, 10)

var attack_tween: Tween

func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	var direction : Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	#if GameState.movement_joystick_direction != Vector2.ZERO:
		#direction = GameState.movement_joystick_direction
	
	velocity = direction.normalized() * speed
	
	#if velocity.x > 0:
		#%Sprite2D.flip_h = true
	#elif velocity.x < 0:
		#%Sprite2D.flip_h = false
		
	
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") and event.is_pressed():
		state_chart.send_event("attack")


func _on_attack_state_entered() -> void:
	attack()
	

func attack() -> void:
	#animation_player.play("attack")
	if attack_tween: attack_tween.kill()
	attack_tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	attack_tween.tween_property(%Hand, "position", %Hand.position + (Vector2(0, 40)).rotated(%Hand.rotation), 0.2667)
	attack_tween.tween_property(%Hand, "position", %Hand.position + (Vector2(-10, 0)).rotated(%Hand.rotation), 0.2667)
	attack_tween.tween_property(%Hand, "position", %Hand.position + (Vector2(0, 0)).rotated(%Hand.rotation), 0.2667)
	await attack_tween.finished
	state_chart.send_event("attack_ended")
	
func set_hand_position_rotated(pos: Vector2) -> void:
	%Hand.position = pos.rotated(rotation)
