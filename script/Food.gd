extends RigidBody2D

var GridSize

var grid_position


func display():
	position = (grid_position + Vector2(0.5, 0.5)) * GridSize
