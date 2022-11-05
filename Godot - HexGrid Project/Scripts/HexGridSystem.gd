extends MultiMeshInstance3D

@export var GridSize : int = 10
@export var HeightStrength : float = 0.25
@export var WaterHeight : float = 0
@export var NumInstances : int = 2500

@export var Underwater : Color
@export var Grass : Color
@export var Coast : Color
@export var Snow : Color

# Noise Type: Simplex = 0, SimplexSmooth = 1, Cellular = 2, Perlin = 3
# Fractal Type: None = 0, FBM = 1, Ridged = 2, PingPong = 3

var heightNoise = FastNoiseLite.new()
var d_noisetype = 3
var d_fractaltype = 1
var d_seed = randi()
var d_freq = .01
var d_octaves = 2
var d_lac = 2.3
var d_gain = .6

# Configure noise
func construct_noise(noisetype,fractaltype,seed,freq,octaves,lac,gain):
	
	heightNoise.noise_type = noisetype
	heightNoise.fractal_type = fractaltype
	heightNoise.seed = seed
	heightNoise.frequency = freq
	heightNoise.fractal_octaves = octaves
	heightNoise.fractal_lacunarity = lac
	heightNoise.fractal_gain = gain

# Set water mesh to grid size
func construct_water():
	var GridAABB = self.multimesh.get_aabb()
	var GridCenter = GridAABB.get_center()
	
	$Water.set("position",Vector3(GridCenter.x,WaterHeight,GridCenter.z))
	$Water.set("scale",Vector3(GridAABB.size.x,1,GridAABB.size.z))

# Called when the node enters the scene tree for the first time.
func _ready():
	
	construct_noise(d_noisetype,d_fractaltype,d_seed,d_freq,d_octaves,d_lac,d_gain)
	
	self.multimesh.set_instance_count(0) #Clear instances
	
	self.multimesh.set_instance_count(NumInstances)
	
	var MeshAABB = self.multimesh.mesh.get_aabb() # Get bounding box of instanced mesh
	
	for x in range(GridSize): # Loop through row and column to build grid
		for z in range(GridSize):
			
			var RowOffset # Create RowOffset variable
			var InstanceID = z * GridSize + x # Determine Instanced ID
			var InstanceCusData
			var TileLocation = Vector2(0,0)
			var InstanceNoiseValue
			var TileHeight
			
			if z % 2 == 0: # Check if looping through even or odd row
				RowOffset = 0 # If EVEN, no row offset
			else:
				RowOffset = MeshAABB.size.x / 2 #If ODD, offset row by mesh radius
			
			# Set initial grid transforms, without height adjustment
			self.multimesh.set_instance_transform(InstanceID, Transform3D(Basis(), Vector3((x * MeshAABB.size.x) + RowOffset, 0, -z * MeshAABB.size.z * 0.75))) #Set tile grid position and adjust height by randomized custom data
			
			# Get the transform of tile
			TileLocation = self.multimesh.get_instance_transform(InstanceID)
			
			# Get noise value at tile location
			InstanceNoiseValue = heightNoise.get_noise_2d(TileLocation.origin.x,TileLocation.origin.z)
			
			# Set new height of tile with noise value
			self.multimesh.set_instance_transform(InstanceID, Transform3D(Basis(), Vector3((x * MeshAABB.size.x) + RowOffset, InstanceNoiseValue * HeightStrength, -z * MeshAABB.size.z * 0.75))) #Set tile grid position and adjust height by randomized custom data

			TileHeight = self.multimesh.get_instance_transform(InstanceID)

			# Set Custom Data value using tile height to pass to shader
			self.multimesh.set_instance_custom_data(InstanceID, Color(InstanceNoiseValue,TileHeight.origin.y,randf_range(-1,1),1)) #Noise Custom Data
			InstanceCusData = self.multimesh.get_instance_custom_data(InstanceID) #Set variable to custom data
			
			print (InstanceCusData.g)
			
			self.set_instance_shader_parameter("underwater", Underwater)
			self.set_instance_shader_parameter("grass", Grass)
			self.set_instance_shader_parameter("coast", Coast)
			self.set_instance_shader_parameter("snow", Snow)
			
	self.multimesh.set_instance_count(NumInstances)
	
	construct_water()

# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(_delta):

# Update grid with live values
func updategrid(size : int,strength : float,noisetype,fractaltype,seed,freq,octaves,lac,gain):
	
	construct_noise(noisetype,fractaltype,seed,freq,octaves,lac,gain)
	
	self.multimesh.set_instance_count(0) #Clear instances
	
	self.multimesh.set_instance_count(NumInstances) #Reestablish instances
	
	var MeshAABB = self.multimesh.mesh.get_aabb() #Get bounding box of instanced mesh
	
	for x in range(size): #Loop through row and column to build grid
		for z in range(size):
			
			var RowOffset #Create RowOffset variable
			var InstanceID = z * size + x # Determine Instanced ID
			var InstanceCusData
			var TileLocation = Vector2(0,0)
			var InstanceNoiseValue
			var TileHeight
			
			if z % 2 == 0: #Check if looping through even or odd row
				RowOffset = 0 #If EVEN, no row offset
			else:
				RowOffset = MeshAABB.size.x / 2 #If ODD, offset row by mesh radius
				
			# Set initial grid transforms, without height adjustment
			self.multimesh.set_instance_transform(InstanceID, Transform3D(Basis(), Vector3((x * MeshAABB.size.x) + RowOffset, 0, -z * MeshAABB.size.z * 0.75))) #Set tile grid position and adjust height by randomized custom data
			
			# Get the transform of tile
			TileLocation = self.multimesh.get_instance_transform(InstanceID)
			
			# Get noise value at tile location
			InstanceNoiseValue = heightNoise.get_noise_2d(TileLocation.origin.x,TileLocation.origin.z)
			
			# Set new height of tile with noise value
			self.multimesh.set_instance_transform(InstanceID, Transform3D(Basis(), Vector3((x * MeshAABB.size.x) + RowOffset, InstanceNoiseValue * strength, -z * MeshAABB.size.z * 0.75))) #Set tile grid position and adjust height by randomized custom data

			TileHeight = self.multimesh.get_instance_transform(InstanceID)

			# Set Custom Data value using tile height to pass to shader
			self.multimesh.set_instance_custom_data(InstanceID, Color(InstanceNoiseValue,TileHeight.origin.y,randf_range(-1,1),1)) #Noise Custom Data
			InstanceCusData = self.multimesh.get_instance_custom_data(InstanceID) #Set variable to custom data
			
			self.set_instance_shader_parameter("underwater", Underwater)
			self.set_instance_shader_parameter("grass", Grass)
			self.set_instance_shader_parameter("coast", Coast)
			self.set_instance_shader_parameter("snow", Snow)
	
	construct_water()
	
	self.multimesh.set_instance_count(NumInstances) # Reestablish instances
