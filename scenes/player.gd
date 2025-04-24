class_name Player extends CharacterBody2D

@onready var health_component: HealthComponent = get_node("HealthComponent")

var speed = 250

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
