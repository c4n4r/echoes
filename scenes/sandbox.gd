extends Node2D

@onready var music_player: AudioStreamPlayer = $Music
@onready var player: CharacterBody2D = $Present/Player
@onready var spawn: Node2D = $Spawn


func _ready() -> void:
	music_player.play()
	player.position = spawn.position
