=begin
Walter Schlosser
=end

class Tile
  attr_reader :x, :y, :width, :height

  # Every tile has the same dimensions
  HEIGHT = 50
  WIDTH = 50
  def initialize(x=0, y=0)
  	@x = x
  	@y = y
  end
end