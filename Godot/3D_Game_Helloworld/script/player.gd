extends CharacterBody3D

@export var speed = 14				# 移動的速度 14m/s
@export var fall_acceleration = 75	# 在空中下降的加速度 75m/s
@export var jump_impulse = 20		# 跳起來的距離
@export var bounce_impulse = 16		#

signal hit							# 碰撞到的信號處理

var target_velocity = Vector3.ZERO	# 目前的位置

# MARK: - 生命週期
func _physics_process(delta): _PhysicsProcessAction(delta)

# MARK: - Node函式
func _on_mob_detector_body_entered(body): _DieAction()

# MARK: - 主工具
# 設定主角相關動作 / 圖形方向
# - Parameters:
#   - delta: float
func _PhysicsProcessAction(delta: float):
	
	var direction = _MoveActionSetting()
	
	_CharacterDirection(direction)
	_OnFloorAction(delta, jump_impulse)
	_CollisionAction(delta)
	_MoveAndSlideAction(direction, speed)
	
	$Pivot.rotation.x = PI / 6 * velocity.y / jump_impulse

# 主角被碰撞到處理
func _DieAction():
	hit.emit()
	queue_free()

# MARK: - 小工具
# 移動設定 (上/下/左/右) + 正規化處理 (半徑為1)
# - Returns: Vector3
func _MoveActionSetting() -> Vector3:
	
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("move_right"): direction.x += 1
	if Input.is_action_pressed("move_left"): direction.x -= 1
	if Input.is_action_pressed("move_back"): direction.z += 1
	if Input.is_action_pressed("move_forward"): direction.z -= 1
	
	direction = direction.normalized()
	
	return direction

# 彈跳的相關處理 (在空中就慢慢下降 / 在地上就，按跳就跳起來)
# - Parameters:
#   - delta: float
#   - jumpImpulse: int
func _OnFloorAction(delta: float, jumpImpulse: int):
	if not is_on_floor(): target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	if is_on_floor() and Input.is_action_just_pressed("jump"): target_velocity.y = jumpImpulse

# 移動角色
# - Parameters:
#   - direction: Vector3
#   - speed: float
func _MoveAndSlideAction(direction: Vector3, speed: float):
	
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	velocity = target_velocity
	move_and_slide()

# 主角的圖形方向 (頭朝哪一邊)
# - Parameters:
#   - delta: float
func _CharacterDirection(direction: Vector3):

	if direction != Vector3.ZERO: 
		$Pivot.basis = Basis.looking_at(direction)
		$AnimationPlayer.speed_scale = 4
	else:
		$AnimationPlayer.speed_scale = 1

# 主角跟敵人碰撞的反應
func _CollisionAction(delta: float):

	for index in range(get_slide_collision_count()):

		var collision = get_slide_collision(index)

		if collision.get_collider() == null: continue

		if collision.get_collider().is_in_group("mob"):

			var mob = collision.get_collider()

			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				mob.squash()
				target_velocity.y = bounce_impulse
				break
