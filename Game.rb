=begin
Walter Schlosser
=end

require './Player.rb'

class Game
  attr_reader :drawables
  # Gravity for vertical acceleration
  @@GRAVITY = 5
  # Y value that represents the 'floor' of the map
  @@FLOOR = 700
  # Determines how high player can jump
  @@JUMP_AMOUNT = 70
  # Determines how fast player gets up to running speed
  @@X_ACCELERATION = 1

  def initialize camera
  	# Reference to camera to tell it where to focus
  	@cam = camera
  	# Contains all objects to draw
  	@drawables = []
  	# Main player
  	@player = Player.new(0,@@FLOOR - 76) # This 76 is the players height.  Should be passed in somehow
  	# Player should be drawn
  	@drawables << @player
  end

  # Responds to key presses appropriately
  def button_down id
  	# Jump button is spacebar
  	if id == Gosu::KbSpace && @player.state == :running
  	  @player.vy -= @@JUMP_AMOUNT
  	  @player.state = :jumping
  	end
  end

  # Updates game logic
  def update
  	# Accelerate player appropriately
  	case @player.state
  	  when :running
  	  	@player.accelerate(@@X_ACCELERATION, 0)
  	  when :jumping
  	  	@player.accelerate(0, @@GRAVITY)
  	end
  	# Move player
  	@player.move @@FLOOR
  	# Move camera to player
  	@cam.follow @player
  end
end