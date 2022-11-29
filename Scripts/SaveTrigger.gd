extends Area

# Saves current location as spawnpoint
func save_location(_body):
	References.spawnpoint = transform.origin
