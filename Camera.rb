=begin
Author: Walter Schlosser

A simple orthographic camera class to manage
offsets when the screen is supposed to scroll.
=end

class Camera
  attr_reader :x, :y
  def initialize(x=0.0, y=0.0)
	  @x = x
	  @y = y
	  # Offset is how far the cam center is in front of the player sprite
	  @offset = 250
  end

  # Moves camera's horizontal position to the desired object position plus an offset
  def follow object
  	@x = object.x + @offset
  end
end