=begin
Author: Walter Schlosser
=end

# Gosu gem
require 'gosu'
require './Game.rb'
require './Camera.rb'
require './AssetManager.rb'
require './Tile.rb'

# Main window
class GameWindow < Gosu::Window
  WINDOW_WIDTH = 900
  WINDOW_HEIGHT = 700

  def initialize
    super(WINDOW_WIDTH, WINDOW_HEIGHT, false)
    self.caption = "Parse and Run!"
    @cam = Camera.new(0,0)
    @game = Game.new @cam
    # Loads assets for drawing/sound
    @assets = AssetManager.new
    @assets.load self
  end

  def update
  	# Move game logic forward
  	@game.update
  end

  def draw
  	# Draw all the game objects with the camera translation
	  translate -@cam.x, -@cam.y do
	    # Draw two background tiles to fill the camera
	    xInWidths = (@cam.x/WINDOW_WIDTH)
	    image = @assets.lookup(:background)
  	  image.draw(xInWidths * WINDOW_WIDTH, 0, 0, WINDOW_WIDTH.to_f/image.width, WINDOW_HEIGHT.to_f/image.height)
	    image.draw((xInWidths + 1) * WINDOW_WIDTH, 0, 0, WINDOW_WIDTH.to_f/image.width, WINDOW_HEIGHT.to_f/image.height)
	    # Iterate over game objects to draw
      # select only objects on screen
      toDraw = @game.drawables.select do |drawable|
        if drawable.instance_of? Block
          leftBound = drawable.x
          rightBound = drawable.x + drawable.width * Tile::WIDTH
          shiftedCamX = @cam.x + WINDOW_WIDTH
          shiftedCamX > leftBound && @cam.x < rightBound
        else
          drawable.x > @cam.x && drawable.x < @cam.x + WINDOW_WIDTH
        end
      end
	    toDraw.each do |drawable|
	  	  if drawable.instance_of? Player
          @assets.lookup(:player).draw(drawable.x, drawable.y, 0)
	  	  elsif drawable.instance_of? Block
          drawable.tiles.each { |tile| @assets.lookup(:tile).draw(tile.x, tile.y, 0) }
	  	  end
	    end
	  end
  end

  def button_down id
  	# Let game handle input logic
  	close if id == Gosu::KbEscape
  	@game.button_down id
  end
end

window = GameWindow.new
window.show