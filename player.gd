extends CharacterBody2D

const MOVEMENT_SPEED := 1000
const FRICTION := 90

var direction := Vector2.ZERO
var axis := Vector2.ZERO


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	_move(delta)
	
	if Input.is_action_just_pressed("fire"):
		_fire()


func _get_input_axis() -> Vector2:
	axis.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	axis.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	
	return axis.normalized()


func _move(_p_delta : float) -> void:
	axis = _get_input_axis()
	if axis == Vector2.ZERO:
		_apply_friction(FRICTION)
	else:
		_apply_movement(axis * MOVEMENT_SPEED)
	
	move_and_slide()
	look_at(get_global_mouse_position())


func _apply_friction(p_amount : float) -> void:
	if velocity.length() > p_amount:
		velocity -= velocity.normalized() * p_amount
	else:
		velocity = Vector2.ZERO


func _apply_movement(p_velocity : Vector2) -> void:
	velocity = p_velocity
	velocity.limit_length(MOVEMENT_SPEED)


func _fire() -> void:
	var bullet : Bullet = ResourcePool.get_item(Config.PooledItems.BULLET)
	
	bullet.position = get_global_position()
	bullet.rotation_degrees = rotation_degrees
	
	bullet.set_target(
		bullet.global_position.direction_to(
			get_global_mouse_position()
			)
		)
	bullet.on_fired()
