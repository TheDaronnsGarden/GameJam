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
    @sky = Gosu::Image.new("../ressources/sky.jpg", :tileable => true)
    @map = Terrain.new
    @hero = Hero.new(@map, 400, 100)
    
    # postion du la caméra (en haut à cauche par défaut)
    @camera_x = @camera_y = 0
  end

  def update

    move_x = 0

    if (Gosu.button_down?(Gosu::KB_LEFT)) then move_x -= 10 end
    if (Gosu.button_down?(Gosu::KB_RIGHT)) then move_x += 10 end
    @hero.update(move_x)

    # Caméra suit le joueur
    @camera_x = [[@hero.x - WindowWidth / 2, 0].max, @map.width * 50 - WindowWidth].min
    @camera_y = [[@hero.y - WindowHeight / 2, 0].max, @map.height * 50 - WindowHeight].min

    action(@map.blockUnder(@hero.x, @hero.y))

  end

  def action(i)
    if (i ==1)
      @hero.vy = -50
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
      @hero.jump
    when Gosu::KB_ESCAPE
      close
    else
      super
    end
  end
end
