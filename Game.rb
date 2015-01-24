=begin
Walter Schlosser
=end

require './Player.rb'
require './Block.rb'
require './Tile.rb'

class Game
  attr_reader :drawables
  # Gravity for vertical acceleration
  @@GRAVITY = 5
  # Y value that represents the 'floor' of the map to avoid losing
  @@TESTFLOOR = 700
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
  	@player = Player.new(0,@@TESTFLOOR - Player::HEIGHT)
  	# Player should be drawn
  	@drawables << @player
    @drawables += generateTestBlocks
    # Floor is the lowest the player can go.  It corresponds to the top of the block
    # under the players position, and is updated in collisions
    @floor = @@TESTFLOOR
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
    # Check collision with walls, update floor
    collisionCheck
  	# Move player
  	@player.move @floor
  	# Move camera to player
  	@cam.follow @player
  end

  # Finds collisions between player and block.
  def collisionCheck
    # Iterate over block first to find the one in question
    block = @drawables.select do |drawable|
      if drawable.instance_of? Block
        leftBound = drawable.x - Player::WIDTH
        rightBound = drawable.x + drawable.width * Tile::WIDTH
        leftBound < @player.x && @player.x < rightBound
      else
        false
      end
    end
    block = block[0]
    # Process if player is within x bounds
    if block.nil?
      # No block in bounds, set losing floor, player state to fall
      @floor = @@TESTFLOOR
      @player.state = :jumping
    else
      # Check if player is above the block to set a new floor
      if block.y > @player.y + Player::HEIGHT
        @floor = block.y - (block.height-1) * Tile::HEIGHT - Player::HEIGHT
        @floor = @@TESTFLOOR if @floor > @@TESTFLOOR
      else # collision on players right
        @player.vx = 0
      end
    end
  end

  # A testing function that generates a variety of blocks
  def generateTestBlocks
    blocks = []
    blocks << Block.new(1000, @@TESTFLOOR, 10, 2)
    100.times do
      x = blocks[-1].x + blocks[-1].width * Tile::WIDTH + rand(2000)
      blocks << Block.new(x, @@TESTFLOOR, rand(100), 1 + rand(7))
    end
    blocks
  end
end