class_name Bullet
extends CharacterBody2D

const SPEED := 2000

var target := Vector2.ZERO


func on_fired() -> void:
	velocity = target * SPEED


func _process(delta: float) -> void:
	if velocity.length() > 0:
		move_and_collide(velocity * delta)


func set_target(p_direction : Vector2) -> void:
	target = p_direction


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	ResourcePool.de_activate_item(self, Config.PooledItems.BULLET)
	velocity = Vector2.ZERO
	target = Vector2.ZERO
	position = ResourcePool.get_static_state_position()
