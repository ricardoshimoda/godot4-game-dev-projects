extends RigidBody3D

signal stopped
signal touching
signal out_of_bounds

var first_touch = false

func shoot(angle, power):
	var force = Vector3.FORWARD.rotated(Vector3.UP, angle)
	apply_central_impulse(force * power)

func _integrate_forces(state):
	if !first_touch and is_on_floor():
		first_touch = true
		touching.emit()
	if state.linear_velocity.length() < 0.1:
		stopped.emit()
		state.linear_velocity = Vector3.ZERO
	if position.y < -20:
		out_of_bounds.emit()

func is_on_floor():
	if test_move(global_transform, Vector3.DOWN*0.0001 * get_physics_process_delta_time() ) == true:  
		return true  
	else:  
		return false
