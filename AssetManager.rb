=begin
Walter Schlosser
=end

require 'gosu'

class AssetManager
  # Image files for all game objects loaded in this object
  def initialize
  	# Image count to be used to fill a loading bar if needed
	  @imgCount = 14
	  # Counter used for player animation frames
	  @animCount = 0
	  @playerImages = "./resources/playerSheet.png"
	  @backgroundImage = "./resources/background.png"
    @tileImage = "./resources/tile.png"
	  @imageHash = {}
  end

  # Loads images
  def load window
  	# Construct array of player images
  	playerAnim = *Gosu::Image.load_tiles(window, "./resources/playerSheet.png", 55, 76, false) 
	  @imageHash[:player] = playerAnim
	  @imageHash[:background] = Gosu::Image.new(window, @backgroundImage, true)
    @imageHash[:tile] = Gosu::Image.new(window, @tileImage, true)
  end

  def lookup item
  	@animCount += 1
  	if item == :player
  	  @imageHash[:player].at(@animCount/6 % 12)
  	else
  	  @imageHash[item]
  	end
  end
end