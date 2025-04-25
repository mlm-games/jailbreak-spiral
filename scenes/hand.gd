extends RigidBody2D

@onready var marker_2d: Marker2D = %Marker2D

func  _physics_process(delta: float) -> void:
	look_at(get_global_mouse_position())
	rotation_degrees -= 90
	marker_2d.look_at(get_global_mouse_position())
