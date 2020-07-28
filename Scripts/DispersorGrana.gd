extends Area2D

var grana_prefab = load("Grana.tscn")


func _ready():
	$Timer.wait_time = rand_range(2, 4)


func _on_Timer_timeout():
	var nova_grana = grana_prefab.instance()
	nova_grana.position = Vector2(rand_range(10, 380), -10)
	$Timer.wait_time = rand_range(2, 4)
	add_child(nova_grana)
