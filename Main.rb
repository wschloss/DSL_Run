=begin
Author: Walter Schlosser
=end

# Gosu gem
require 'gosu'
require './Game.rb'
require './Camera.rb'
require './AssetManager.rb'
require './Tile.rb'
# Singleton pattern module for the game window
require 'singleton'

# Main window
class GameWindow < Gosu::Window
  include Singleton

  attr_reader :game

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


# --- DSL Allowed Commands ---

# Creates a block at position x with width and height.
# Units are in number of tiles
def block(x, width, height)
  GameWindow.instance.game.addBlock(x, width, height)
end

# --- End of DSL ---


# Attempt to load the level file and play
# File can be passed as a command line arg
filename = ARGV[0] || 'level.txt'
ARGV.clear
if File.exist? filename
  begin
    load 'level.txt'
    # Show the window instance
    GameWindow.instance.show
  rescue NameError => e
    badCommand = e.message.scan(/`.*?'/).at(0)
    puts "Level File Error: The command #{badCommand} is not valid"
  end
else
  #File not found
  puts "The file '#{filename}' was not found"
end
