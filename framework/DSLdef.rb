=begin
Walter Schlosser

This file defines all functionality modules, and all
DSL commands that are allowed.
=end


# Includes functionality for running
module Runs
  attr_accessor :vx, :vy, :state

  # Maximum allowed velocity components
  @@MAX_VX = 15
  @@MAX_VY = 20

  # Changes velocity according to the passed acceleration
  # Also imposes maximum velocities
  def accelerate(ax, ay)
  	@vx += ax unless @vx > @@MAX_VX
  	@vy += ay unless @vy > @@MAX_VY
  end

  # Add vars needed for running functionality
  def assignRunsVars
  	@vx = 0
  	@vy = 0
  	@state = :running
  end

  # Update initialization of this object to include run vars
  # This patches the initialize function when the module is include
  def self.included(base)
  	# Make unbound method equal to the old initialize method
	append_to = base.instance_method(:initialize)

	# Redefine initialize, still takes x,y args
	define_method(:initialize) do |x,y|
	  # Call old init function by binding it to the object that includes this module
	  append_to.bind(self).(x,y)
	  # Additional init code needed
	  assignRunsVars
	end
  end

end

# Includes player functionality that has yet to be abstracted
module Player
  # Dimensions of each frame
  WIDTH = 55
  HEIGHT = 76

  def width
  	WIDTH
  end

  def height
  	HEIGHT
  end

   # Update the player position, floor is the lowest allowable y
  def move floor
    @x += @vx
    if @y + @vy > floor - HEIGHT
      @y = floor - HEIGHT
      @vy = 0
      @state = :running
    else
      @y += @vy
    end
  end
end

# Creates a new object class identified by the passed string
def make_object name
  GameWindow.instance.game.addObjectDef(name)
  # Yield to functionality commands if passed as a block
  yield if block_given?
end

# Adds auto running functionality to the object
def runs
  GameWindow.instance.game.lastDefined.class_eval("include Runs")
end

# Adds main player functionality to the object
def player
  GameWindow.instance.game.lastDefined.class_eval("include Player")
end

# Adds an instance of the defined object to the game
def create_object name, x=0, y=0
  GameWindow.instance.game.addObject(name, x, y)
end

# Creates a block at position x with width and height.
# Units are in number of tiles
def create_block(x, width, height)
  GameWindow.instance.game.addBlock(x, width, height)
end