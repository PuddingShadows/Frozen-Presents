extends Node2D

@onready var music = $music

@export var present_scene: PackedScene
@onready var spawn_timer = $spawn_Timer

@export var SPAWN_START_TIME := 0.5
@export var SPAWN_DECREASE := 0.1
@export var DIFFICULTY_INTERVAL := 10

var difficulty_elapsed := 0

@onready var survival_timer = $survival_Timer

var time_survived := 0
var last_spawn_x := -1000

const MAX_PRESENT_OF_SCREEN = 15

func _reduce_spawn_time() -> void:
		spawn_timer.wait_time -= SPAWN_DECREASE
		print(spawn_timer.wait_time)
		
func _ready() -> void:
	music.play()
	music.finished.connect(_on_music_finished)
	spawn_timer.wait_time = SPAWN_START_TIME
	randomize()
	
	survival_timer.start()
	spawn_timer.start()
	
func _on_survival_timer_timeout() -> void:
	time_survived += 1
	difficulty_elapsed += 1
	
	
	if difficulty_elapsed >= DIFFICULTY_INTERVAL:
		difficulty_elapsed = 0
		_reduce_spawn_time()
		
func _on_spawn_timer_timeout() -> void:
	var presents = get_tree().get_nodes_in_group("present")
	
	var force_spawn := presents.size() == 0
	
	if presents.size() >= MAX_PRESENT_OF_SCREEN and not force_spawn:
		return
		
	var present = present_scene.instantiate()
	
	var screen_width = get_viewport_rect().size.x
	var margin := 16
	var min_distance := 80
	
	var x_pos = randf_range(margin, screen_width - margin)
	
	if not force_spawn:
		var tries := 0
		
		while abs(x_pos - last_spawn_x) < min_distance and tries < 10:
			x_pos = randf_range(margin, screen_width - margin)
			tries += 1
	
	last_spawn_x = x_pos
	
	present.position = Vector2(x_pos, -20)
	add_child(present)


func _on_music_finished() -> void:
	music.play()
