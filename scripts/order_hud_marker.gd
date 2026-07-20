extends Node2D

var target_order : OrderManager.Order = null

var margin := 52.0

@onready var item_icon: Sprite2D = $ItemIcon


func set_order(new_order : OrderManager.Order) -> void:
	target_order = new_order # I like their song Blue Monday. Bizzare Love Triangle, too.
	if new_order == null:
		visible = false
		return
	visible = not is_dest_on_screen()
	item_icon.texture = target_order.item.sprite

func is_dest_on_screen() -> bool:
	return get_viewport().get_visible_rect().has_point(target_order.destination.global_position)

func get_camera_rect():
	var camera := get_viewport().get_camera_2d()
	var rect := Rect2()
	rect.size = get_viewport().get_visible_rect().size
	rect.position = camera.global_position - (rect.size / 2)
	return rect

# This is already assuming the point is outsize the rect
func calculate_intersection_offset(rect, vec) -> Vector2:
	var center : Vector2 = rect.get_center()
	var to_dest = vec - center
	var extents = rect.size / 2
	# Just one more check, to be sure
	if vec.is_zero_approx():
		return center
	# Scaling factors or something
	var scale_x = abs(extents.x / to_dest.x) if to_dest.x != 0 else 999999
	var scale_y = abs(extents.y / to_dest.y) if to_dest.y != 0 else 999999
	
	var final_scale = min(scale_x, scale_y)
	# This Might work ??
	return to_dest * final_scale
	

func _process(_delta: float) -> void:
	visible = not is_dest_on_screen()
	if not visible:
		return
	
	# Calculate position
	var cam_rect = get_camera_rect()
	var intersection := calculate_intersection_offset(cam_rect, target_order.destination.global_position)
	# Apply margin
	intersection = (intersection.length() - margin) * intersection.normalized()
	
	# I have no idea if any of this works
	global_position = intersection
