@tool
class_name AnimButton extends Button

#@onready var particles = $MovementParticles2D
#@onready var label: Label = $Label
var audio_stream_player: AudioStreamPlayer = AudioStreamPlayer.new()
static var hover_sound_player: AudioStreamPlayer = AudioStreamPlayer.new()

@export var hover_audio: AudioStream:
	get: return hover_sound_player.stream 
	set(val): hover_sound_player.stream  = val

@export var click_audio: AudioStream:
	get: return hover_sound_player.stream 
	set(val): hover_sound_player.stream  = val

var tween: Tween

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)
	pressed.connect(_on_pressed)
	
	set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	size_flags_vertical = Control.SIZE_SHRINK_CENTER
	
	pivot_offset = size/2
	
	audio_stream_player.bus = "Sfx"
	get_tree().get_root().add_child.call_deferred(audio_stream_player)
	
	#Label stuff
	#_setup_text_animation()

#func _setup_text_animation():
	#label.material = ShaderMaterial.new()
	#label.material.shader = preload("res://scenes/UI/misc/anim_text.gdshader")


func _on_mouse_entered() -> void:
	pivot_offset = size/2
	#particles.emitting = true
	reset_tween()
	tween.tween_property(self, "scale", Vector2(1.075, 1.075), 0.15).set_trans(Tween.TRANS_CUBIC)
	if hover_audio: hover_sound_player.play()
	# smallish glow effect
	#var style = get_theme_stylebox("normal").duplicate()
	#style.shadow_size = 8
	#add_theme_stylebox_override("normal", style)
	
	## Label stuff
	
	#tween = create_tween()
	#tween.tween_method(_update_text_effect, 0.0, 1.0, 0.3)

func _on_mouse_exited() -> void:
	pivot_offset = size/2
	#particles.emitting = false
	reset_tween()
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.15).set_trans(Tween.TRANS_CUBIC)
	
	# Reset glow
	#add_theme_stylebox_override("normal", null)
	
	## label 
	#tween = create_tween()
	#tween.tween_method(_update_text_effect, 1.0, 0.0, 0.3)

func _on_button_down() -> void:
	pivot_offset = size/2
	reset_tween()
	tween.tween_property(self, "scale", Vector2(0.95, 0.95), 0.1).set_trans(Tween.TRANS_CUBIC)

func _on_button_up() -> void:
	pivot_offset = size/2
	reset_tween()
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1).set_trans(Tween.TRANS_CUBIC)

#func _update_text_effect(value: float):
	#label.material.set_shader_parameter("effect_value", value)


func _on_pressed() -> void:
	if click_audio: 
		audio_stream_player.stream = click_audio
	# audio_stream_player.pitch_scale = 1.2
		audio_stream_player.play()


#FIXME: Doesnt work due to the timers not being syncronised properly, hence looking bad.
	#await get_tree().create_timer(0.15).timeout
	#_on_mouse_entered()

func _exit_tree() -> void:
	#await audio_stream_player.finished
	#audio_stream_player.volume_db = -1000
	audio_stream_player.queue_free()

func reset_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
