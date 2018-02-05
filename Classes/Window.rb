class Window < Gosu::Window

  def initialize(width, height)
    super
    self.caption = "Mon jeu"

    @background_image = Gosu::Image.new("../ressources/picture.jpg")
    @hero = Hero.new(width/2, height/2)
  end

  def update
    @hero.go_left if Gosu::button_down?(Gosu::KbLeft)
    @hero.go_right if Gosu::button_down?(Gosu::KbRight)
    @hero.move
  end

  def draw
    @background_image.draw(0, 0, ZOrder::Background)
    @hero.draw
  end

end
