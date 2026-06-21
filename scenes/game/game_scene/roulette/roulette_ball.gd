extends RigidBody2D
class_name RouletteBall

static func _make_circle_points(radius: float, segments: int) -> PackedVector2Array:
	var points = PackedVector2Array()
	for i in range(segments):
		var angle = (float(i) / segments) * 2 * PI
		points.append(Vector2(cos(angle), sin(angle)) * radius)
	return points

static func get_random_vector2(size: float) -> Vector2:
	var angle = randf_range(0, 2 * PI)
	return Vector2(cos(angle), sin(angle)) * size
 
var rand_impulse_size : float = 1000

func _init():
	mass = 1.0
	gravity_scale = 0
	
	var phys_mat = PhysicsMaterial.new()
	phys_mat.bounce = 0.8
	phys_mat.friction = 0.2
	#phys_mat.absorbent = 0.00000000001
	phys_mat.rough = 1
	physics_material_override = phys_mat
	
	var shape := CircleShape2D.new()
	shape.radius = 10
 
	var collider := CollisionShape2D.new()
	collider.shape = shape
	add_child(collider)
	
	var visual := Polygon2D.new()
	visual.color = Color(0.93, 0.891, 0.13, 1.0)
	visual.polygon = _make_circle_points(shape.radius, 24)
	add_child(visual)

func give_random_impulse():
	apply_impulse(get_random_vector2(rand_impulse_size))
