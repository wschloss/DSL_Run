=begin
Walter Schlosser
=end

require './Tile.rb'

class Block
  attr_reader :tiles, :x, :y, :width, :height
  def initialize(x=0, y=0, width=1, height=1)
  	@x = x
  	@y = y
  	# Width and height of a block are in number of tiles
  	@width = width
  	@height = height
  	@tiles = buildTiles(@width, @height)
  end

  # Creates all tiles based on the width and height needed
  def buildTiles(width, height)
  	tiles = []
  	width.times do |i|
  	  height.times do |j|
  	  	tiles << Tile.new(i * Tile::WIDTH + @x, -(j+1) * Tile::HEIGHT + @y)
  	  end
  	end
  	tiles
  end
end