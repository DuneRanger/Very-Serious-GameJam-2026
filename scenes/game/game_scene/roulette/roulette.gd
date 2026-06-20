class_name Roulette
extends Node2D

var cells = []

var mid_circle_rad : int = 100
var mid_circle_colour : Color = Color.SADDLE_BROWN
var inner_circle_rad : int = 500
var outer_circle_rad : int = 700
var outer_circle_colour : Color = Color.DARK_RED
var default_font : Font = ThemeDB.fallback_font;

const base_roulette_numbers : int = 24
const base_cell_weight : float = 1.0
# (base_roulette_numbers + 1) includes the green 0
var total_weight : float = (base_roulette_numbers + 1) * base_cell_weight

var rotation_speed : float = 0;

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
		print(position, cur_angle)
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

func decay_rotation(_delta):
	rotation_speed = max(0, min(rotation_speed - 0.01 * _delta, rotation_speed * 0.995))

func spin_roulette():
	rotation_speed = 0.2

func _process(_delta):
	decay_rotation(_delta)
	rotation += rotation_speed
