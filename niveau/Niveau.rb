require 'gosu'

require_relative '../Classes/Hero'
require_relative '../Classes/Terrain'

# Taille de la fenêtre de jeu
WindowWidth = 1020
WindowHeight = 780


class Niveau < Gosu::Window

	attr_accessor :nbEssais

  def initialize
    super WindowWidth, WindowHeight

    self.caption = "The Darron's Garden"

    # Generation des composants du jeu
    @sky = Gosu::Image.new("ressources/sky1020.png", :tileable => true)
    @map = Terrain.new
    @hero = Hero.new(@map, 400, 445)

    @nbEssais = 1
    @essais = Gosu::Font.new(20)

    # Nombre de pixels par tick
    @moveLeft, @moveRight = 8, 8

    # postion du la caméra (en haut à gauche par défaut)
    @cameraX = @cameraY = 0
  end

  def update

    # Tant que le hero est en vie
    if (not @hero.isDead)

      moveX = 0

      if (Gosu.button_down?(Gosu::KB_LEFT))
      	moveX -= @moveLeft
      end
      if (Gosu.button_down?(Gosu::KB_RIGHT))
      	moveX += @moveRight
      end

      @hero.update(moveX)

      # La caméra suit le joueur
      @cameraX = [[@hero.x - WindowWidth / 2, 0].max, @map.width * 50 - WindowWidth].min
      @cameraY = [[@hero.y - WindowHeight / 2, 0].max, @map.height * 50 - WindowHeight].min

      # On test en permanence le bloc dans lequel est le perso
      blockAction(0, @map.blockPlayer(@hero.x, @hero.y))

      # On test en permanence le bloc sous le perso
      blockAction(1, @map.blockPlayer(@hero.x, @hero.y+50))

      # Si le joueur tombe dans le vide, il est mort
      if (@hero.y > WindowHeight)
        @hero.mort = true
      end

    # Si le héro est mort
    else
      @nbEssais += 1
      @hero.update(0)

      @map.initialiserJeu
      @hero.setPosition(400, 400)
      @hero.mort = false
    end

  end

  def blockAction(where, i)
    # Where : 0 tester le bloc DANS le perso
    #         1 tester le bloc SOUS le perso

    # BLOC DANS LE PERSO
    if (where == 0)
      if (i == Tiles::Champi) # Bloc champi normal
        @moveLeft = -8
        @moveRight = -8
      end

      if (i == Tiles::ChampiInv)  # Bloc champi inverse
        @moveLeft = 8
        @moveRight = 8
      end

      # Pics, rateau, piège, épouvantail méchant, pics inversés
      if (i == Tiles::Pic  || i == Tiles::Rateau || i == Tiles::Piege || i == Tiles::EpvtM || i == Tiles::PicsInv)
        @hero.mort = true
      end

    # BLOC SOUS LE PERSO
    elsif (where == 1)

      if (i == Tiles::Poison) # bloc poison
        @hero.mort = true
      end

    end
  end

  # Dessine le background et gère le mouvement de la caméra
  def draw
  	@essais.draw("Essais : #{@nbEssais}", 10, 10, 2, 1.0, 1.0, Gosu::Color::WHITE) # Affiche le nombre d'essais
    @sky.draw(0, 0, 0) # Backgrounf
    Gosu.translate(-@cameraX, -@cameraY) do
      @map.draw
      @hero.draw
    end
  end

  # Gestion des cas selon le bouton préssé
  def button_down(id)
    case id
    when Gosu::KB_UP
      if (not @hero.isDead)
        @hero.jump
      end
    when Gosu::KB_ESCAPE
      self.close
    else
      super
    end
  end
end
