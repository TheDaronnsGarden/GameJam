require 'gosu'

module Tiles
  Grass = 0
  Earth = 1
  Champi = 2
  Pic = 3
  Poison = 4
  Rateau = 5
  Piege = 6
  EpvtG = 7
  EpvtM = 8
end

class Terrain
  attr_reader :width, :height

  def initialize

  	filename = "ressources/nivText/niv.txt"

  	genererTerrain

    # Load 60x60 tiles, 5px overlap in all four directions.
    @tileset = Gosu::Image.load_tiles("ressources/tileset5.png", 60, 60, :tileable => true)
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
        when '~'
          Tiles::Poison
        when 'R'
          Tiles::Rateau
        when 'P'
          Tiles::Piege
        when 'G'
          Tiles::EpvtG
        when 'M'
          Tiles::EpvtM
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
    (y < 0 || @tiles[x / 50][y / 50]) && (not @tiles[x / 50][y / 50] == 4)

    # @tiles[x][y] == nul return false
    # @tiles[x / 50][y / 50] == 4 ==> Case poison traversable
  end

  def blockUnder(x=400, y=249)

  	l, m = x/50, (y/50)+1

  	begin
  		tile = @tiles[l][m]
  	rescue Exception => e
  		puts "Erreur"
  	else
  		# Si tile existe (n'est pas nul), on retourn sa valeur
  		if (tile)
  			tile
  		# Sinon on return -1
  		else
  			-1
  		end

  	end
  end

  # Genere le fichier niv.txt que sera chargé dans le jeu
  def genererTerrain

  	nbTerrains = 5 # Nb TOTAL de terrains
  	nbGenTerrain = 10 # Nb de terrain à générer pour le niveau final
  	terrainHeight = 6 # Hauteur des terrains

  	nums = nbGenTerrain.times.map{ Random.rand(nbTerrains) }

  	tab = Array.new(terrainHeight)

	File.open('ressources/nivText/niv.txt', 'w') do |output_file|

		for i in 0..nbGenTerrain-1
			# f0 = File.readlines('./niv.txt')
			# f0 = f0.map {|elem| elem.chomp}

			nomF = "ressources/nivText/1.txt"
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
