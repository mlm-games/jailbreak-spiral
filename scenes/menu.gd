class_name MenuScene extends Control

signal start_game #(load_save: bool)

const SettingsScene = preload("uid://dp42fom7cc3n0")
const WorldScene = preload("uid://dwy6hkk3pn1wb")
const CreditsOverlayPopup = preload("uid://dp42fom7cc3n0")

@onready var start_button: AnimButton = %StartButton
@onready var settings_button: AnimButton = %SettingsButton
@onready var credits_button: AnimButton = %CreditsButton
@onready var exit_button: AnimButton = %ExitButton


func _ready() -> void:
	start_button.pressed.connect(on_start_button_pressed)
	settings_button.pressed.connect(on_settings_button_pressed)
	credits_button.pressed.connect(on_credits_button_pressed)
	exit_button.pressed.connect(on_exit_button_pressed)

func on_start_button_pressed():
	Transitions.change_scene_with_transition_packed(WorldScene)

func on_settings_button_pressed():
	Transitions.change_scene_with_transition_packed(SettingsScene)

func on_credits_button_pressed():
	Transitions.change_scene_with_transition_packed(CreditsOverlayPopup)

func on_exit_button_pressed():
	Transitions.transition()
	await Transitions.transition_player.animation_finished
	get_tree().quit()
