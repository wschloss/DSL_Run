=begin
Walter Schlosser

This file defines the main game window.  The game window
initializes the camera and game objects, and is responsible
for drawing every frame.  This script also loads the DSL
file, and exits if there is an error.
=end

# Gosu gem
require 'gosu'
require './Game.rb'
require './gameObjects/GameObject.rb'
require './framework/Camera.rb'
require './framework/AssetManager.rb'
require './gameView/GameViewConstructor.rb'
require './gameObjects/Tile.rb'
# Singleton pattern module for the game window
require 'singleton'

# --- DSL Inclusion ---

require "./framework/DSLdef.rb"

# ---               ---

# Main window
class GameWindow < Gosu::Window
  include Singleton

  attr_reader :game

  WINDOW_WIDTH = 900
  WINDOW_HEIGHT = 700

  def initialize
    super(WINDOW_WIDTH, WINDOW_HEIGHT, false)
    self.caption = "DSL Run!"
    # Init camera and game
    @cam = Camera.new(0,0)
    @game = Game.new @cam
    # Init a view constructor
    @viewConstructor = GameViewConstructor.new
    # Load assets for drawing/sound
    @assets = AssetManager.new
    @assets.load self
  end

  # Called every frame to update logic
  def update
    # Move game logic forward
    @game.update
  end

  # Called when needed, draws all game objects
  def draw
    # Draw all the game objects with the camera translation
    translate -@cam.x, -@cam.y do
      # Draw two background tiles to fill the camera
      xInWidths = (@cam.x/WINDOW_WIDTH)
      image = @assets.lookup(:Background)
      image.draw(xInWidths * WINDOW_WIDTH, 0, 0, WINDOW_WIDTH.to_f/image.width, WINDOW_HEIGHT.to_f/image.height)
      image.draw((xInWidths + 1) * WINDOW_WIDTH, 0, 0, WINDOW_WIDTH.to_f/image.width, WINDOW_HEIGHT.to_f/image.height)
      # Select objects on screen and draw them
      toDraw = @viewConstructor.clipOffScreen(@game.drawables, @cam.x, @cam.x + WINDOW_WIDTH)
      toDraw.each do |drawable|
        @viewConstructor.drawClass(drawable, @assets)
      end
    end
  end

  # Triggers on keyboard down events
  def button_down id
    # Let game handle input logic
    close if id == Gosu::KbEscape
    @game.button_down id
  end
end



# Attempt to load the level file and play
# File can be passed as a command line arg
filename = ARGV[0] || './resources/game_definition.rb'
ARGV.clear
if File.exist? filename
  begin
    load filename
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
