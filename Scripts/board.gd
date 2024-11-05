extends Node
class_name Board

signal shape_locked
signal game_over

const ROW_COUNT = 20
const COL_COUNT = 10

var next_shape
var shapes: Array[Shape] = []
@export var shape_scene: PackedScene
@onready var panel_container = $"../PanelContainer"


func spawn_shape(type: Global.Shape, is_next_piece, spawn_position):
	var shape_data = Global.data[type]
	var shape = shape_scene.instantiate() as Shape
	
	shape.shape_data = shape_data
	shape.is_next_piece = is_next_piece
	
	
	if is_next_piece == false:
		shape.position = shape_data.spawn_position
		shape.other_shapes = shapes
		shape.lock_shape.connect(on_shape_locked)
		add_child(shape)
	else:
		shape.scale = Vector2(0.5,0.5)
		panel_container.add_child(shape)
		shape.set_position(spawn_position)
		next_shape = shape


func on_shape_locked(shape: Shape):
	next_shape.queue_free()
	shapes.append(shape)
	shape_locked.emit()
	check_game_over()
	clear_lines()
	
func check_game_over():
	for shape in shapes:
		var pieces = shape.get_children().filter(func(c): return c is Piece)
		for piece in pieces:
			var y_location = piece.global_position.y
			if y_location == -456:
				game_over.emit()
	
func clear_lines():
	var board_pieces = fill_board_pieces()
	clear_board_pieces(board_pieces)
	
	
func fill_board_pieces():
	var board_pieces = []
	for i in ROW_COUNT:
		board_pieces.append([])
		
	for shape in shapes:
		var shape_pieces = shape.get_children().filter(func(c): return c is Piece)
		for piece in shape_pieces:
			var row = (piece.global_position.y + piece.get_size().y / 2) / piece.get_size().y + ROW_COUNT/2
			board_pieces[row-1].append(piece)
	return board_pieces
	
	
func clear_board_pieces(board_pieces):
	var i = ROW_COUNT
	
	while i > 0:
		var row_to_analyze = board_pieces[i-1]
		
		if row_to_analyze.size() == COL_COUNT:
			clear_row(row_to_analyze)
			board_pieces[i-1].clear()
			move_all_row_pieces_down(board_pieces,i)
		i -= 1


func clear_row(row):
	for piece in row:
		piece.queue_free()
		
		
func move_all_row_pieces_down(board_pieces, cleared_row_num):
	for i in range(cleared_row_num -1, 1, -1):
		var row_to_move = board_pieces[i-1]
		if row_to_move.size() == 0:
			return false
			
			
		for piece in row_to_move:
			piece.position.y += piece.get_size().y
			board_pieces[cleared_row_num -1].append(piece)
		board_pieces[i-1].clear()
