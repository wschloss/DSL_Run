=begin
Walter Schlosser

This class maps the class of each drawable to the correct
drawing functionality.  This way the drawables do not have
to draw themselves.
=end

class GameViewConstructor
  # Takes the drawable object and draws appropriately
  def drawClass (drawable, assets)
  	if drawable.is_a? GameObject
  	  assets.lookup(drawable.class.name.to_sym).draw(drawable.x, drawable.y, 0)
  	elsif drawable.is_a? CompositeGameObject
  	  drawable.pieces.each { |piece| assets.lookup(piece.class.name.to_sym).draw(piece.x, piece.y, 0) }
  	end
  end

  # Takes a list of drawables and window bounds, and 
  # returns list of drawables on screen
  def clipOffScreen(drawables, xmin, xmax)
  	drawables.select do |drawable|
      if drawable.instance_of? Block
        leftBound = drawable.x
        rightBound = drawable.x + drawable.width * Tile::WIDTH
        xmax > leftBound && xmin < rightBound
      else
        drawable.x > xmin && drawable.x < xmax
      end
    end
  end
end