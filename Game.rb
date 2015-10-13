=begin
Walter Schlosser

The Game instance manages the objects in the game.  It responds to
keyboard input, and updates the game logic while managing collisions.
=end

require './gameObjects/Block.rb'

class Game
  attr_reader :drawables, :lastDefined
  # Gravity for vertical acceleration
  @@GRAVITY = 5
  # Y value that represents the 'floor' of the map to avoid losing
  @@LOSEFLOOR = 800
  # Determines how high player can jump
  @@JUMP_AMOUNT = 70
  # Determines how fast player gets up to running speed
  @@X_ACCELERATION = 1

  def initialize camera
    # Defined game objects, hashes :name to class
    @definitions = {}
    # Keeps track of last defined object so functionality can be added
    @lastDefined = nil
    # Reference to camera to tell it where to focus
    @cam = camera
    # Contains all objects to draw
    @drawables = []
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
        @player.state = :lose if @player.y >= @@LOSEFLOOR - @player.height
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
        leftBound = drawable.x - @player.width
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
      if block.y > @player.y + @player.height
        # .55 is a consequence of the player sprite containing empty space beneath it
        @floor = block.y - (block.height-1) * Tile::HEIGHT - 0.55 * @player.height 
      else # collision on players right
        @player.vx = 0
      end
    end
  end

  # Generates a start block and places the player/floor appropriately
  def generateStartBlock
    # Set player to stand on start block
    @player.y = @@LOSEFLOOR - 100 - Tile::HEIGHT - 0.55 * @player.height
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

  # Adds a new game object class
  def addObjectDef(name)
    # Add new class if needed
    unless @definitions.has_key? name.to_sym
      @definitions[name.to_sym] = Class.new(GameObject)
      # Override .class function to return the name this definition was given
      @definitions[name.to_sym].class_eval("def class; #{name.capitalize.to_sym}; end")
    end
    # Update the last added class
    @lastDefined = @definitions[name.to_sym]
  end

  # Adds instance of defined object to game
  def addObject(name, x, y)
    # Objects need a position
    object = @definitions[name.to_sym].new(x,y)
    # Keep reference if main player, and generate a starting block
    if name.to_sym == :player
      @player = object
      @drawables << generateStartBlock
    end
    # Add this object to draw
    @drawables << object
  end
end
