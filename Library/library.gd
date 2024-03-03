extends Node

var MAX_DAMAGE_OUTPUT: float = 999999.0

enum BattleState {
	NONE,
	ACTION_SELECTION,
	ATTACK,
	MAGIC,
	DEFEND,
	ITEMS,
	RUN
}

enum Status {
	OK,
	DEAD
}
