require 'gosu'


module Tiles
  Grass = 0
  Earth = 1
  Champi = 2
  Pic = 3
  F = 4
end

class Terrain
  attr_reader :width, :height, :gems

  def initialize

  	filename = "../ressources/nivText/niv.txt"

  	genererTerrain

    # Load 60x60 tiles, 5px overlap in all four directions.
    @tileset = Gosu::Image.load_tiles("../ressources/tileset4.png", 60, 60, :tileable => true)
    lines = File.readlines(filename).map { |line| line.chomp }
    @height = lines.size
    @width = lines[0].size
    @tiles = Array.new(@width) do |x|
      Array.new(@height) do |y|
        case lines[y][x, 1]
        when '"'
          Tiles::Grass
        when '#'
          Tiles::Earth
        when 'X'
          Tiles::Pic
        when 'O'
          Tiles::Champi
        when 'E'
          Tiles::F
        else
          nil
        end
      end
    end
  end


  def draw
    # Very primitive drawing function:
    # Draws all the tiles, some off-screen, some on-screen.
    @height.times do |j|
      @width.times do |i|
        tile = @tiles[i][j]
        if tile
          # Draw the tile with an offset (tile images have some overlap)
          # Scrolling is implemented here just as in the game objects.
          @tileset[tile].draw(i * 50 - 5, j * 50 - 5, 0)
        end
      end
    end
  end

  # Solid at a given pixel position?
  def isSolid(x, y)
    y < 0 || @tiles[x / 50][y / 50]
  end

  # Genere le fichier niv.txt que sera chargé dans le jeu
  def genererTerrain

  	nbTerrains = 5 #Nb total de terrains
  	terrainHeight = 3 # Hauteur des terrains

  	nums = 5.times.map{ Random.rand(nbTerrains) }

  	tab = Array.new(terrainHeight)

	File.open('../ressources/nivText/niv.txt', 'w') do |output_file|

		for i in 0..4
			# f0 = File.readlines('./niv.txt')
			# f0 = f0.map {|elem| elem.chomp}

			nomF = "../ressources/nivText/#{nums[i]}.txt"
			f = File.readlines(nomF)
			f = f.map {|elem| elem.chomp}

			f.each_with_index do |elem, j|
		 		tab[j] = "#{tab[j]}#{elem}"
		 	end
		end

		f.each_with_index do |elem, j|
		 	output_file.puts "#{tab[j]}"
		 		# puts elem
		 		# puts f0[j]
		end
	end
  end

end
