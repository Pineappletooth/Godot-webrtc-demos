extends Control

# Default game server port. Can be any number between 1024 and 49151.
# Not present on the list of registered or common ports as of December 2022:
# https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers
const DEFAULT_PORT = 8910

@onready var room_code = $RoomCode
@onready var host_button = $HostButton
@onready var join_button = $JoinButton
@onready var status_ok = $StatusOk
@onready var status_fail = $StatusFail
@onready var room_label = $RoomNumberLabel
@onready var room_number = $RoomNumber
@onready var client = $Client
var peer = null
const address = "127.0.0.1:9080" #Replace this with your hosted address
func _ready():
	# Connect all the callbacks related to networking.
	multiplayer.peer_connected.connect(self._player_connected)
	multiplayer.peer_disconnected.connect(self._player_disconnected)
	multiplayer.connected_to_server.connect(self._connected_ok)
	multiplayer.connection_failed.connect(self._connected_fail)
	multiplayer.server_disconnected.connect(self._server_disconnected)
	client.lobby_joined.connect(self._lobby_joined)
	client.lobby_sealed.connect(self._lobby_sealed)
	client.connected.connect(self._connected)
	client.disconnected.connect(self._disconnected)
#### Network callbacks from SceneTree ####

# Callback from SceneTree.
func _player_connected(_id):
	# Someone connected, start the game!
	var pong = load("res://pong.tscn").instantiate()
	# Connect deferred so we can safely erase it from the callback.
	pong.game_finished.connect(self._end_game, CONNECT_DEFERRED)

	get_tree().get_root().add_child(pong)
	hide()


func _player_disconnected(_id):
	if multiplayer.is_server():
		_end_game("Client disconnected")
	else:
		_end_game("Server disconnected")


# Callback from SceneTree, only for clients (not server).
func _connected_ok():
	pass # This function is not needed for this project.


# Callback from SceneTree, only for clients (not server).
func _connected_fail():
	_set_status("Couldn't connect.", false)

	multiplayer.set_multiplayer_peer(null) # Remove peer.
	host_button.set_disabled(false)
	join_button.set_disabled(false)


func _server_disconnected():
	_end_game("Server disconnected.")

##### Game creation functions ######

func _end_game(with_error = ""):
	if has_node("/root/Pong"):
		# Erase immediately, otherwise network might show
		# errors (this is why we connected deferred above).
		get_node(^"/root/Pong").free()
		show()

	multiplayer.set_multiplayer_peer(null) # Remove peer.
	host_button.set_disabled(false)
	join_button.set_disabled(false)

	_set_status(with_error, false)


func _set_status(text, isok):
	# Simple way to show status.
	if isok:
		status_ok.set_text(text)
		status_fail.set_text("")
	else:
		status_ok.set_text("")
		status_fail.set_text(text)

func _connected(id,a):
	_log("[Signaling] Server connected with ID: %d" % id)


func _disconnected():
	_log("[Signaling] Server disconnected: %d - %s" % [client.code, client.reason])


func _lobby_joined(lobby):
	room_number.text = lobby
	_log("[Signaling] Joined lobby %s" % lobby)


func _lobby_sealed():
	_log("[Signaling] Lobby has been sealed")


func _log(msg):
	print(msg)

func _on_host_pressed():
	


	host_button.set_disabled(true)
	join_button.set_disabled(true)
	_set_status("Waiting for player...", true)

	# Only show hosting instructions when relevant.
	room_label.visible = true
	room_number.visible = true
	client.start(address, "", true)

func _on_join_pressed():
	var id = room_code.get_text()
	client.start(address, id, true)


	_set_status("Connecting...", true)


func _on_find_public_ip_pressed():
	OS.shell_open("https://icanhazip.com/")
