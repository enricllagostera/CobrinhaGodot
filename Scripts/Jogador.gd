extends Node2D

var direcao = Vector2()
var caveiras = Array()
var deslocamento_atual
export var tolerancia = 0.5
export var velocidade = 50
export var velocidade_rotacao = 2
export var incremento_velocidade = 5
var caveiraPrefab = load("Caveira.tscn")

func adicionar_parte():
	var newC = caveiraPrefab.instance()
	newC.velocidade = velocidade
	newC.engatar(caveiras[caveiras.size()-1])
	add_child(newC)
	caveiras.append(newC)
	velocidade += incremento_velocidade
	for c in caveiras:
		c.velocidade = velocidade
	pass


func destruir_parte():
	caveiras[caveiras.size()-1].morrer()
	caveiras.remove(caveiras.size()-1)
	pass


func _ready():
	deslocamento_atual = Vector2(0, 1)
	caveiras.append($Caveira)
	$Caveira/Visual.scale = Vector2.ONE * 1.3
	pass


func _input(event):
	if event is InputEventJoypadMotion:
		if event.axis == JOY_AXIS_0:
			direcao.x = event.axis_value
		else:
			direcao.y = event.axis_value
	
#	if event is InputEventJoypadButton:
##		if event.button_index == JOY_BUTTON_0 and event.pressed:
##		if event.button_index == JOY_BUTTON_1 and event.pressed:
##			destruir_parte()
	pass


func _physics_process(delta):
	var deslocamento_desejado = deslocamento_atual.normalized() * velocidade * delta
	deslocamento_desejado = deslocamento_desejado.rotated(deg2rad(direcao.x * velocidade_rotacao))
	caveiras[0].position += deslocamento_desejado
	deslocamento_atual = deslocamento_desejado
	caveiras[0].atualizarAnimacao(deslocamento_atual, tolerancia)
	pass


func _on_Caveira_body_entered(body):
	if caveiras.has(body):
		call_deferred("queue_free")
		return
	
	if body.name.count("Grana") > 0:
		body.call_deferred("queue_free")
		adicionar_parte()
	
	pass # Replace with function body.
