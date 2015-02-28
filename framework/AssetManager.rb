=begin
Walter Schlosser

An asset manager which loads all image resources.  Provides lookup services
so mapping between the object and the image is straightforward.
=end

class AssetManager
  def initialize
  	# Image count to be used to fill a loading bar in the future
	  @imgCount = 14
	  # Counter used for player animation frames
	  @animCount = 0
    # Image filenames
	  @playerImages = "./resources/playerSheet.png"
	  @backgroundImage = "./resources/background.png"
    @tileImage = "./resources/tile.png"
    # Hash of object symbol to loaded images
	  @imageHash = {}
  end

  # Loads images and stores in the hash for lookup later
  def load window
  	# Construct array of player images
  	playerAnim = *Gosu::Image.load_tiles(window, "./resources/playerSheet.png", 55, 76, false) 
	  @imageHash[:player] = playerAnim
	  @imageHash[:background] = Gosu::Image.new(window, @backgroundImage, true)
    @imageHash[:tile] = Gosu::Image.new(window, @tileImage, true)
  end

  # Returns the image for the passed object symbol
  def lookup item
  	if item == :player
      @animCount += 1
  	  @imageHash[:player].at(@animCount/5 % 12)
  	else
  	  @imageHash[item]
  	end
  end
end