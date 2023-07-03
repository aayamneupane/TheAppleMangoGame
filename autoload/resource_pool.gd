extends Node

const STATIC_STATE_POSITION := Vector2(-100, -100)

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
	for resource_data in eligible_resources:
		for i in eligible_resources[resource_data]["pool_size"]:
			var resource_instance : Node = eligible_resources[resource_data]["scene"].instantiate()
			eligible_resources[resource_data]["item_pool"].append(resource_instance)
			
			get_tree().get_root().call_deferred("add_child", resource_instance)
	
	pass


func get_item(p_item_type : int) -> Node:
	var item_data : Dictionary = _get_item_data(p_item_type)
	var item_pool : Array = item_data["item_pool"]
	var item : Node
	
	if item_pool != []:
		item = item_pool.pop_back()
		item_data["active_items"].append(item)
	else:
			# since this item is not taken from the pool, it is not appended in the active items
		item = item_data["scene"].instantiate()
		get_tree().get_root().call_deferred("add_child", item)
	
	assert(item != null, "Possible Error : -> Scene Path Changed")
	return item


func de_activate_item(p_item_instance : Node, p_item_type : int) -> void:
	var item_data : Dictionary = _get_item_data(p_item_type)
	
	if p_item_instance in item_data["active_items"]:
		# move item from active_items [] to item_pool []
		item_data["active_items"].erase(p_item_instance)
		assert(item_data["item_pool"].size() <= item_data["pool_size"])
		item_data["item_pool"].push_front(p_item_instance)
	else:
		p_item_instance.queue_free()


func _get_item_data(p_item_type : int) -> Dictionary:
	assert(eligible_resources.has(p_item_type), "PooledItem Key Doesnt exits in eligible_resources")
	return eligible_resources[p_item_type]


func get_static_state_position() -> Vector2:
	return STATIC_STATE_POSITION
