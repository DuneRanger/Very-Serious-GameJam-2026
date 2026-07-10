class_name RouletteCellManager

var roulette
var total_weight: float = 0
# in % of the total weight/wheel
var cell_size_limit = 0.018

var cells: Array[RouletteCell]:
	get: return GameManagerGlobal.cells
	set(value): GameManagerGlobal.cells = value

var initial_cell_order: Array[int] = [0, 20, 6, 8, 18, 14, 2, 4, 21, 1, 13, 3, 24, 7, 15, 19, 10, 12, 22, 5, 16, 9, 11, 23, 17]
func prepare_initial_cells():
	if len(GameManagerGlobal.initial_cells) != 0: return
	for i in len(initial_cell_order):
		var curCol = Color.RED
		var num = initial_cell_order[i]
		if i % 2 == 0: curCol = Color.BLACK
		if num == 0: curCol = Color.DARK_GREEN
		GameManagerGlobal.initial_cells.append(RouletteCell.new(num, curCol))

func overwrite_cells(new_cells: Array[RouletteCell]):
	cells.clear()
	for cell in new_cells: cells.append(cell.duplicate())
	update_total_weight()

func reset_cells():
	overwrite_cells(GameManagerGlobal.initial_cells)

func full_reset():
	reset_cells()

func update_total_weight():
	total_weight = 0
	for cell in cells:
		total_weight += cell.weight

func randomize_weights():
	for cell in cells:
		cell.weight = randf_range(0.5, 2)
	update_total_weight()

func modify_cell_weight(idx: int, change: float):
	cells[idx].weight += change
	commit_cell_mod()

func remove_small_cells():
	var idx_to_remove = cells.find_custom(func(cell): return cell.weight / total_weight < cell_size_limit)
	while idx_to_remove != -1:
		print("Removing cell %s because of size" % cells[idx_to_remove])
		total_weight -= cells[idx_to_remove].weight
		cells.remove_at(idx_to_remove)
		idx_to_remove = cells.find_custom(func(cell): return cell.weight / total_weight < cell_size_limit)

func commit_cell_mod():
	update_total_weight()
	remove_small_cells()
