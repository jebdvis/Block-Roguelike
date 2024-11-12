extends Effect
class_name explode_effect

var radius:int = 2
var min_full_lines:int = 2

func effect_on_land(shape:Shape, board:Board):
	if check_full_lines(shape, board) >= min_full_lines:
		explosion(shape,board)
	else:
		remove_full_lines(shape, board)
					
	
func explosion(shape:Shape, board:Board):
	var all_pieces = board.get_all_pieces()
	for i in all_pieces:
		for j in shape.pieces:
			if i.global_position.distance_to(j.global_position) != 0 and i.global_position.distance_to(j.global_position) <= radius * 48:
				i.queue_free()
	for i in shape.pieces:
		i.queue_free()
#destroys pieces in radius 
