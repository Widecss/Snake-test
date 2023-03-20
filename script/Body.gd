extends Area2D

var GridSize

var grid_position = Vector2(-1, -1)


func display():
	position = (grid_position + Vector2(0.5, 0.5)) * GridSize
