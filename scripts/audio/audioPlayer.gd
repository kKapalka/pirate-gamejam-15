extends Node
class_name AudioPlayer

@onready var musicPlayer: AudioStreamPlayer = $MusicPlayer
@onready var SFXPlayers: Array[AudioStreamPlayer2D] = [
	$SFXPlayer1,
	$SFXPlayer2,
	$SFXPlayer3
]

@export var musicTracks: Array[AudioStream]

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
func playSFX(sfx: AudioStream, position: Vector2i):
	var openSFXPlayers = SFXPlayers.filter(func(sfxPlayer: AudioStreamPlayer2D): return sfxPlayer.finished)
	if len(openSFXPlayers) == 0:
		print("no open sfx players")
		return
	var selectedPlayer: AudioStreamPlayer2D = openSFXPlayers[0]
	selectedPlayer.stream = sfx
	selectedPlayer.position = position
	selectedPlayer.play()
