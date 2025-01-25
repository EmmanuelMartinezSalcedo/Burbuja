extends Node2D

# Path to the fish scene
var fish_scene_path: String = "res://Scenes/sword_fish.tscn"
var spawn_interval: float = 2.0  # Intervalo de tiempo entre los spawns de los peces
var time_since_last_spawn: float = 0.0  # Tiempo desde el último spawn
var bubble_position: Vector2  # La posición de la burbuja
var spawn_radius: float = 400.0  # Rango para el desplazamiento de los peces debajo de la burbuja
var min_distance_below: float = 200.0  # Distancia mínima desde la burbuja donde el pez aparece

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Asume que la burbuja está en el nodo padre o ajusta según tu escena
	bubble_position = get_parent().position  # Posición de la burbuja (ajusta según la escena)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_since_last_spawn += delta  # Incrementar el tiempo transcurrido

	# Si ha pasado suficiente tiempo, hacer spawn de un nuevo pez
	if time_since_last_spawn >= spawn_interval:
		spawn_fish()
		time_since_last_spawn = 0.0  # Reiniciar el temporizador

# Función para hacer spawn de un pez en una posición debajo de la burbuja
func spawn_fish() -> void:
	# Cargar la escena del pez
	var fish_scene = load(fish_scene_path)

	# Crear una instancia de la escena del pez
	var fish_instance = fish_scene.instantiate()

	# Calcular una posición debajo de la burbuja
	var x_offset = randf_range(-spawn_radius, spawn_radius)  # Desplazamiento aleatorio en el eje X
	var y_offset = randf_range(min_distance_below, spawn_radius)  # Desplazamiento en el eje Y, siempre debajo

	# Establecer la nueva posición del pez, siempre debajo de la burbuja
	fish_instance.position = bubble_position + Vector2(x_offset, y_offset)

	# Agregar el pez a la escena
	get_parent().get_parent().add_child(fish_instance)
