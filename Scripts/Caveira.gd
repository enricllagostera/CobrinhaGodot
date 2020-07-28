extends RigidBody2D


export var distancia_seguir = 30
var tolerancia = 0.5
var velocidade
var direcao = Vector2()
var alvo = null
var deslocamento_atual = Vector2()


func atualizarAnimacao(movimento, tolerancia):
	if movimento.length() > tolerancia:
		$Visual.play("Andando")
	else :
		$Visual.play("Parada")
	if Engine.time_scale >= 0.9:
		if alvo != null:
			$Visual.look_at(alvo.position)
		else:
			$Visual.look_at(position + movimento)
		$Visual.rotation_degrees += -90
	pass


func engatar(lider):
	alvo = lider
	tolerancia = alvo.tolerancia
	position = lider.position - lider.deslocamento_atual.normalized() * distancia_seguir
	pass


func morrer():
	queue_free();


func _physics_process(delta):
	var nova_posicao = position
	
	if alvo != null:
		direcao = (alvo.position - nova_posicao).normalized()
		nova_posicao = alvo.position - direcao * distancia_seguir
		atualizarAnimacao(position - nova_posicao, tolerancia)
		deslocamento_atual = nova_posicao - position

	position = nova_posicao
