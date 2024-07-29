extends Node

@export var time : int #should go from 1 to 6 

signal turnEnded
signal timeChanged

func advanceTime():
	time += 1
	if time > 6 :
		time = 1
		turnEnded.emit()
	timeChanged.emit()
