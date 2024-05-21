extends Control

@onready var coins_counter = $container/coins_container/coins_counter
@onready var score_counter = $container/score_container/score_counter
@onready var life_counter = $container/life_container/life_counter

func _ready():
	coins_counter.text = str("%04d" % Globals.coins)
	score_counter.text = str("%06d" % Globals.score)
	life_counter.text = str("%02d" % Globals.player_life)

func _process(delta):
	coins_counter.text = str("%04d" % Globals.coins)
	score_counter.text = str("%06d" % Globals.score)
	life_counter.text = str("%02d" % Globals.player_life)
