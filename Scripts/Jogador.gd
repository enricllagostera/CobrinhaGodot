extends Node2D

var direcao = Vector2()
var caveiras = Array()
var deslocamento_atual
export var tolerancia = 0.5
export var velocidade = 50
export var inercia = 10
export var mudanca = 1

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
	if !OS.window_fullscreen:
			OS.window_fullscreen = true
	
	if event is InputEventJoypadMotion:
		if !OS.window_fullscreen:
			OS.window_fullscreen = true
		if event.axis == JOY_AXIS_0:
			direcao.x = event.axis_value
		else:
			direcao.y = event.axis_value
	else:
		direcao = Vector2()
		if Input.is_action_pressed("ui_left"):
			direcao.x += -1
		if Input.is_action_pressed("ui_right"):
			direcao.x += 1
		if Input.is_action_pressed("ui_up"):
			direcao.y += -1
		if Input.is_action_pressed("ui_down"):
			direcao.y += 1
		direcao = direcao.clamped(1)
	
	if Input.is_action_pressed("ui_cancel"):
		Engine.time_scale = 1
		get_tree().reload_current_scene()
	
	if event is InputEventJoypadButton:
		if !OS.window_fullscreen:
			OS.window_fullscreen = true
##		if event.button_index == JOY_BUTTON_0 and event.pressed:
##		if event.button_index == JOY_BUTTON_1 and event.pressed:
##			destruir_parte()
	pass


func _physics_process(delta):
	var deslocamento_combinado = deslocamento_atual.normalized()
	if(direcao.length() > tolerancia):
		deslocamento_combinado = deslocamento_atual.normalized() * inercia + direcao.clamped(1) * mudanca
	var deslocamento_desejado = deslocamento_combinado.clamped(1) * velocidade * delta
#	deslocamento_desejado = deslocamento_desejado.rotated(deg2rad(direcao.x * velocidade_rotacao))
	caveiras[0].position += deslocamento_desejado
	deslocamento_atual = deslocamento_desejado
	caveiras[0].atualizarAnimacao(deslocamento_atual, tolerancia)
	pass


func _on_Caveira_body_entered(body):
	if caveiras.has(body):
#		call_deferred("queue_free")
		Engine.time_scale = 0.001
		return
	
	if body.name.count("Grana") > 0:
		body.call_deferred("queue_free")
		adicionar_parte()
	
	pass # Replace with function body.
