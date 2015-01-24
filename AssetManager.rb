=begin
Walter Schlosser
=end

require 'gosu'

class AssetManager
  # Image files for all game objects loaded in this object
  def initialize
  	# Image count to be used to fill a loading bar if needed
	@imgCount = 13
	# Counter used for player animation frames
	@animCount = 0
	@playerImages = ["./resources/player1.png", 
						"./resources/player2.png",
						"./resources/player3.png",
						"./resources/player4.png",
						"./resources/player5.png",
						"./resources/player6.png",
						"./resources/player7.png",
						"./resources/player8.png",
						"./resources/player9.png",
						"./resources/player10.png",
						"./resources/player11.png",
						"./resources/player12.png"]
	@backgroundImage = "./resources/background.png"
	@imageHash = {}
  end

  # Loads images
  def load window
  	# Construct array of player images
  	playerAnim = []
  	@playerImages.each do |path|
  	  playerAnim << Gosu::Image.new(window, path, false)
  	end  
	@imageHash[:player] = playerAnim
	@imageHash[:background] = Gosu::Image.new(window, @backgroundImage, true)
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