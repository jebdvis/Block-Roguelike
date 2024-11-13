extends Effect
class_name hard_drop_effect

var effect_name = "hard_drop_effect"

var drops_left: int = 4

func effect_on_land(shape:Shape, board:Board):
	var nextShape = board.nextShape.get_child(1)
	if drops_left < 1:
		drops_left = 4
		nextShape.effect = board.get_effect("normal_effect")
		remove_full_lines(shape,board)
	
	
func effect_on_spawn(shape: Shape, board:Board):
	var nextShape = board.nextShape.get_child(1)
	shape.timer.stop()
	if drops_left >= 1:
		nextShape.get_child(0).paused = true
		nextShape.effect = board.get_effect("hard_drop_effect")
		nextShape.effect.drops_left -= 1
