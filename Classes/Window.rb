class Window < Gosu::Window

  def initialize(width, height)
    super
    self.caption = ""

    @background_image = Gosu::Image.new("../Ressources/background.png")

    @player = Player.new
  end

  def update
    @player.go_left if Gosu::button_down?(Gosu::KbLeft)
    @player.go_right if Gosu::button_down?(Gosu::KbRight)

    @player.move
  end

  def draw
    @background_image.draw(0, 0, ZOrder::Background)
    @player.draw
  end

end
