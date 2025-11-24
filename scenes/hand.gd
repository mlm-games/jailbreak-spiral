class_name Hand extends RigidBody2D

@onready var marker_2d: Marker2D = %Marker2D

@export_enum("Player", "Enemy") var user

static var player_damage: float = GameStats.get_stat(GameStats.Stats.RAW_DAMAGE_MOD)
static var enemy_damage: float = 10 #GameStats.get_stat(GameStats.Stats.)

var attack = Attack.new()

var look_at_position : Vector2 

func _ready() -> void:
	%HitboxComponent.area_entered.connect(_on_area_entered.bind())

func  _physics_process(delta: float) -> void:
	look_at(look_at_position)
	rotation_degrees -= 90
	marker_2d.look_at(look_at_position)


func _on_area_entered(area: Area2D) -> void:
	if area is HitboxComponent:
		if user == 1:
			attack.attack_damage = player_damage
		else:
			attack.attack_damage = enemy_damage
		#if not is_nan(dot):
			#attack.dot_type = dot_type
			#attack.dot_duration = dot_duration
			#attack.damage_over_time = dot
		area.damage(attack)
