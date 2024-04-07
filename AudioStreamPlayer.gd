extends AudioStreamPlayer

var effect
var streaming

func _ready():
	var idx = AudioServer.get_bus_index('')
