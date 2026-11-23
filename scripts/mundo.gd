extends Node2D

var max_lives := 4
var current_lives := 4

var presents := 0

@onready var music = $music

@onready var life_container = $hud/life_container
@onready var normal_hearts := [
	life_container.get_node("heart_0"),
	life_container.get_node("heart_1"),
	life_container.get_node("heart_2"),
	life_container.get_node("heart_3")
	]
@onready var black_hearts := [
	life_container.get_node("black_heart_0"),
	life_container.get_node("black_heart_1"),
	life_container.get_node("black_heart_2"),
	life_container.get_node("black_heart_3")
	]

@onready var presents_counter = $hud/present_counter


@export var present_scene: PackedScene
@export var life_scene: PackedScene
@onready var spawn_timer = $spawn_Timer
@onready var spawn_timer_life = $spawn_timer_life

@export var SPAWN_START_TIME := 1.5
@export var SPAWN_DECREASE := 0.1
@export var DIFFICULTY_INTERVAL := 10

@export var SPAWN_START_TIME_LIFE := 10

var difficulty_elapsed := 0

@onready var survival_timer = $survival_Timer
@onready var time_label = $hud/timer_label

var time_survived := 0
var last_spawn_x := -1000

const MAX_PRESENT_OF_SCREEN = 6


func update_life_hud():
	for i in range(max_lives):
		if i < current_lives:
			normal_hearts[i].visible = true
			black_hearts[i].visible = false
		else:
			normal_hearts[i].visible = false
			black_hearts[i].visible = true

func lose_life(amount := 1):
	current_lives -= amount
	current_lives = max(current_lives, 0)
	update_life_hud()
	$damage.play()

	if current_lives <= 0:
		morte()

func add_life(amount := 1):
	current_lives += amount
	update_life_hud()

func add_small_present(amount := 1):
	presents += amount
	presents_counter.text = "x%02d" % presents
	$morte_tela/presente.text = "x%02d" % presents

func add_big_present(amount := 2):
	presents += amount
	presents_counter.text = "x%02d" % presents
	$morte_tela/presente.text = "x%02d" % presents


func _reduce_spawn_time() -> void:
	spawn_timer.wait_time -= SPAWN_DECREASE
	#print(spawn_timer.wait_time)


func _ready() -> void:
	Game.mundo = self
	music.play()
	music.finished.connect(_on_music_finished)
	spawn_timer.wait_time = SPAWN_START_TIME
	randomize()
	
	survival_timer.start()
	spawn_timer.start()
	spawn_timer_life.start()
	
	update_time_label()
	update_life_hud()


func _on_survival_timer_timeout() -> void:
	time_survived += 1
	difficulty_elapsed += 1
	update_time_label()
	
	if difficulty_elapsed >= DIFFICULTY_INTERVAL:
		difficulty_elapsed = 0
		_reduce_spawn_time()

func update_time_label():
	var minutes = time_survived / 60
	var seconds = time_survived % 60
	time_label.text = "%02d:%02d" % [minutes, seconds]
	$morte_tela/tempo.text = "%02d:%02d" % [minutes, seconds]

func _on_spawn_timer_timeout() -> void:
	#var presents = get_tree().get_nodes_in_group("present")
	#var force_spawn := presents.size() == 0
	
	#if presents.size() >= MAX_PRESENT_OF_SCREEN and not force_spawn:
		#return
	
	if Game.present_count >= MAX_PRESENT_OF_SCREEN:
		return
	
	var present = present_scene.instantiate()
	
	var screen_width = get_viewport_rect().size.x
	var margin := 16
	var min_distance := 80
	
	var x_pos = randf_range(margin, screen_width - margin)
	
	var tries := 0
	
	while abs(x_pos - last_spawn_x) < min_distance and tries < 10:
		x_pos = randf_range(margin, screen_width - margin)
		tries += 1
	
	last_spawn_x = x_pos

	present.position = Vector2(x_pos, -20)
	add_child(present)

func _on_spawn_timer_life_timeout() -> void:
		if current_lives < max_lives:
			var screen_width = get_viewport_rect().size.x
			var margin := 16
			var x_pos = randf_range(margin, screen_width - margin)
			
			var nova_vida = life_scene.instantiate()
			
			nova_vida.position = Vector2(x_pos, -20)
			add_child(nova_vida)

func morte():
	get_tree().root.get_node("mundo/game_over").play()
	$morte_tela.visible = true
	get_tree().paused = true
	survival_timer.stop()


func _on_music_finished() -> void:
	music.play()
