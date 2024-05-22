extends Node

@export var mob_scene: PackedScene

# MARK: - 生命週期
func _ready(): $UserInterface/Retry.hide()

# MARK: - Node函式
func _on_mob_timer_timeout(): _OnMobTimerTimeoutAction()
func _on_player_hit(): _OnPlayerHitAction()

# MARK: - 主工具
# 隨機產生Mob
func _OnMobTimerTimeoutAction():
	
	var mob = mob_scene.instantiate()
	var mob_spawn_location = $SpawnPath/SpawnLocation
	var player_position = $Player.position
	
	mob_spawn_location.progress_ratio = randf()
	mob.initialize(mob_spawn_location.position, player_position)
	mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed.bind())
	
	add_child(mob)

func _OnPlayerHitAction():
	$MobTimer.stop()
	$UserInterface/Retry.show()

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible: get_tree().reload_current_scene()
