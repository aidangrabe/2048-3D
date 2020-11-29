extends RigidBody


signal on_cubes_merged

onready var mesh = $MeshInstance

var value = 2

func _ready():
	var initial_value_index = 1 + randi() % 6
	set_value(pow(2, initial_value_index))


func _on_Cube_body_entered(body):
	if body is RigidBody:
		if value == body.value:
			merge(body)
		
		
func merge(other):
	apply_central_impulse(Vector3(0, 6, 0))
	
	if not other.is_queued_for_deletion():
		var newValue = value * 2
		print("Merging " + str(value) + " -> " + str(newValue))
		
		set_value(newValue)
		other.set_value(newValue)
		
		queue_free()
		
		emit_signal("on_cubes_merged", newValue)
		

func set_value(value):	
	self.value = value
	
	var material = SpatialMaterial.new()
	material.uv1_scale = Vector3(3, 2, 1)
	material.albedo_color = Color(1, 1, 1)
	material.albedo_texture = load("res://assets/blocks/" + str(value) + ".png")
	mesh.material_override = material
	rotate_y(PI)
