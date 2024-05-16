extends Area2D

@onready var spikes = $spikes as Sprite2D
@onready var collision = $collision as CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	collision.shape.size = spikes.get_rect().size

func _on_body_entered(body):
	if body.name == "player" && body.has_method("take_damage"):
		body.take_damage(Vector2(0, -250))
