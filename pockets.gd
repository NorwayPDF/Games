extends Area3D

signal ball_pocketed(Balls)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is Area3D:
			child.body_entered.connect(_on_body_entered)
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body is RigidBody3D:
		print("entered pocket:", body.name)
		body.call_deferred("queue_free")
	if body.name.begins_with("Balls"):
		emit_signal("ball_pocketed", body)
		body.queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
