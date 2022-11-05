extends Control

var gridsize : int = 0
var strength : float = 0.25
var noisetype = 3
var fractaltype = 1
var seed = randi()
var freq = .01
var octaves = 2
var lac = 2.3
var gain = .6

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_update_ui_pressed():
	$"../HexGrid".updategrid(gridsize,strength,noisetype,fractaltype,seed,freq,octaves,lac,gain)

func _on_grid_size_value_changed(value):
	gridsize = value
	_on_update_ui_pressed()

func _on_h_slider_value_changed(value):
	strength = value
	_on_update_ui_pressed()

func _on_option_button_item_selected(index):
	noisetype = index
	_on_update_ui_pressed()

func _on_fractal_item_selected(index):
	fractaltype = index
	_on_update_ui_pressed()

func _on_seed_value_changed(value):
	seed = value
	_on_update_ui_pressed()

func _on_frequency_value_changed(value):
	freq = value
	_on_update_ui_pressed()

func _on_octaves_value_changed(value):
	octaves = value
	_on_update_ui_pressed()

func _on_lacunarity_value_changed(value):
	lac = value
	_on_update_ui_pressed()

func _on_gain_value_changed(value):
	gain = value
	_on_update_ui_pressed()
