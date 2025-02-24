extends Control


func _ready():
	gamestate.connect("connection_failed", self, "_on_connection_failed")
	gamestate.connect("connection_succeeded", self, "_on_connection_success")
	gamestate.connect("player_list_changed", self, "refresh_lobby")
	gamestate.connect("game_ended", self, "_on_game_ended")
	gamestate.connect("game_error", self, "_on_game_error")
	if OS.has_environment("USERNAME"):
		$Connect/Name.text = OS.get_environment("USERNAME")
	else:
		var desktop_path = OS.get_system_dir(0).replace("\\", "/").split("/")
		$Connect/Name.text = desktop_path[desktop_path.size() - 2]


func _on_host_pressed():
	print("Now player is host")
	if $Connect/Name.text == "":
		$Connect/ErrorLabel.text = "Invalid name!"
		return
	$Connect.hide()
	$Players.show()
	$Connect/ErrorLabel.text = ""
	var player_name = $Connect/Name.text
	gamestate.host_game(player_name)
	refresh_lobby()
	$SelectPanel.show()
	gamestate.set_character_index(get_tree().get_network_unique_id(), 0)


func _on_join_pressed():
	if $Connect/Name.text == "":
		$Connect/ErrorLabel.text = "Invalid name!"
		return
	var ip = $Connect/IPAddress.text
	if not ip.is_valid_ip_address():
		$Connect/ErrorLabel.text = "Invalid IP address!"
		return
	$Connect/ErrorLabel.text = ""
	$Connect/Host.disabled = true
	$Connect/Join.disabled = true
	var player_name = $Connect/Name.text
	gamestate.join_game(ip, player_name)
	
func _on_connection_success():
	$Connect.hide()
	$Players.show()
	gamestate.set_character_index(get_tree().get_network_unique_id(), 0)
	$SelectPanel.show()


func _on_connection_failed():
	$Connect/Host.disabled = false
	$Connect/Join.disabled = false
	$Connect/ErrorLabel.set_text("Connection failed.")


func _on_game_ended():
	show()
	$Connect.show()
	$Players.hide()
	$Connect/Host.disabled = false
	$Connect/Join.disabled = false


func _on_game_error(errtxt):
	$ErrorDialog.dialog_text = errtxt
	$ErrorDialog.popup_centered_minsize()
	$Connect/Host.disabled = false
	$Connect/Join.disabled = false


func refresh_lobby():
	var players = gamestate.get_player_list()
	players.sort()
	$Players/List.clear()
	$Players/List.add_item(gamestate.get_player_name() + " (You)")
	for p in players:
		$Players/List.add_item(p)
	$Players/Start.disabled = not get_tree().is_network_server()


func _on_start_pressed():
	gamestate.sync_player_sprites_with_master()
	gamestate.begin_game()
	


func _on_find_public_ip_pressed():
	OS.shell_open("https://icanhazip.com/")


func _on_Button_pressed():
	gamestate.set_character_index(get_tree().get_network_unique_id(), 0)
	$SelectPanel/Button2.pressed = false
	$SelectPanel/Button3.pressed = false
	$SelectPanel/Button4.pressed = false

func _on_Button2_pressed():
	gamestate.set_character_index(get_tree().get_network_unique_id(), 1)
	$SelectPanel/Button.pressed = false
	$SelectPanel/Button3.pressed = false
	$SelectPanel/Button4.pressed = false
	

func _on_Button3_pressed():
	gamestate.set_character_index(get_tree().get_network_unique_id(), 2)
	$SelectPanel/Button.pressed = false
	$SelectPanel/Button2.pressed = false
	$SelectPanel/Button4.pressed = false

func _on_Button4_pressed():
	gamestate.set_character_index(get_tree().get_network_unique_id(), 3)
	$SelectPanel/Button.pressed = false
	$SelectPanel/Button3.pressed = false
	$SelectPanel/Button2.pressed = false
