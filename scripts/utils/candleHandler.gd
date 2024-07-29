extends Node

@export var candleStrength : float
const candleLimitDown : int = 0

signal candleValueChanged
signal candleReachedLimit

func reduceStrengthBy(value : float):
	candleStrength -= value
	if candleStrength <= candleLimitDown:
		candleReachedLimit.emit()
		return
	candleValueChanged.emit()

func addStrengthBy(value : float):
	candleStrength += value
	candleValueChanged.emit()

func candleStrengthInInt() -> int:
	return floori(candleStrength)
