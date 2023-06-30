extends Node

# add eligible resources to the dictionary
var eligible_resources : Dictionary = {
	Config.PooledItems.BULLET : {
		"pool_size" : 10,
		"scene" : preload("res://bullet.tscn"),
		"item_pool" : [],
		"active_items" : []
	},
}


func _ready() -> void:
	_load_pools()


func _load_pools() -> void:
	# should loop on every data within eligible_resources
	for resource in eligible_resources:
		var resource_instance = eligible_resources[resource]["scene"].instantiate()
		eligible_resources[resource]["item_pool"].append(resource)
		add_child(resource_instance)


func get_item(p_item_type : int) -> Node:
	var item_pool : Array = eligible_resources[p_item_type]["item_pool"]
	var item : Node
	
	for pooled_item in item_pool:
		if item_pool != []:
			item = item_pool.pop_back()
			eligible_resources[p_item_type]["active_items"].append(item)
		else:
			item = eligible_resources[p_item_type]["scene"].instantiate()
	
	assert(item != null, "Possible Error : -> Scene Path Changed")
	return item
