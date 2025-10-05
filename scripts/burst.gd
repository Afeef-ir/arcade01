extends GPUParticles2D

@onready var sfx : AudioStreamPlayer2D = $Sfx

func play(stream : AudioStream, volume_db : float, pitch_scale : float = 1.0) -> void:
	emitting = true
	sfx.set_stream(stream)
	sfx.set_pitch_scale(pitch_scale)
	sfx.set_volume_db(volume_db)
	sfx.play()
