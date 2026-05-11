for c in somebody.get_children():
	somebody.remove_child(c)
	c.queue_free()
