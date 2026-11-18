# grandfather-paradox

A work-in-progress time-travel game concept about the unintended consequences
of trying to save humanity.

## Prototype

Run the project in Godot to try the single-mission prototype. Move with
**WASD** or the **arrow keys**. Press **Tab** to pause and open the tactical
view. The camera follows your player across the larger map, whose full layout
is visible from the start. Tiles outside current line of sight are dimmed.
Reach the gold target to finish the mission. The enemy system is still in
place, but the prototype starts with no enemies.

The level is the `Level` TileMapLayer in [main.tscn](scenes/main.tscn), using
the atlas in [tiles.svg](assets/tiles.svg). Edit the map with Godot's 2D
TileMap editor. Wall and window tiles both have collision; custom tile data
makes walls block vision while windows remain transparent. Player, target, and
enemy icons use full-color and fogged variants; entity markers remain visible
even outside current line of sight. Fogged tiles receive a subtle diagonal and
speckled texture. Adjust `vision_distance` on the `Main` node in the scene to
change how far the player can see. The game no longer tracks previously
explored tiles.

See [the game concept notebook](docs/game-concept.md) for the current premise,
gameplay ideas, mission seeds, and open design questions.
