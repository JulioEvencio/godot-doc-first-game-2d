extends Node

@export var enemy_scene: PackedScene

var score : int

func _ready() -> void:
	pass

func _process(_delta : float) -> void:
	pass

func new_game() -> void:
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")

func game_over() -> void:
	$ScoreTimer.stop()
	$EnemyTimer.stop()
	$HUD.show_game_over()
	get_tree().call_group("enemies", "queue_free")

func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout() -> void:
	$ScoreTimer.start()
	$EnemyTimer.start()

func _on_enemy_timer_timeout() -> void:
	var enemy = enemy_scene.instantiate()
	var enemy_spawn_location = get_node("EnemyPath/EnemySpawnLocation")

	enemy_spawn_location.progress_ratio = randf()
	
	var direction = enemy_spawn_location.rotation + PI / 2
	
	enemy.position = enemy_spawn_location.position
	direction += randf_range(-PI / 4, PI / 4)
	enemy.rotation = direction
	
	var velocity : Vector2 = Vector2(randf_range(75.0, 125.0), 0.0)
	
	enemy.linear_velocity = velocity.rotated(direction)
	
	add_child(enemy)
