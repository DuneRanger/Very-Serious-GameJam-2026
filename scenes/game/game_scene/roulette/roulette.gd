class_name Roulette
extends Node2D

static func get_random_vector2(size: float) -> Vector2:
	var angle = randf_range(0, 2 * PI)
	return Vector2(cos(angle), sin(angle)) * size
 
static func get_random_roulette_rot() -> float:
	return randf_range(-0.04, 0.04)

var cells = []
var default_font : Font = ThemeDB.fallback_font;

const base_roulette_numbers : int = 24
const base_cell_weight : float = 1.0
# (base_roulette_numbers + 1) includes the green 0
var total_weight : float = (base_roulette_numbers + 1) * base_cell_weight

enum CellMod {STICKY, SHINY}

class RouletteCell:
	var number
	var colour
	var weight
	var modifier
	
	func _init(num, col, w = base_cell_weight):
		number = num;
		colour = col;
		weight = w

func _init():
	cells.append(RouletteCell.new(0, Color.GREEN))
	for i in range(base_roulette_numbers):
		var curCol = Color.RED
		if i % 2 == 0: curCol = Color.BLACK
		cells.append(RouletteCell.new(i + 1, curCol))
	spin_roulette()

# -------------------------------- Drawing --------------------------------

var mid_circle_rad : int = 100
var mid_circle_colour : Color = Color.SADDLE_BROWN
var inner_circle_rad : int = 500
var outer_circle_rad : int = 700
var outer_circle_colour : Color = Color.DARK_RED

func draw_circle_arc_poly(center, radius, angle_from, angle_to, color):
	var nb_points = 32  + floor(100 * abs(angle_from - angle_to)) 
	var points_arc = PackedVector2Array()
	points_arc.push_back(center)
	var colors = PackedColorArray([color])

	for i in range(nb_points + 1):
		var angle_point = angle_from + i * (angle_to - angle_from) / nb_points
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	draw_polygon(points_arc, colors)

func draw_cells():
	var base_cell_angle = 2 * PI / total_weight
	var cur_angle = 0
	
	for cell in cells:
		# Actual angle length of the cell
		var cur_cell_angle = base_cell_angle * cell.weight
		# Modifies the draw angle so that the middle of the cell is perfectly vertical
		var draw_angle = -(PI + cur_cell_angle) / 2
		draw_circle_arc_poly(Vector2(0, 0), inner_circle_rad, draw_angle, draw_angle + cur_cell_angle, cell.colour)
		
		var font_max_width = sin(cur_cell_angle) * inner_circle_rad
		var font_size = 48
		draw_string(default_font, Vector2(-font_max_width / 2, -inner_circle_rad * 0.8), str(cell.number),
				HORIZONTAL_ALIGNMENT_CENTER, font_max_width, font_size)

		cur_angle += cur_cell_angle
		draw_set_transform(Vector2(0, 0), cur_angle)
	draw_set_transform(Vector2(0, 0))

func draw_centre():
	draw_circle(Vector2(0, 0), mid_circle_rad, mid_circle_colour)

func draw_edge():
	draw_circle(Vector2(0, 0), outer_circle_rad, outer_circle_colour)

func _draw():
	draw_edge()
	draw_cells()
	draw_centre()

# -------------------------------- Physics --------------------------------

var rotation_speed : float = 0;
var outer_wall_segments: int = 128

func build_outer_wall():
	var wall_body = StaticBody2D.new()
	add_child(wall_body)
 
	for i in range(outer_wall_segments):
		var angle_a = (float(i) / float(outer_wall_segments)) * 2 * PI
		var angle_b = (float(i + 1) / float(outer_wall_segments)) * 2 * PI
 
		var point_a = Vector2(cos(angle_a), sin(angle_a)) * outer_circle_rad
		var point_b = Vector2(cos(angle_b), sin(angle_b)) * outer_circle_rad
 
		var seg_shape = SegmentShape2D.new()
		seg_shape.a = point_a
		seg_shape.b = point_b
 
		var col = CollisionShape2D.new()
		col.shape = seg_shape
		wall_body.add_child(col)
 
	var visual = Line2D.new()
	visual.width = 20
	visual.closed = true
	visual.default_color = Color.BLACK
	for i in range(outer_wall_segments + 1):
		var angle = (float(i) / float(outer_wall_segments)) * 2 * PI
		visual.add_point(Vector2(cos(angle), sin(angle)) * outer_circle_rad)
	wall_body.add_child(visual)

func spin_roulette():
	rotation_speed = 0.02

func _ready():
	build_outer_wall()
	prepare_balls()
	launch_balls()

func _physics_process(_delta: float) -> void:
	rotation += rotation_speed

func _process(delta: float) -> void:
	pass

# -------------------------------- Balls --------------------------------

var balls = []

func prepare_balls():
	balls.append(RouletteBall.new())
	for ball in balls:
		add_child(ball)
 
func launch_balls() -> void:
	for ball in balls:
		if ball and is_instance_valid(ball):
			#ball.position = get_random_vector2(inner_circle_rad)
			#ball.give_random_impulse()
			ball.position = Vector2(outer_circle_rad - 10, 0)
			ball.apply_impulse(Vector2(0, 1000))
