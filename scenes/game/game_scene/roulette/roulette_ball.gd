extends RigidBody2D
class_name RouletteBall

static func _make_circle_points(radius: float, segments: int) -> PackedVector2Array:
	var points = PackedVector2Array()
	for i in range(segments):
		var angle = (float(i) / segments) * 2 * PI
		points.append(Vector2(cos(angle), sin(angle)) * radius)
	return points

static func get_random_vector2(_max_x: float, _max_y: float, size: float) -> Vector2:
	var angle = randf_range(0, 2 * PI)
	return Vector2(cos(angle), sin(angle)) * size

var rand_impulse_size : float = 1000

var decay_rate : float = 0.001
var angular_decay_rate : float = 0.001

var min_speed_threshold : float = 5
var fast_slowdown_speed : float = 100
var max_speed : float = 10000

# 0 = on a pocket floor,
# 1.0 = up at the rim.
# 0.5 = highest point in the centre
var height : float = 1.0:
	set(v):
		height = clampf(v, 0.0, 1.0)

## Marks the ball as settled and no longer updates physics
var settled : bool = false

func _init():
	mass = 1.0
	gravity_scale = 0

	var phys_mat = PhysicsMaterial.new()
	phys_mat.bounce = 1
	phys_mat.friction = 0.001
	physics_material_override = phys_mat

	# collision detecteion mode
	continuous_cd = RigidBody2D.CCD_MODE_CAST_RAY

	var shape = CircleShape2D.new()
	shape.radius = 10

	var collider = CollisionShape2D.new()
	collider.shape = shape
	add_child(collider)

	var visual = Polygon2D.new()
	visual.color = Color(0.93, 0.891, 0.13, 1.0)
	visual.polygon = _make_circle_points(shape.radius, 24)
	add_child(visual)

func give_random_impulse():
	apply_impulse(get_random_vector2(10, 10, rand_impulse_size))

func get_speed() -> float:
	return linear_velocity.length()

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if settled:
		state.linear_velocity = Vector2.ZERO
		state.angular_velocity = 0.0
		return
	
	var new_vel = state.linear_velocity
	if new_vel.length() < min_speed_threshold:
		new_vel = Vector2.ZERO
	elif new_vel.length() < fast_slowdown_speed:
		new_vel *= 0.99
	elif new_vel.length() > max_speed:
		new_vel = new_vel.normalized() * max_speed
	
	state.linear_velocity = new_vel


## Call when a bank divider "catches" the ball (see Roulette's bank logic).
## Kills the radial component of velocity and pulls height toward 0 so the
## ball visually/physically settles toward the pocket floor instead of
## continuing to slide around the ring.
func catch_in_pocket(center: Vector2) -> void:
	var to_center = (center - global_position).normalized()
	var radial_speed = linear_velocity.dot(-to_center)
	if radial_speed > 0:
		# Remove the outward-radial component of velocity, keep tangential
		# (so it doesn't stop dead, just stops climbing/orbiting outward).
		linear_velocity -= (-to_center) * radial_speed
	height = max(0.0, height - 0.4)

func settle() -> void:
	settled = true
	freeze = true
