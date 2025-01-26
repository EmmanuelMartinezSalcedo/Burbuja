extends Node2D

# Paths a las escenas de los peces y las tortugas
var fish_scene_path: String = "res://Scenes/sword_fish.tscn"
var turtle_scene_path: String = "res://Scenes/turtle.tscn"
var fish_spawn_interval: float = 5.0  # Intervalo de tiempo entre los spawns de los peces
var turtle_spawn_interval: float = 5.0  # Intervalo de tiempo entre los spawns de las tortugas
var time_since_last_fish_spawn: float = 0.0  # Tiempo desde el último spawn de pez
var time_since_last_turtle_spawn: float = 0.0  # Tiempo desde el último spawn de tortuga
var bubble_position: Vector2  # La posición de la burbuja
var spawn_radius: float = 400.0  # Rango para el desplazamiento de las criaturas debajo de la burbuja
var min_distance_below: float = 1000.0  # Distancia mínima desde la burbuja donde las criaturas aparecen

@export var player_reference : Node2D
@export var bubble_reference : Node2D

# Llamado cuando el nodo entra por primera vez al árbol de nodos
func _ready() -> void:
	# Asume que la burbuja está en el nodo padre o ajusta según tu escena
	bubble_position = get_parent().position  # Posición de la burbuja (ajusta según la escena)

# Llamado cada frame. 'delta' es el tiempo transcurrido desde el último frame
func _process(delta: float) -> void:
	# Si la burbuja se mueve, actualiza la posición
	bubble_position = player_reference.position  # Posición de la burbuja (ajusta según la escena)
	
	# Incrementar el tiempo transcurrido para cada tipo de criatura
	time_since_last_fish_spawn += delta  
	time_since_last_turtle_spawn += delta  

	# Si ha pasado suficiente tiempo, hacer spawn de un nuevo pez
	if time_since_last_fish_spawn >= fish_spawn_interval:
		spawn_fish()  # Llamamos a la función para hacer spawn de un pez
		time_since_last_fish_spawn = 0.0  # Reiniciar el temporizador para peces

	# Si ha pasado suficiente tiempo, hacer spawn de una nueva tortuga
	if time_since_last_turtle_spawn >= turtle_spawn_interval:
		spawn_turtle()  # Llamamos a la función para hacer spawn de una tortuga
		time_since_last_turtle_spawn = 0.0  # Reiniciar el temporizador para tortugas

# Función para hacer spawn de un pez en una posición debajo de la burbuja
func spawn_fish() -> void:
	# Cargar la escena del pez
	var fish_scene = load(fish_scene_path)

	# Crear una instancia de la escena del pez
	var fish_instance = fish_scene.instantiate()
	fish_instance.bubble_position = bubble_reference.position
	fish_instance.direction_to_bubble = (bubble_reference.position - position).normalized()

	# Calcular una posición debajo de la burbuja
	var x_offset = randf_range(-spawn_radius, spawn_radius)  # Desplazamiento aleatorio en el eje X
	var y_offset = randf_range(min_distance_below, spawn_radius)  # Desplazamiento en el eje Y, siempre debajo

	# Establecer la nueva posición del pez
	fish_instance.position = bubble_position + Vector2(x_offset, y_offset)

	# Agregar el pez a la escena
	add_child(fish_instance)

# Función para hacer spawn de una tortuga en una posición debajo de la burbuja
func spawn_turtle() -> void:
	# Cargar la escena de la tortuga
	var turtle_scene = load(turtle_scene_path)

	# Crear una instancia de la escena de la tortuga
	var turtle_instance = turtle_scene.instantiate()
	turtle_instance.bubble_position = bubble_position
	turtle_instance.player = player_reference
	turtle_instance.direction_to_player = (player_reference.position - position).normalized()  # Dirección hacia el jugador

	# Calcular una posición debajo de la burbuja
	var x_offset = randf_range(-spawn_radius, spawn_radius)  # Desplazamiento aleatorio en el eje X
	var y_offset = randf_range(min_distance_below, spawn_radius)  # Desplazamiento en el eje Y, siempre debajo

	# Establecer la nueva posición de la tortuga
	turtle_instance.position = bubble_position + Vector2(x_offset, y_offset)

	# Agregar la tortuga a la escena
	add_child(turtle_instance)
