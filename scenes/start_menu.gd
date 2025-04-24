class_name StartMenu extends Node2D

const MenuScene = preload("uid://bse7g3q1go2be")

static var screen_shake : int = 90:
	set(val): clampi(val, 0, 100)
