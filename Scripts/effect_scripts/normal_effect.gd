extends Effect
class_name normal_effect

func effect_on_land(shape: Shape, board: Board) -> void:
	remove_full_lines(shape, board)
	
