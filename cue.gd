extends Node3D

@export var Cue_ball: NodePath

var aim_angle: float = 0.0
var power: float = 0.0
var is_aiming: bool = true
var max_power: float = 1.5
var min_power: float = 0.01
var charging: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta):
	var cue_ball_node = get_node(Cue_ball)
	if not is_aiming and cue_ball_node.linear_velocity.length() < 0.1:
		is_aiming = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if charging:
		power = clamp(power + delta * 10, min_power, max_power)
	if is_aiming:
		if Input.is_action_pressed("aim_left"):
			aim_angle -= delta * 1.5
		if Input.is_action_pressed("aim_right"):
			aim_angle += delta * 1.5
		var Cue_ball_pos = get_node(Cue_ball).global_transform.origin
		var offset = Vector3(sin(aim_angle), 0, cos(aim_angle)) * 1.0 
		global_transform.origin = Cue_ball_pos + offset 
		look_at(Cue_ball_pos, Vector3.UP)

func _input(event):
	if is_aiming and event.is_action_pressed("shoot"):
		charging = true
		power = min_power
	elif charging and event.is_action_released("shoot"):
		charging = false
		shoot()

func shoot():
	var Cue_ball_node = get_node(Cue_ball)
	var direction = (Cue_ball_node.global_transform.origin - global_transform.origin).normalized()
	Cue_ball_node.apply_impulse(direction * power, Vector3.ZERO)
	is_aiming = false
