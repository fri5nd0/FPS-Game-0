extends Node

@onready var menu = $CanvasLayer/MainMenu
@onready var address = $CanvasLayer/MainMenu/MC/Options/address_input
const port = 9999
const Player = preload("res://Player.tscn")
var enet_p = ENetMultiplayerPeer.new()

func _on_host_b_pressed():
	menu.hide()
	enet_p.create_server(port)
	multiplayer.multiplayer_peer = enet_p
	multiplayer.peer_connected.connect(add_player)
	add_player(multiplayer.get_unique_id())

func _on_join_b_pressed():
	menu.hide()
	enet_p.create_client('localhost',port)
	multiplayer.multiplayer_peer = enet_p
	
func add_player(peer_id):
	var player = Player.instantiate()
	player.name = str(peer_id)
	add_child(player)
 
