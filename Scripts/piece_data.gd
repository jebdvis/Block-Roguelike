extends Resource

class_name PieceData


@export var piece_texture: Texture
@export var shape_type: Global.Shape
@export var spawn_position: Vector2
@export var effect: Effect #TODO create effect controller in the correct script(possibly shape.gd, board.gd, or piece_spawner.gd)
