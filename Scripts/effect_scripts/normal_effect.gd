extends Effect
class_name normal_effect

func effect_on_land(shape: Shape, board: Board) -> void:
	remove_full_lines(shape, board)
	
func effect_on_spawn(shape: Shape, board: Board) -> void:
	pass 

func remove_full_lines(shape: Shape, board: Board):
	for line in board.get_lines():
		if line.is_line_full(board.COL_COUNT):
			board.move_lines_down(line.global_position.y)
			line.free()
