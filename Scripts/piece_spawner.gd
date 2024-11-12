extends Node

var current_shape
var next_shape 
var is_game_over = false

@onready var board = $"../board" as Board
@onready var ui = $"../UI" as UI


func _ready() ->void:
	#HACK configure way to have weighted randomness for random effects and pieces(while testing)
	current_shape = Global.Shape.values().pick_random()
	next_shape = Global.Shape.values().pick_random()
	board.spawn_shape(current_shape, false, null)
	board.spawn_shape(next_shape, true, Vector2(100,50))
	board.shape_locked.connect(on_shape_locked)
	board.game_over.connect(on_game_over)


#Checks if game is over; if not, sets the next shape to current shape and sets new next image
func on_shape_locked():
	if is_game_over:
		return
	current_shape = next_shape
	next_shape = Global.Shape.values().pick_random()
	board.spawn_shape(current_shape, false, null)
	board.spawn_shape(next_shape, true, Vector2(100,50))


func on_game_over():
	is_game_over = true
	ui.show_game_over()
