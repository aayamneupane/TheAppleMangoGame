class_name Bullet
extends RigidBody2D

const SPEED := 2000

var target := Vector2.ZERO
var velocity := Vector2.ZERO


func on_fired() -> void:
	velocity = target * SPEED
	apply_impulse(velocity, Vector2().rotated(rotation))


func set_target(p_direction : Vector2) -> void:
	target = p_direction


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	_destroy()


func _destroy() -> void:
	queue_free()
