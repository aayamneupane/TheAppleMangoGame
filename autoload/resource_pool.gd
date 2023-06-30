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
		var resource_instance : Node = eligible_resources[resource]["scene"].instantiate()
		eligible_resources[resource]["item_pool"].append(resource)
		add_child(resource_instance)


func get_item(p_item_type : int) -> Node:
	var item_data : Dictionary = _get_item_data(p_item_type)
	var item_pool : Array = item_data["item_pool"]
	var item : Node
	
	for pooled_item in item_pool:
		if item_pool != []:
			item = item_pool.pop_back()
			item_data["active_items"].append(item)
		else:
			# since this item is not taken from the pool, it is not appended in the active items
			item = item_data["scene"].instantiate()
			add_child(item)
	
	assert(item != null, "Possible Error : -> Scene Path Changed")
	return item


func de_activate_item(p_item_instance : Node, p_item_type : int) -> void:
	var item_data : Dictionary = _get_item_data(p_item_type)
	if p_item_instance in item_data["active_items"]:
		# move item from active_items [] to item_pool []
		item_data["active_items"].erase(p_item_instance)
		item_data["item_pool"].append(p_item_instance)
	else:
		p_item_instance.queue_free()


func _get_item_data(p_item_type : int) -> Dictionary:
	assert(eligible_resources.has(p_item_type), "PooledItem Key Doesnt exits in eligible_resources")
	return eligible_resources[p_item_type]
