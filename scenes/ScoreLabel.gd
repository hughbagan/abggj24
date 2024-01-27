extends Label

var score = 0

func _on_mob_bounce(combo):
	if combo > score:
		score = combo
		text = str(score)

func _ready():
	text = str(score)

func _process(delta):
	pass
