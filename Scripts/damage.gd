extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CPUParticles2D.emitting = true
	$AudioStreamPlayer2D.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not $CPUParticles2D.emitting:
		call_deferred("queue_free")
