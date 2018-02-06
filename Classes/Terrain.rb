require 'gosu'


module Tiles
  Grass = 0
  Earth = 1
end

class Terrain
  attr_reader :width, :height, :gems

  def initialize

  	# Méthode de generation du terrain
  	genererTerrain

  	# Nom du fichier texte créé par genererTerrain
  	filename = "../ressources/nivText/niv.txt"

    # Charge les textures des blocs
    @tileset = Gosu::Image.load_tiles("../ressources/tileset.png", 60, 60, :tileable => true)
    lines = File.readlines(filename).map { |line| line.chomp }

    # Dimension du fichier texte contenant le terrain
    @height = lines.size
    @width = lines[0].size

    # Traduction des caractères du fichier texte en éléments de textures
    @tiles = Array.new(@width) do |x|
      Array.new(@height) do |y|
        case lines[y][x, 1]
	        when '"'
	          Tiles::Grass
	        when '#'
	          Tiles::Earth
	        else
	          nil
        end
      end
    end
  end


  def draw
    # Dessine toutes les tuiles contenues dans @tiles
    @height.times do |j|
      @width.times do |i|
        tile = @tiles[i][j]
        if tile
          # Dessine les tuiles
          @tileset[tile].draw(i * 50 - 5, j * 50 - 5, 0)
        end
      end
    end
  end
  
  # Nature du bloc à la position x, y ? (solide ?)
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

			nomF = "../ressources/nivText/#{nums[i]}.txt"
			f = File.readlines(nomF)
			f = f.map {|elem| elem.chomp}

			f.each_with_index do |elem, j|
		 		tab[j] = "#{tab[j]}#{elem}"
		 	end			
		end

		f.each_with_index do |elem, j|
		 	output_file.puts "#{tab[j]}"
		end
	end
  end

end
