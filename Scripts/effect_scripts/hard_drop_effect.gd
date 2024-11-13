extends Effect
class_name hard_drop_effect

var drops_left: int = 4
var former_timer: float

func effect_on_land(shape:Shape, board:Board):
		if board.timer_len != 0:
			former_timer = board.timer_len
			board.timer_len = 0
		board.nextShape.get_child(1).effect = board.get_effect("hard_drop_effect")
		board.nextShape.get_child(1).effect.drops_left -= 1
		board.nextShape.get_child(1).effect.former_timer = former_timer
		
func effect_on_spawn(shape: Shape, board:Board):
	if drops_left <= 0:
		board.timer_len = former_timer
		shape.effect = board.get_effect("normal_effect")
