extends CharacterBody3D

@export var min_speed = 10		# 移動的最小速度
@export var max_speed = 18		# 移動的最大速度

signal squashed					# 被壓扁的信號功能

# MARK: - 生命週期
func _physics_process(_delta): move_and_slide()

# MARK: - Node函式
func _on_visible_on_screen_notifier_3d_screen_exited(): queue_free()

# MARK: - 公用函式
func initialize(start_position, player_position): _InitializeActiion(start_position, player_position)
func squash(): _SquashAction()

# MARK: - 主工具
# 初始化腳色的位置
# - Parameters:
#   - startPosition: 開始的位置
#   - playerPosition: 主角的位置
func  _InitializeActiion(startPosition: Vector3, playerPosition: Vector3):
	
	var random_speed = randi_range(min_speed, max_speed)
	
	look_at_from_position(startPosition, playerPosition, Vector3.UP)
	rotate_y(randf_range(-PI / 4, PI / 4))
	
	velocity = Vector3.FORWARD * random_speed
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	
	$AnimationPlayer.speed_scale = float(random_speed) / float(min_speed)

# 被壓到的反應 (清除)
func _SquashAction():
	squashed.emit()
	queue_free()
