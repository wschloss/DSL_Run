=begin
Walter Schlosser

A game object has a position in the world.  It is a single object,
and not a composite of others.
=end

class GameObject
  attr_accessor :x, :y
  
  # Init a position
  def initialize(x=0, y=0)
    @x = x
    @y = y
  end
end