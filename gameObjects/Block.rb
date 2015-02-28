=begin
Walter Schlosser

A block is a rectangular configuration of contiguous tiles.
=end

class Block
  attr_reader :tiles, :x, :y, :width, :height
  def initialize(x=0, y=0, width=1, height=1)
    # Init position
  	@x = x
  	@y = y
  	# Width and height of a block are in number of tiles
  	@width = width
  	@height = height
    # Array of tile objects that represent this block
  	@tiles = buildTiles(@x, @y, @width, @height)
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