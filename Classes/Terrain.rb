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
  GravityMoins = 9
  GravityPlus = 10
  ResetEffect = 11
  PicsInv = 12
  ChampiInv = 13
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
        when 'C'
          Tiles::Champi
        when 'c'
          Tiles::ChampiInv
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
        when '+'
          Tiles::GravityPlus
        when '-'
          Tiles::GravityMoins
        when '='
          Tiles::ResetEffect
        when 'x'
          Tiles::PicsInv
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

          if (tile == Tiles::ChampiInv) # Si c'est le champiInv, on lui charge la texture du champi 2
            tile = 2
          end

          if (tile == Tiles::PicsInv) # Methode de dessin spéciale pour les pics inversés
            tile = 3
            @tileset[tile].draw(i * 50 - 5, j * 62.5, 0, 1, -1)
          else
            @tileset[tile].draw(i * 50 - 5, j * 50 - 5, 0)
          end
        end
      end
    end
  end

  # Solid at a given pixel position?
  def isSolid(x, y)
    (y < -500|| @tiles[x / 50][y / 50]) &&
      ((not @tiles[x / 50][y / 50] == 2) && (not @tiles[x / 50][y / 50] == 3) && (not @tiles[x / 50][y / 50] == 4) && (not @tiles[x / 50][y / 50] == 5) &&
        (not @tiles[x / 50][y / 50] == 6) && (not @tiles[x / 50][y / 50] == 7) && (not @tiles[x / 50][y / 50] == 8) && (not @tiles[x / 50][y / 50] == 9) &&
        (not @tiles[x / 50][y / 50] == 10) && (not @tiles[x / 50][y / 50] == 11) && (not @tiles[x / 50][y / 50] == 12) && (not @tiles[x / 50][y / 50] == 13))

    # @tiles[x][y] == nul return false
    # Champi = 2
    # Pic = 3
    # Poison = 4
    # Rateau = 5
    # Piege = 6
    # EpvtG = 7
    # EpvtM = 8
    # GravityMoins = 9
    # GravityPlus = 10
    # ResetEffect = 11
    # PicsInv = 12
    # ChampiInv = 13
  end

  # Nature du bloc aux coordonnées x, y
  def blockPlayer(x=0, y=0)

  	l, m = x/50, (y/50)

  	begin
  		tile = @tiles[l][m]
  	rescue Exception => e
  		puts "Erreur"
  	else
  		# Si tile existe (n'est pas nil), on retourn sa valeur (donc sa nature)
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

  	nbTerrains = 5 # Nb TOTAL de terrains (de 0.txt à nbTerrains-1.txt)
  	nbGenTerrain = 1 # Nb de terrain à générer pour le niveau final (en plus du début et de la fin)
  	terrainHeight = 15 # Hauteur des terrains

  	nums = nbGenTerrain.times.map{ Random.rand(nbTerrains) }

  	tab = Array.new(terrainHeight)

      # Le niveau de départ est toujours D.txt
      f0 = File.readlines("ressources/nivText/D.txt")
      f0 = f0.map {|elem| elem.chomp}
      f0.each_with_index do |elem, j|
        tab[j] = "#{elem}"
      end

  # Ajout a tab des nbGenTerrain sélectionnés au hasard
	File.open('ressources/nivText/niv.txt', 'w') do |output_file|

		for i in 0..nbGenTerrain-1

			nomF = "ressources/nivText/NiveauDur.txt"
			f = File.readlines(nomF)
			f = f.map {|elem| elem.chomp}

			f.each_with_index do |elem, j|
		 		tab[j] = "#{tab[j]}#{elem}"
		 	end
		end

    # Le niveau de fin est toujours F.txt
    f1 = File.readlines("ressources/nivText/F.txt")
    f1 = f1.map {|elem| elem.chomp}
    f1.each_with_index do |elem, j|
      tab[j] = "#{tab[j]}#{elem}"
    end

    # On rempli le fichier "output_file" avec les données des autres terrains générés
		f1.each_with_index do |elem, j|
		 	output_file.puts "#{tab[j]}"
		end
	end
  end

end
