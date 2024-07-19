extends Node
class_name AudioPlayer

@onready var musicPlayer: AudioStreamPlayer = $MusicPlayer
@onready var SFXPlayers: Array[AudioStreamPlayer2D] = [
	$SFXPlayer1,
	$SFXPlayer2,
	$SFXPlayer3,
	$SFXPlayer4,
	$SFXPlayer5
]

@export var musicTracks: Array[AudioStream]

@onready var centerPoint: Node2D = $CenterPoint

var camera: Camera2D
var nextTrack: AudioStream
var FADE_OUT_DURATION_IN_SECONDS: float = 2.0
var FADE_IN_DURATION_IN_SECONDS: float = 2.0

# select N-th music track and play it
func setMusicTrack(index: int):
	nextTrack = musicTracks[index]
	var previousColume = $MusicPlayer.volume_db
	var tween = get_tree().create_tween()
	tween.tween_property($MusicPlayer, "volume_db", linear_to_db(0.0), FADE_OUT_DURATION_IN_SECONDS)
	tween.tween_callback(Callable(self, "on_fade"))
	tween.tween_property($MusicPlayer, "volume_db", previousColume, FADE_IN_DURATION_IN_SECONDS)

func on_fade():
	$MusicPlayer.stream = nextTrack
	$MusicPlayer.play()
	
# select first valid SFX player and make it play the sound from target position.
#takes into account current camera position
func playSFX(sfx: AudioStream, position: Vector2):
	var openSFXPlayers = SFXPlayers.filter(func(sfxPlayer: AudioStreamPlayer2D): return !sfxPlayer.playing)
	if len(openSFXPlayers) == 0:
		print("no open sfx players")
		return
	var selectedPlayer: AudioStreamPlayer2D = openSFXPlayers[0]
	selectedPlayer.stream = sfx
	var cameraViewportOrigin = centerPoint.get_viewport_transform().get_origin()
	selectedPlayer.position = position - cameraViewportOrigin
	selectedPlayer.play()
