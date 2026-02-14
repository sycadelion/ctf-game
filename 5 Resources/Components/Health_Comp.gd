class_name HealthComp extends Node

signal took_damage(damage: int, attacker_pos: Vector3, hurtbox: Area3D)
signal took_damage_weak(damage: int, headshot_multi: int, attacker_pos: Vector3, hurtbox: Area3D)
signal took_healing(Recover_amount: int)
signal took_death_blow

const INVUL_TIME: float = 0.1

@export var HEALTH_MAX: int = 10
@export_group("Particles")
@export var particle_emitter: GPUParticles3D
@export var particle_marker: Node3D
@export var particle_amount: int
@export var particle_amount_weak: int
@export var particle_color: Color
@export var particle_color_alt: Color

var _health: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_health = HEALTH_MAX
	took_damage.connect(_receive_damage)
	took_damage_weak.connect(_receive_damage_weakpoint)
	took_healing.connect(_receive_health)
	took_death_blow.connect(owner.death)
	if particle_emitter:
		particle_emitter.amount = particle_amount
		if particle_color:
			particle_emitter.material_override.albedo_color = particle_color
			particle_emitter.material_override.emission = particle_color

func get_current_health() -> int:
	return _health

func _process(_delta: float) -> void:
	if _health <= 0:
		took_death_blow.emit()

func _receive_damage(damage: int, attacker_pos: Vector3, hurtbox: Area3D) -> void:
	var hit: bool = false
	if !hit:
		if particle_marker:
			particle_marker.look_at(attacker_pos)
			particle_marker.global_position.y = attacker_pos.y
		if particle_emitter:
			particle_emitter.amount = particle_amount
			if particle_color:
				particle_emitter.material_override.albedo_color = particle_color
				particle_emitter.material_override.emission = particle_color
			particle_emitter.restart()
		hit = true
		hurtbox.monitoring = false
		_health -= damage
		await get_tree().create_timer(INVUL_TIME).timeout
		hurtbox.monitoring = true
		hit = false

func _receive_damage_weakpoint(damage: int, headshot_multi: int, attacker_pos: Vector3, hurtbox: Area3D) -> void:
	var hit: bool = false
	if !hit:
		if particle_marker:
			particle_marker.look_at(attacker_pos)
			particle_marker.global_position.y = attacker_pos.y
		if particle_emitter:
			particle_emitter.amount = particle_amount_weak
			if particle_color_alt:
				particle_emitter.material_override.albedo_color = particle_color_alt
				particle_emitter.material_override.emission = particle_color_alt
			particle_emitter.restart()
		hit = true
		hurtbox.monitoring = false
		_health -= damage * headshot_multi
		await get_tree().create_timer(INVUL_TIME).timeout
		hurtbox.monitoring = true
		hit = false

func _receive_health(Recover_amount: int) -> void:
	_health += Recover_amount
