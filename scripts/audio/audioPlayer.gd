extends Node
class_name AudioPlayer

@onready var musicPlayer: AudioStreamPlayer = $MusicPlayer
@onready var SFXPlayerPool: Array[AudioStreamPlayer3D] = [
	$SFXPlayer1,
	$SFXPlayer2,
	$SFXPlayer3
]
@onready var staticSFXPlayerPool: Array[AudioStreamPlayer] = [
	$Node/AudioStreamPlayer,
	$Node/AudioStreamPlayer2,
	$Node/AudioStreamPlayer3,
	$Node/AudioStreamPlayer4
]
@export var musicTracks: Array[AudioStream]

@onready var centerPoint: Node2D = $CenterPoint

var camera: Camera2D
var nextTrack: AudioStream
var FADE_OUT_DURATION_IN_SECONDS: float = 1.0
var FADE_IN_DURATION_IN_SECONDS: float = 1.0

# select N-th music track and play it
func setMusicTrack(index: int):
	if nextTrack != musicTracks[index]:
		if nextTrack == null:
			nextTrack = musicTracks[index]
			$MusicPlayer.volume_db = linear_to_db(0.1)
			on_fade()
			var tween = get_tree().create_tween()
			tween.tween_property($MusicPlayer, "volume_db", linear_to_db(1.0), FADE_IN_DURATION_IN_SECONDS)
			
		else:
			nextTrack = musicTracks[index]
			var tween = get_tree().create_tween()
			tween.tween_property($MusicPlayer, "volume_db", linear_to_db(0.1), FADE_OUT_DURATION_IN_SECONDS)
			tween.tween_callback(Callable(self, "on_fade"))
			tween.tween_property($MusicPlayer, "volume_db", linear_to_db(1.0), FADE_IN_DURATION_IN_SECONDS)

func on_fade():
	$MusicPlayer.stream = nextTrack
	$MusicPlayer.play()
	
# select first valid SFX player and make it play the sound from target position.
#takes into account current camera position
func playSFX(sfx: AudioStream, position: Vector3):
	var openSFXPlayers = SFXPlayerPool.filter(func(sfxPlayer: AudioStreamPlayer3D): return !sfxPlayer.playing)
	if len(openSFXPlayers) == 0:
		print("no open sfx players")
		return
	var selectedPlayer: AudioStreamPlayer3D = openSFXPlayers[0]
	selectedPlayer.stream = sfx
	selectedPlayer.position = position
	selectedPlayer.play()
	
func playSFXAtDefaultPosition(sfx: AudioStream):
	var openSFXPlayers = staticSFXPlayerPool.filter(func(sfxPlayer: AudioStreamPlayer): return !sfxPlayer.playing)
	if len(openSFXPlayers) == 0:
		print("no open sfx players")
		return
	var selectedPlayer: AudioStreamPlayer = staticSFXPlayerPool[0]
	selectedPlayer.stream = sfx
	selectedPlayer.play()
