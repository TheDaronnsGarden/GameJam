require 'gosu'
require_relative 'menuitem.rb'
require_relative 'menu.rb'


class Window < Gosu::Window

  def initialize
    @WIDTH = 1020
    @HEIGHT = 780
    super @WIDTH,@HEIGHT
    self.caption = "The Darron's Garden"
    @background_image = Gosu::Image.new('GFX/Backgroundmenu2.png')

    @cursor = Gosu::Image.new(self, "GFX/curseurFeuille.png", false)
		x = self.width / 1.8 - 100
		y = self.height  / 3.5 - 100
		lineHeight = 90

    @song = Gosu::Sample.new("pourquoiv2.wav")

    @lesamis = Gosu::Song.new("lesamis.wav")
    @lesamis.volume = 0.2

    #police
    @font = Gosu::Font.new(self, Gosu::default_font_name,40)

    #index pour savoir quelle "fenetre" afficher
    #0 : menu principal
    #1 : score
    #2 : game over
    #3 : parametres
    #4 : jeu

    @index=0

@menu = Menu.new(self)
      @menu.add_item(Gosu::Image.new(self, "GFX/Titre.png", false), 255, 55, 1, lambda {})
      y += lineHeight

      @menu.add_item(Gosu::Image.new(self, "GFX/JardinerUnclicked.png", false), x, y, 1, lambda {}, Gosu::Image.new(self, "GFX/JardinerClicked.png", false))
      y += lineHeight

			@menu.add_item(Gosu::Image.new(self, "GFX/ScoreUnclicked.png", false), x, y, 1, lambda {}, Gosu::Image.new(self, "GFX/ScoreClicked.png", false))
			y += lineHeight

      @menu.add_item(Gosu::Image.new(self, "GFX/QuitterUnclicked.png", false), x, y, 1, lambda {
        @song.play(1)
        sleep 1.2
        self.close
        }, Gosu::Image.new(self, "GFX/QuitterClicked.png", false))
      y += lineHeight

      @menu.add_item(Gosu::Image.new(self, "GFX/OptionUnclicked.png", false), x+35, y, 1, lambda {}, Gosu::Image.new(self, "GFX/OptionClicked.png", false))
			y += lineHeight

      @menu.add_item(Gosu::Image.new(self, "musiqueOn.png", false), 775, 550, 1, lambda {
        @lesamis.play(true)
        @lesamis.volume = 0.2
        })

      @menu.add_item(Gosu::Image.new(self, "musiqueOff.gif", false), 900, 570, 1, lambda {
        @lesamis.volume = 0
          })


  end

  def update
    # Game logic
    @menu.update
  end

  def draw
    @cursor.draw(self.mouse_x, self.mouse_y, 2)
    @background_image.draw(0,0,0)
    @menu.draw

  end

  def button_down (id)
		if id == Gosu::MsLeft then
			@menu.clicked
    end # end if
	end # end button_down
end # END CLASS WINDOWMENU
