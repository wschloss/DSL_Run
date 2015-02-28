=begin
Walter Schlosser

All allowed DSL functions are defined here.
=end

# Creates a block at position x with width and height.
# Units are in number of tiles
def block(x, width, height)
  GameWindow.instance.game.addBlock(x, width, height)
end