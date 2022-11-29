extends Area

# Sets the player's health to a negative value so they die
func kill_player(_body):
	References.health = -100
