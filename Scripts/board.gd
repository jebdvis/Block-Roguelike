extends Node
class_name Board

signal shape_locked
signal game_over

const ROW_COUNT = 20
const COL_COUNT = 10

var next_shape #is the representation of the next shape on the ui, not the actual next shape object
var shapes: Array[Shape] = []
@export var shape_scene: PackedScene
@onready var nextShape = $"../NextShape"
@onready var line_scene = preload("res://Scenes/line.tscn")


func spawn_shape(type: Global.Shape, is_next_piece, spawn_position):
	var shape_data = Global.data[type]
	var shape = shape_scene.instantiate() as Shape
	
	shape.shape_data = shape_data
	shape.is_next_piece = is_next_piece
	
	
	if is_next_piece == false:
		var other_pieces = get_all_pieces()
		shape.position = shape_data.spawn_position
		shape.other_shape_pieces = other_pieces
		add_child(shape)
		shape.lock_shape.connect(on_shape_locked)
	else:
		shape.scale = Vector2(0.5,0.5)
		nextShape.add_child(shape)
		shape.set_position(spawn_position)
		next_shape = shape


func on_shape_locked(shape: Shape):
	next_shape.queue_free()
	shapes.append(shape)
	add_shape_to_lines(shape)
	remove_full_lines()
	shape_locked.emit()
	check_game_over()
	
	#checks if pieces are above the board, if so the game ends
	#TODO queue_free pieces above the top of board to make end game look cleaner 
func check_game_over():
	for piece in get_all_pieces():
		var y_location = piece.global_position.y
		if y_location == -456:
			game_over.emit()
	
func add_shape_to_lines(shape: Shape):
	var shape_pieces = shape.get_children().filter(func (c): return c is Piece)
	
	for piece in shape_pieces:
		var y_position = piece.global_position.y
		var does_line_for_piece_exist = false
		for line in get_lines():
			if line.global_position.y == y_position:
				piece.reparent(line)
				does_line_for_piece_exist = true
				
				
		if !does_line_for_piece_exist:
			var piece_line = line_scene.instantiate() as Line
			piece_line.global_position = Vector2(0,y_position)
			add_child(piece_line)
			piece.reparent(piece_line)
	
	
func get_lines():
	return get_children().filter(func (c): return c is Line)
	
func remove_full_lines():
	for line in get_lines():
		if line.is_line_full(COL_COUNT):
			move_lines_down(line.global_position.y)
			line.free()
			
func move_lines_down(y_position):
	for line in get_lines():
		if line.global_position.y < y_position:
			line.global_position.y += 48
			
func get_all_pieces():
	var pieces = []
	for line in get_lines():
		pieces.append_array(line.get_children())
	return pieces
