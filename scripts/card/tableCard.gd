class_name TableCard

var resourceCardId: String
var position: Vector3
var instanceId: int

func _init(_id: String, _position: Vector3, _instanceId: int):
	self.resourceCardId = _id
	self.position = _position
	self.instanceId = _instanceId
