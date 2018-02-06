require 'gosu'

require_relative '../Classes/Hero'
#require_relative '../Classes/Window'
require_relative '../Classes/Terrain'

WindowWidth = 1080
WindowHeight = 720


class Niveau < Gosu::Window
  def initialize
    super WindowWidth, WindowHeight

    self.caption = "hero. Ruby"

    @sky = Gosu::Image.new("../ressources/sky.jpg", :tileable => true)
    @map = Terrain.new
    @hero = Hero.new(@map, 400, 100)
    # The scrolling position is stored as top left corner of the screen.
    @camera_x = @camera_y = 0
  end

  def update
    move_x = 0
    move_x -= 10 if Gosu.button_down? Gosu::KB_LEFT
    move_x += 10 if Gosu.button_down? Gosu::KB_RIGHT
    @hero.update(move_x)

    # Caméra suit le joueur
    @camera_x = [[@hero.x - WindowWidth / 2, 0].max, @map.width * 50 - WindowWidth].min
    @camera_y = [[@hero.y - WindowHeight / 2, 0].max, @map.height * 50 - WindowHeight].min
  end

  def draw
    @sky.draw 0, 0, 0
    Gosu.translate(-@camera_x, -@camera_y) do
      @map.draw
      @hero.draw
    end
  end

  def button_down(id)
    case id
    when Gosu::KB_UP
      @hero.try_to_jump
    when Gosu::KB_ESCAPE
      close
    else
      super
    end
  end
end
