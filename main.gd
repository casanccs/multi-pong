extends Node2D

@onready var PlayerScene = load("res://player.tscn")
@onready var BallScene = load("res://ball.tscn")
# 192.168.1.167
@onready var IP_ADDRESS = $Menu/Address.text
var PORT = 7000
var players = {}
'''
{1: {name: "asdfasdf"}, 2393503: {name: "something"}, 21234: {}}
'''
var player_info = {}

func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.connected_to_server.connect(connected_to_server)
	
func _process(delta):
	IP_ADDRESS = $Menu/Address.text
	player_info = {"name": $Menu/Name.text}
	
func peer_connected(id):
	print("Peer: ", id)
	register(id)

func register(id):
	players[id] = player_info
	
func connected_to_server():
	print("Connected to server: ", multiplayer.get_unique_id())

func _on_host_pressed():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, 4)
	multiplayer.multiplayer_peer = peer
	$Menu/Host.visible = false
	$Menu/Join.visible = false
	$Menu/Name.visible = false
	$Menu/Address.visible = false
	
	players[multiplayer.get_unique_id()] = player_info

func _on_join_pressed():
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(IP_ADDRESS, PORT)
	multiplayer.multiplayer_peer = peer
	$Menu.visible = false


func _on_start_pressed():
	var direction = Vector2(randi_range(-500,500), randi_range(-500,500)) 
	start.rpc(players, direction)
	$Timer.start()

@rpc("call_local")
func start(nplayers, direction):
	players = nplayers
	print("Players: ",players)
	$Menu.visible = false
	var c = 1
	for i in players:
		var cPlayer = PlayerScene.instantiate()
		cPlayer.set_multiplayer_authority(i)
		cPlayer.c = c
		add_child(cPlayer)
		if c == 1:
			cPlayer.global_position = $spawn1.global_position
			cPlayer.add_to_group("hp")
		if c == 2:
			cPlayer.global_position = $spawn2.global_position
			cPlayer.add_to_group("hp")
		if c == 3:
			cPlayer.global_position = $spawn3.global_position
			cPlayer.rotation = deg_to_rad(90)
			cPlayer.add_to_group("vp")
		if c == 4:
			cPlayer.global_position = $spawn4.global_position
			cPlayer.rotation = deg_to_rad(90)
			cPlayer.add_to_group("vp")
		c += 1
	
	var ball = BallScene.instantiate()
	ball.position = Vector2(380,380)
	if direction.length() == 0:
		ball.velocity = Vector2(0,300)
	else:
		ball.velocity = direction/direction.length() * 300
	add_child(ball)


func _on_test_pressed():
	test.rpc()
	
@rpc
func test():
	print("Hi everyone")


func _on_timer_timeout():
	var direction = Vector2(randi_range(-500,500), randi_range(-500,500))
	spawn_ball.rpc(direction)
	
@rpc("call_local")
func spawn_ball(direction):
	var ball = BallScene.instantiate()
	ball.position = Vector2(380,380)
	if direction.length() == 0:
		ball.velocity = Vector2(0,300)
	else:
		ball.velocity = direction/direction.length() * 300
	add_child(ball)
	
