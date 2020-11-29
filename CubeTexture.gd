tool

extends Node2D

var font: Font


func _ready():
	font = DynamicFont.new()
	font.font_data = load("res://Anton-Regular.ttf")
	font.size = 64
	update()


func _draw():
	draw_string(font, Vector2(0, 0), "4")
