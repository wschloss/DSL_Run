=begin
Walter Schlosser

A block is a rectangular configuration of contiguous tiles.
=end

require "./gameObjects/CompositeGameObject.rb"

class Block < CompositeGameObject
  def initialize(x=0, y=0, width=1, height=1)
    super(x,y,width,height)
    # Array of tile objects that represent this block
  	@pieces = buildTiles(@x, @y, @width, @height)
  end

  # Helper to create all tile objects based on the width and height of the block
  def buildTiles(x, y, width, height)
  	tiles = []
  	width.times do |i|
  	  height.times do |j|
  	  	tiles << Tile.new(i * Tile::WIDTH + x, -(j+1) * Tile::HEIGHT + y)
  	  end
  	end
  	tiles
  end
end