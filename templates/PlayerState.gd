extends PlayerState

func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	player.move_standard(delta) # Standard movement and collision handling
	
	
func finished_animation(_animation_name: String) -> void:
	pass


func enter(_msg := {}) -> void:
	pass


func exit() -> void:
	pass
