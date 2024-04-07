extends AudioStreamPlayer

var effect
var recording

func _ready():
	var idx = AudioServer.get_bus_index('Microphone')
	effect = AudioServer.get_bus_effect(idx, 0)
	print('AudioStream ready')
	start_playing()
	
func start_playing():
	print('Start playing')
	var mic = AudioStreamMicrophone.new()
	self.stream = mic;
	self.play()
	
func _input(event):
	if event is InputEventAction:
		if event.is_action_pressed("start_playing_mic"):
			start_playing()

	
		
