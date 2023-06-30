extends CharacterBody2D


@onready var _player_skin: TextureRect = $PlayerSkin

const MOVEMENT_SPEED := 1000
const FRICTION := 90

var direction := Vector2.ZERO
var axis := Vector2.ZERO


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	_move(delta)


func _get_input_axis() -> Vector2:
	axis.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	axis.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	
	return axis.normalized()



func _move(p_delta : float) -> void:
	axis = _get_input_axis()
	
	if axis == Vector2.ZERO:
		_apply_friction(FRICTION)
	else:
		_apply_movement(axis * MOVEMENT_SPEED)
	
	move_and_slide()


func _apply_friction(p_amount : float) -> void:
	if velocity.length() > p_amount:
		velocity -= velocity.normalized() * p_amount
	else:
		velocity = Vector2.ZERO


func _apply_movement(p_velocity : Vector2) -> void:
	velocity = p_velocity
	velocity.limit_length(MOVEMENT_SPEED)
