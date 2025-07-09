extends Node

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

var placed_machines: Dictionary = {}
