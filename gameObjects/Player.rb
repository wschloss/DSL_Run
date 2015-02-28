=begin
Walter Schlosser

The player object runs across the screen to the right.
The player is affected by gravity, and must have a floor
of blocks to avoid losing.
=end

require "./gameObjects/GameObject.rb"

class Player < GameObject
  attr_accessor :vx, :vy, :state, :height, :width

  # Maximum allowed velocity components
  @@MAX_VX = 15
  @@MAX_VY = 20

  # Dimensions of each frame
  WIDTH = 55
  HEIGHT = 76

  def initialize(x=0,y=0)
    super(x,y)
    @vx = 0
    @vy = 0
    # Player states will include running and jumping, and lose
    @state = :running
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

  # Changes velocity according to the passed acceleration
  # Also imposes maximum velocities
  def accelerate(ax, ay)
  	@vx += ax unless @vx > @@MAX_VX
  	@vy += ay unless @vy > @@MAX_VY
  end
end