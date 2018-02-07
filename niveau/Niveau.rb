require 'gosu'

require_relative '../Classes/Hero'
require_relative '../Classes/Terrain'

# Taille de la fenêtre de jeu
WindowWidth = 1080
WindowHeight = 720


class Niveau < Gosu::Window
  def initialize
    super WindowWidth, WindowHeight

    self.caption = "The Darron's Garden"

    # Generation des composants du jeu
    @sky = Gosu::Image.new("ressources/sky.jpg", :tileable => true)
    @map = Terrain.new
    @hero = Hero.new(@map, 400, 445)

    # Nombre de pixels par tick
    @moveLeft, @moveRight = 8, 8
    
    # postion du la caméra (en haut à cauche par défaut)
    @camera_x = @camera_y = 0
  end

  def update

    # Tant que le hero est en vie
    if (not @hero.isDead)

      moveX = 0

      if (Gosu.button_down?(Gosu::KB_LEFT)) then moveX -= @moveLeft end
      if (Gosu.button_down?(Gosu::KB_RIGHT)) then moveX += @moveRight end
      @hero.update(moveX)

      # La caméra suit le joueur
      @camera_x = [[@hero.x - WindowWidth / 2, 0].max, @map.width * 50 - WindowWidth].min
      @camera_y = [[@hero.y - WindowHeight / 2, 0].max, @map.height * 50 - WindowHeight].min

      # On test en permanence le bloc dans lequel est le perso
      blockAction(0, @map.blockPlayer(@hero.x, @hero.y))

      # On test en permanence le bloc sous le perso
      blockAction(1, @map.blockPlayer(@hero.x, @hero.y+50))

      # Si le joueur tombe dans le vide, il est mort
      if (@hero.y > 720)
        @hero.mort = true
      end

    # Si le héro est mort
    else
      @hero.update(0)
    end

  end

  def blockAction(where, i)
    # Where : 0 tester le bloc DANS le perso
    #         1 tester le bloc SOUS le perso

    # BLOC DANS LE PERSO
    if (where == 0)
      if (i == 2) # Bloc champi normal
        @moveLeft = -8
        @moveRight = -8
      end

      if (i == 9)  # Bloc champi inverse     	
        @moveLeft = 8
        @moveRight = 8
      end

      if (i == 3  || i == 5 || i == 6 || i == 8) # Pics, rateau, piège, épouvantail méchant
        @hero.mort = true
      end

    # BLOC SOUS LE PERSO
    elsif (where == 1)
      if (i == 4) # bloc pic et poison
        @hero.mort = true
      end
    end
  end

  # Dessine le background et gère le mouvement de la caméra
  def draw
    @sky.draw 0, 0, 0
    Gosu.translate(-@camera_x, -@camera_y) do
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
