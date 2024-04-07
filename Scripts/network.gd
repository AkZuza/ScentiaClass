extends Node
const DEFAULT_PORT=8000
const MAX_CLIENTS=6

var server=null
var client = null

var ip_address="127.0.0.1"
func _ready():
	get_tree().connect("connected_to_server",self,"_connected_to_server")
	get_tree().connect("server_disconnected",self,"_server_disconnected")
	get_tree().connect("connection_failed",self,"_connection_failed")
	get_tree().connect("nework_peer_connected",self,"_player_connected")
	
func create_server():
	print("creating server")
	server=NetworkedMultiplayerENet.new()
	server.create_server(DEFAULT_PORT,MAX_CLIENTS)
	print(ip_address)
	get_tree().set_network_peer(server)
	
func join_server():
	print("Joining Server")
	client=NetworkedMultiplayerENet.new()
	print(ip_address)
	client.create_client(ip_address,DEFAULT_PORT)
	get_tree().set_network_peer(client)

func _connected_to_server():
	print("Connected to server")
	
func _player_connected(id):
	print("Player Connected:"+id)
func _server_disconnected():
	print("Disconnected from server")
	reset_network_conection()
func _connection_failed():
	
	print("Connection failed")
	reset_network_conection()
	
func reset_network_conection():
	if get_tree().has_network_peer():
		get_tree().network_peer=null
		


