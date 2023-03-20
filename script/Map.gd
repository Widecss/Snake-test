extends Node2D

@export var FoodScene: PackedScene
@export var BodyScene: PackedScene
@export var SnakeSpeed: float = 1

const GridSize = 80
const GridCentre = 40

var GridCount
var GridRowCount
var GridColumnCount

var Head
var SnakeFrameTimer

var wait_done = false
var stop_game = false

var grid_list = []


func _ready():
	SnakeFrameTimer = get_node("SnakeFrameTimer")
	SnakeFrameTimer.set_wait_time(1 / SnakeSpeed)
	
	init_map()

	Head = get_node("Head")
	Head.set_grid_size(GridSize)
	Head.set_grid_count(GridRowCount, GridColumnCount)
	Head.set_direction(Vector2.UP)
	Head.set_grid_position(Vector2(10, 4))
	
	new_body()
	generate_food()


func new_body():
	var body = BodyScene.instantiate()
	body.set_name("Body")
	body.GridSize = GridSize
	Head.body_list.append(body)
	call_deferred("add_child", body)
	topping_head()


func topping_head():
	# 玄学置顶法 - 头部
	call_deferred("remove_child", Head)
	call_deferred("add_child", Head)


func init_map():
	var WindowSize = get_viewport_rect().size
	GridRowCount = int(WindowSize.x / GridSize)
	GridColumnCount = int(WindowSize.y / GridSize)
	GridCount = GridRowCount * GridColumnCount

	for r in GridRowCount:
		var row_list = []
		for c in GridColumnCount:
			row_list.append(0)
		grid_list.append(row_list)


func generate_food():
	# 先清空 map
	for row in GridRowCount:
		for column in GridColumnCount:
			grid_list[row][column] = 0
	
	# 让头和身体标记已占用的位置
	grid_list[Head.grid_position.x][Head.grid_position.y] = 1
	for index in Head.body_list.size():
		var body = Head.body_list[index]
		if body.grid_position.x == -1:
			continue
		grid_list[body.grid_position.x][body.grid_position.y] = 1

	# 直接使用空位数随机
	var empty_count = GridCount - (Head.body_list.size() + 1)
	var food_index = randi() % empty_count

	# 然后按顺序找到这个空位生成
	for row in GridRowCount:
		for column in GridColumnCount:
			if grid_list[row][column] == 1:
				continue
			elif food_index > 0:
				food_index -= 1
			else:
				add_food(row, column)
				return


func add_food(row, column):
	var food = FoodScene.instantiate()
	food.set_name("Food")
	food.GridSize = GridSize
	food.grid_position = Vector2(row, column)
	food.display()
	call_deferred("add_child", food)
	topping_head()


func _process(delta):
	Head.display()
	if not wait_done:
		return delta
	if stop_game:
		return delta
	Head.change_direction()


func to_coordinate(step):
	return step * GridSize


func _on_timer_timeout():
	if not wait_done:
		get_node("WaitLabel").free()
		wait_done = true
	
	if Head.body_list.size() + 1 > GridCount - 1:
		win_event()
	
	Head.move()
	Head.check_position_out_of_bounds()


func win_event():
	SnakeFrameTimer.stop()
	stop_game = true
	
	var win = load("res://label/WinLabel.tscn").instantiate()
	win.position = Vector2(560, 310)
	call_deferred("add_child", win)


func fail_event():
	SnakeFrameTimer.stop()
	stop_game = true
	
	var fail = load("res://label/FailLabel.tscn").instantiate()
	fail.position = Vector2(560, 310)
	call_deferred("add_child", fail)


func _on_head_body_entered(body):
	if not wait_done:
		return
	if body.name == "Food":
		body.queue_free()
		remove_child(body)
		new_body()
		generate_food()


func _on_head_area_entered(area):
	if not wait_done:
		return
	if "Body" in area.name:
		fail_event()
