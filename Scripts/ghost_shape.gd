extends Node2D
class_name GhostShape

@onready var piece_scene = preload("res://Scenes/piece.tscn")
@onready var ghost_texture = preload("res://Assets/Ghost.png")


var shape_data: Resource


func _ready():
	var shape_cells = Global.cells[shape_data.shape_type]
	
	for cell in shape_cells:
		var piece = piece_scene.instantiate() as Piece
		add_child(piece)
		piece.set_texture(ghost_texture)
		piece.position = cell * piece.get_size()
		
		
		
func set_ghost_shape(new_position: Vector2, pieces_position):
	global_position = new_position
	
	var pieces = get_children()
	for i in pieces.size():
		pieces[i].position = pieces_position[i]
