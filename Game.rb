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
  @@LOSEFLOOR = 800
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
  	@player = Player.new(0,0) # position will be set based on first block
  	# Player should be drawn
  	@drawables << @player
    # Start block and set floor, players y appropriately
    #@drawables += generateTestBlocks(generateStartBlock)
    @drawables << generateStartBlock
    # Floor is the lowest the player can go.  It corresponds to the top of the block
    # under the players position, and is updated in collisions
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
        @player.state = :lose if @player.y >= @@LOSEFLOOR - Player::HEIGHT
  	end
    unless @player.state == :lose
      # Check collision with walls, update floor
      collisionCheck
  	  # Move player
  	  @player.move @floor
  	  # Move camera to player
  	  @cam.follow @player
    end
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
      @floor = @@LOSEFLOOR
      @player.state = :jumping
    else
      # Check if player is above the block to set a new floor
      if block.y > @player.y + Player::HEIGHT
        @floor = block.y - (block.height-1) * Tile::HEIGHT - 0.55 * Player::HEIGHT # .55 is a consequence of the player sprite containing empty space beneath it
        #@floor = @@LOSEFLOOR if @floor > @@TESTFLOOR
      else # collision on players right
        @player.vx = 0
      end
    end
  end

  # A testing function that generates a variety of blocks
  # with position to the right of the starting block
  def generateTestBlocks(startingblock)
    blocks = [startingblock]
    100.times do
      x = blocks[-1].x + blocks[-1].width * Tile::WIDTH + rand(800)
      blocks << Block.new(x, @@LOSEFLOOR - 100, rand(100), 1 + rand(7))
    end
    blocks
  end

  # Generates a start block and places the player/floor appropriately
  def generateStartBlock
    # Set player to stand on start block
    @player.y = @@LOSEFLOOR - 100 - Tile::HEIGHT - 0.55 * Player::HEIGHT
    # Set floor
    @floor = @player.y
    # Make the start block
    Block.new(0, @@LOSEFLOOR - 100, 20, 2)
  end

  # Adds a block to the level with position x, width and height
  # all given in units of number of tiles
  def addBlock(x, width, height)
    @drawables << Block.new(x * Tile::WIDTH, @@LOSEFLOOR - 100, width, height)
  end
end