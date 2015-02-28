=begin
Walter Schlosser

A composite game object is constructed of many gameobjects.
It therefore has an array of pieces used for drawing or
collision checking.
=end

class CompositeGameObject
  # Subclasses must define their array of pieces
  attr_reader :pieces, :x, :y, :width, :height

  def initialize(x=0, y=0, width=1, height=1)
	# Init position
  	@x = x
  	@y = y
  	# Width and height of a block are in number of tiles
  	@width = width
  	@height = height
  end
end