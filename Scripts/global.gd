extends Node

enum Shape{
	I,O,T,J,L,S,Z
}

var cells = {
	Shape.I: [Vector2(-1, 0), Vector2(0, 0), Vector2(1, 0), Vector2(2, 0)],
#-------------------------------------------------------------------
	Shape.J: [Vector2(-1, 1), Vector2(-1, 0), Vector2(0,0), Vector2(1, 0 )],
	#-------------------------------------------------------------------
	Shape.L: [Vector2(1,1), Vector2(-1, 0), Vector2(0,0), Vector2(1,0)],
	#-------------------------------------------------------------------
	Shape.O: [Vector2(0,1), Vector2(1,1), Vector2(0,0), Vector2(1,0)],
	#-------------------------------------------------------------------
	Shape.S: [Vector2(0,1), Vector2(1,1), Vector2(-1, 0), Vector2(0,0)],
	#-------------------------------------------------------------------
	Shape.T: [Vector2(0,1), Vector2(-1, 0), Vector2(0,0), Vector2(1,0)],
	#-------------------------------------------------------------------
	Shape.Z: [Vector2(-1, 1), Vector2(0, 1), Vector2(0,0), Vector2(1, 0)]
}

var wall_kicks_i = [
	[Vector2(0,0), Vector2(-2,0), Vector2(1,0), Vector2(-2,-1), Vector2(1,2)],
	[Vector2(0,0), Vector2(2,0), Vector2(-1, 0), Vector2(2,1), Vector2(-1, -2)],
	[Vector2(0,0), Vector2(-1, 0), Vector2(2,0), Vector2(-1,2), Vector2(2, -1)],
	[Vector2(0,0), Vector2(1,0), Vector2(-2, 0), Vector2(1, -2), Vector2(-2, 1)],
	[Vector2(0,0), Vector2(2,0), Vector2(-1, 0), Vector2(2,1), Vector2(-1, -2)],
	[Vector2(0,0), Vector2(-2,0), Vector2(1, 0), Vector2(-2, -1), Vector2(1, 2)],
	[Vector2(0,0), Vector2(1,0), Vector2(-2,0), Vector2(1, -2), Vector2(-2,1)],
	[Vector2(0,0), Vector2(-1, 0), Vector2(2, 0), Vector2(-1,2), Vector2(2, -1)]
]

var wall_kicks_jlostz = [
	[Vector2(0,0), Vector2(-1,0), Vector2(-1,1), Vector2(0,-2), Vector2(-1, -2)],
	[Vector2(0,0), Vector2(1,0), Vector2(1, -1), Vector2(0,2), Vector2(1, 2)],
	[Vector2(0,0), Vector2(1, 0), Vector2(1,-1), Vector2(0,2), Vector2(1, 2)],
	[Vector2(0,0), Vector2(-1,0), Vector2(-1, 1), Vector2(0, -2), Vector2(-1, -2)],
	[Vector2(0,0), Vector2(1,0), Vector2(1, 1), Vector2(0,-2), Vector2(1, -2)],
	[Vector2(0,0), Vector2(-1,0), Vector2(-1, -1), Vector2(0, 2), Vector2(-1, 2)],
	[Vector2(0,0), Vector2(-1,0), Vector2(-1,-1), Vector2(0, 2), Vector2(-1, 2)],
	[Vector2(0,0), Vector2(1, 0), Vector2(1, 1), Vector2(0,-2), Vector2(1, -2)]
]

var data = {
	Shape.I: preload("res://Resources/norm_i_piece.tres"),
	Shape.J: preload("res://Resources/norm_j_piece.tres"),
	Shape.L: preload("res://Resources/norm_L_piece.tres"),
	Shape.O: preload("res://Resources/norm_o_piece.tres"),
	Shape.S: preload("res://Resources/norm_s_piece.tres"),
	Shape.T: preload("res://Resources/norm_T_piece.tres"),
	Shape.Z: preload("res://Resources/norm_z_piece.tres")
}

var effect_list = {
	"normal_effect": preload("res://Resources/effects/normal_effect.tres"),
	"explode_effect": preload("res://Resources/effects/explode_effect.tres"),
	"hard_drop_effect": preload("res://Resources/effects/hard_drop_effect.tres")
}

var clockwise_rotation_matrix = [Vector2(0, -1), Vector2(1, 0)]
var counter_clockwise_rotation_matrix = [Vector2(0,1), Vector2(-1, 0)]
