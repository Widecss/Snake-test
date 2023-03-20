extends Area2D

var GridSize
var GridRowCount
var GridColumnCount

var grid_position
var direction
var back_direction

var body_list = []
var new_body


func change_direction():
	if direction == Vector2.UP or direction == Vector2.DOWN:
		if Input.is_action_pressed("ui_left") and back_direction != Vector2.LEFT:
			direction = Vector2.LEFT
			rotation = PI / 2
			display()
		elif Input.is_action_pressed("ui_right") and back_direction != Vector2.RIGHT:
			direction = Vector2.RIGHT
			rotation = -PI / 2
			display()
	else:
		if Input.is_action_pressed("ui_up") and back_direction != Vector2.UP:
			direction = Vector2.UP
			rotation = PI
			display()
		elif Input.is_action_pressed("ui_down") and back_direction != Vector2.DOWN:
			direction = Vector2.DOWN
			rotation = 0
			display()


func move():
	var pre_grid_position = grid_position
	back_direction = -direction
	grid_position += direction
	
	var tmp
	for index in body_list.size():
		tmp = body_list[index].grid_position
		body_list[index].grid_position = pre_grid_position
		pre_grid_position = tmp


func display():
	for index in body_list.size():
		body_list[index].display()
	position = (grid_position + Vector2(0.5, 0.5)) * GridSize


func check_position_out_of_bounds():
	if grid_position.x < 0:
		grid_position.x = GridRowCount - 1
	elif grid_position.x == GridRowCount:
		grid_position.x = 0

	if grid_position.y < 0:
		grid_position.y = GridColumnCount - 1
	elif grid_position.y == GridColumnCount:
		grid_position.y = 0


func set_grid_size(size):
	GridSize = size


func set_direction(dr):
	direction = dr
	if direction == Vector2.UP:
		rotation = PI
	elif direction == Vector2.DOWN:
		rotation = 0
	elif direction == Vector2.LEFT:
		rotation = PI / 2
	elif direction == Vector2.RIGHT:
		rotation = -PI / 2


func set_grid_count(row, column):
	GridRowCount = row
	GridColumnCount = column


func set_grid_position(pos):
	grid_position = pos


func get_body_position(pre_grid_position):
	return (pre_grid_position + Vector2(0.5, 0.5)) * GridSize
