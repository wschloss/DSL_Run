=begin
Walter Schlosser
=end

class Player
  attr_accessor :x, :y, :vx, :vy, :state

  # Maximum allowed velocity components
  @@MAX_VX = 10
  @@MAX_VY = 20

  def initialize(x=0,y=0)
    @x = x
    @y = y
    @vx = 0
    @vy = 0
    # Player states will include running and jumping
    @state = :running
  end

  # Update the player position, floor is the lowest allowable y
  def move floor
    @x += @vx
   	if @y > floor
      @y = floor
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
  	@vy += ay unless @vx > @@MAX_VY
  end
end