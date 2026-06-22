extends Node2D

class_name ErrorMessage

func put_content (content : String):
	$Label.text = content

func get_text_size () -> Vector2:
	return $Label.size
