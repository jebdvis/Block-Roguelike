extends Resource
class_name Effect

func effect_on_land(shape: Shape, board: Board) -> void:
	pass
	
func effect_on_spawn(shape: Shape, board: Board) -> void:
	pass 


func remove_full_lines(shape: Shape, board: Board) -> void:
	for line in board.get_lines():
		if line.is_line_full(board.COL_COUNT):
			board.move_lines_down(line.global_position.y)
			line.free()
			
func check_full_lines(shape: Shape, board: Board) -> int:
	var full_line_amt:int
	for line in board.get_lines():
		if line.is_line_full(board.COL_COUNT):
			full_line_amt += 1
	return full_line_amt
