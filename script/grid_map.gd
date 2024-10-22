extends GridMap

var noise:FastNoiseLite = FastNoiseLite.new()
var noise1:FastNoiseLite = FastNoiseLite.new()

@export var max_x = 1000
@export var max_z = 1000
@onready var character_body_3d: CharacterBody3D = $"../CharacterBody3D"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("HelloWorld")
	#
	#for x in max_x:
		#for z in max_z:
			#set_cell_item(Vector3i(x,0,z),1)
	
	randomize()
	
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise1.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = 0.0005
	#noise.fractal_lacunarity = 3.005
	#noise.fractal_gain=0.875


	generate_level()
	#generate_flower()
 # Replace with function body.

func generate_level() -> void:
	for x in max_x:
		for z in max_z:
			var tile_id = noise.get_noise_2d(x,z)
			var tile_id1 = noise1.get_noise_2d(x,z)
			set_cell_item(Vector3i(x,(int((tile_id+tile_id1)*1000)),z),1)
			pass

func generate_id(noise_level) -> int:
	if(noise_level <= -0.1):
		return -1
	else:
		return 0
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#generate_chunk(character_body_3d.position)
	pass

func generate_chunk(position)->void:
	var tile_id = local_to_map(position)

	for x in range(max_x):
		for z in range(max_z):
			var myX = tile_id.x - max_x/2 + x
			var myZ = tile_id.z - max_z/2 + z
			var noiseValue = noise.get_noise_2d(myX,myZ)
			set_cell_item(Vector3(myX,int(noiseValue * 1000),myZ),1)
