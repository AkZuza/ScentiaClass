extends Spatial
var player = preload("res://Student/Player.tscn")


func _ready():
	get_tree().connect("network_peer_connected",self,"_player_connected")
	get_tree().connect("network_peer_disconnected",self,"_player_disconnected")
	Global.connect("instance_player",self,"_instance_player")
	if get_tree().network_peer !=null:
		Global.emit_signal("toggle_network_setup",false)

func _instance_player(id):
	var _player_instance=player.instance()
	_player_instance.set_network_master(id)
	_player_instance.name=str(id)
	
	add_child(_player_instance)
	_player_instance.global_transform.origin=Vector3(0,15,0)
func _player_connected(id):
	print("Player"+str(id)+"has connected")
	_instance_player(id)
func _player_disconnected(id):
	print("player disconnected:")
	if has_node(str(id)):
		get_node(str(id)).queue_free()
