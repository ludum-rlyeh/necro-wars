extends "state.gd"

const LevelApi = preload("res://common/scripts/LevelApi.gd")

var unit
var movement_zone
var attack_zone

func _ready():
	pass

func _input(event):
	if event.is_pressed() :

		if event.is_action("ui_cancel"):
			state_machine.transition("free_state", null)

		if event.is_action("ui_select"):
			if target.get_unit_at_pos(target.pos) == null:
				var cell = target.map.get_cellv(target.pos)

				if movement_zone.has(cell.pos):
					self.unit.move(target.pos)
					state_machine.transition("free_state", null)

func _process(delta):
	pass

func _on_enter_state(data):
	self.unit = data

	var movement_zone = target.level.dijkstra(
		self.unit.pos, 
		self.unit.speed
	)

	if movement_zone != null:
		self.movement_zone = movement_zone
		self.attack_zone = target.level.get_attack_range(movement_zone)

		target.level.display_circle(attack_zone)
		target.level.display_zone(movement_zone)

	print("Unit selected: " + str(data))

func _on_leave_state(data):
	self.unit = null
	target.level.clear_zones()
	print("Unit de-selected: " + str(data))