extends Node2D
class_name Shape

signal lock_shape(shape:Shape)

var bounds = {
	"min_x" = -216,
	"max_x" = 216,
	"max_y" = 457
}
var wall_kicks
var shape_data
var is_next_piece
var shape_cells
var pieces = []
var other_shape_pieces: = []
var rotation_index = 0
var ghost_shape
var effect: Effect

@onready var piece_scene = preload("res://Scenes/piece.tscn")
@onready var timer = $Timer
@onready var ghost_scene = preload("res://Scenes/ghost_shape.tscn")

func _ready():
	shape_cells = Global.cells[shape_data.shape_type]
	
	for cell in shape_cells:
		var piece = piece_scene.instantiate() as Piece
		pieces.append(piece)
		add_child(piece)
		piece.set_texture(shape_data.piece_texture)
		piece.position = cell * piece.get_size()
	
	if is_next_piece == false:
		position = shape_data.spawn_position
		wall_kicks = Global.wall_kicks_i if shape_data.shape_type == Global.Shape.I else Global.wall_kicks_jlostz
		ghost_shape = ghost_scene.instantiate() as GhostShape
		ghost_shape.shape_data = shape_data
		get_tree().root.add_child.call_deferred(ghost_shape)
		hard_drop_ghost.call_deferred()
	else:
		timer.stop()
		set_process_input(false)

func hard_drop_ghost():
	var final_hard_drop_position
	var ghost_position_update = calculate_global_position(Vector2.DOWN, global_position)
	
	while ghost_position_update != null:
		ghost_position_update = calculate_global_position(Vector2.DOWN, ghost_position_update)
		if ghost_position_update != null:
			final_hard_drop_position = ghost_position_update
			
	if final_hard_drop_position != null:
		var children = get_children().filter(func (c): return c is Piece)
		
		var pieces_position = []
		for i in children.size():
			var piece_position = children[i].position
			pieces_position.append(piece_position)
			
		if pieces_position.size() == pieces.size():
			ghost_shape.set_ghost_shape(final_hard_drop_position, pieces_position)
		
	return final_hard_drop_position

func _input(_event):
	if Input.is_action_just_pressed("left"):
		move(Vector2.LEFT)
	elif Input.is_action_just_pressed("right"):
		move(Vector2.RIGHT)
	elif Input.is_action_just_pressed("down"):
		move(Vector2.DOWN)
	elif Input.is_action_just_pressed("hard_drop"):
		hard_drop()
	elif Input.is_action_just_pressed("rotate_left"):
		rotate_shape(1)
	elif Input.is_action_just_pressed("rotate_right"):
		rotate_shape(-1)
	elif Input.is_action_just_pressed("hold"):
		#TODO create a hold function(ui element exists) can probably use similar function to how next_piece works
		pass
		
		
func move(direction: Vector2) -> bool:
	var new_position = calculate_global_position(direction, global_position)
	if new_position:
		global_position = new_position
		if direction != Vector2.DOWN:
			hard_drop_ghost.call_deferred()
		return true
	else:
		return false
		
func calculate_global_position(direction: Vector2, starting_global_pos: Vector2):
	if is_colliding_with_shapes(direction, starting_global_pos):
		return null
	if !is_within_game_bounds(direction, starting_global_pos):
		return null
	return starting_global_pos + direction * pieces[0].get_size().x
		
		
func is_within_game_bounds(direction:Vector2, starting_global_pos: Vector2):
	for piece in pieces:
		var new_position = piece.position + starting_global_pos + direction * piece.get_size()
		if new_position.x < bounds.get("min_x") or new_position.x > bounds.get("max_x") or new_position.y >= bounds.get("max_y"):
			return false
	return true
	
func is_colliding_with_shapes(direction:Vector2, starting_global_pos: Vector2):
	for shape_piece in other_shape_pieces:
		for piece in pieces:
			if starting_global_pos + piece.position + direction * piece.get_size() == shape_piece.global_position:
				return true
	return false
	
	
func rotate_shape(direction:int):
	var original_index = rotation_index
	if shape_data.shape_type == Global.Shape.O:
		return
		
	apply_rotation(direction)
	
	rotation_index = wrap(rotation_index + direction, 0, 4)
	if !test_wall_kicks(rotation_index, direction):
		rotation_index = original_index
		apply_rotation(-direction)
		
	hard_drop_ghost.call_deferred()
		
	
func test_wall_kicks(rotation_index: int, rotation_direction: int):
	var wall_kick_index = get_wall_kick_index(rotation_index, rotation_direction)
	
	for i in wall_kicks[0].size():
		var translation = wall_kicks[wall_kick_index][i]
		if move(translation):
			return true
	return false
	
func get_wall_kick_index(rotation_index: int, rotation_direction: int):
	var wall_kick_index = rotation_index * 2
	if rotation_direction < 0:
		wall_kick_index -= 1
	return wrap(wall_kick_index, 0, wall_kicks.size())

func apply_rotation(direction:int):
	var rotation_matrix = Global.clockwise_rotation_matrix if direction == 1 else Global.counter_clockwise_rotation_matrix
	
	var shape_cells = Global.cells[shape_data.shape_type]
	
	for i in shape_cells.size():
		var cell = shape_cells[i]
		var x
		var y
		var coords = rotation_matrix[0] * cell.x + rotation_matrix[1]* cell.y
		shape_cells[i] = coords
		
	for i in pieces.size():
		var piece = pieces[i]
		piece.position = shape_cells[i] * piece.get_size()
	
	
func hard_drop():
	while(move(Vector2.DOWN)):
		continue 
	lock()
		
func lock():
	timer.stop()
	lock_shape.emit(self)
	set_process_input(false)
	ghost_shape.queue_free()

func _on_timer_timeout():
	#TODO timer decreses as points become greater(makes game faster)
	var should_lock = !move(Vector2.DOWN)
	if should_lock:
		lock()
