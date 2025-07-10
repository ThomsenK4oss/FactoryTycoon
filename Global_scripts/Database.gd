extends Node

var selected_belt: Dictionary = {}

var selected_machine: Dictionary = {
	"Name" : "Test", # The name of the machine
	"Scene" : "res://Scenes/Machines/machine.tscn", # The scene itselv
	"Cost" : 100, # The cost to build it
	"Output" : "cube" # What it outputs
}

var current_save: Dictionary = {
	"Gold" : 2000,
	
	"BaseFloorCost" : 1000,
	"FloorUpgradeAmount" : 0,
}

var Saves: Dictionary = {
	1 : {
		"Gold" : 2000,
		
		"BaseFloorCost" : 1000,
		"FloorUpgradeAmount" : 0,
	},
	
	2 : {
		"Gold" : 2000,
		
		"BaseFloorCost" : 1000,
		"FloorUpgradeAmount" : 0,
	},
	
	3 : {
		"Gold" : 2000,
		
		"BaseFloorCost" : 1000,
		"FloorUpgradeAmount" : 0,
	}
}

var machines: Dictionary = {
	"Test" : {
		"Name" : "Test", # The name of the machine
		"Scene" : "res://Scenes/Machines/machine.tscn", # The scene itselv
		"Cost" : 100, # The cost to build it
		"Output" : "cube" # What it outputs
	}
}

var conveyor_belts: Dictionary = {
	"Straight_Basic_Conveyor" : {
		"Name" : "Straight_Basic_Conveyor",
		"Scene" : "res://Scenes/Machines/Belts/Straight_Basic_Conveyor.tscn",
		"Cost" : 10,
		"Speed" : 1
	}
}

var placed_machines: Dictionary = {}

var placed_belts: Dictionary = {}
