require 'gosu'
require_relative 'menuitem.rb'
require_relative 'menu.rb'
require_relative 'Niveau/Niveau.rb'


class Window < Gosu::Window

  def initialize
    @test = 0
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
    @musiqueOn = Gosu::Image.new(self,"GFX/imageSonOnv2.png")
    @musiqueOff = Gosu::Image.new(self,"GFX/imageSonOffv2.png")

    @lesamis = Gosu::Song.new("musique.wav")
    @lesamis.volume = 0

    @amis = Gosu::Sample.new("amis.wav")

    #image du bouton menu principal
    @imageQuitter = Gosu::Image.new("GFX/retour.png")

    #police
    @font = Gosu::Font.new(self, Gosu::default_font_name,40)

    @index=0
    @t = 0

@menu = Menu.new(self)
      @menu.add_item(Gosu::Image.new(self, "GFX/Titre.png", false), 255, 55, 1, lambda {})
      y += lineHeight

      @menu.add_item(Gosu::Image.new(self, "GFX/JardinerUnclicked.png", false), x, y, 1, lambda {
        if @t >10 && @index ==0
          @t = 0
          @jeu = Niveau.new
          self.close
          @jeu.show

        end
        }, Gosu::Image.new(self, "GFX/JardinerClicked.png", false))
      y += lineHeight

			@menu.add_item(Gosu::Image.new(self, "GFX/ScoreUnclicked.png", false), x, y, 1, lambda {

        if @index==0 && @t>10
          @index=1
          @t = 0
        end
        }, Gosu::Image.new(self, "GFX/ScoreClicked.png", false))
			y += lineHeight

      @menu.add_item(Gosu::Image.new(self, "GFX/QuitterUnclicked.png", false), x, y, 1, lambda {
        if @index ==0
          @song.play(1)
          @lesamis.volume=0
          sleep 1.2
          self.close
        end
        }, Gosu::Image.new(self, "GFX/QuitterClicked.png", false))
      y += lineHeight

      @menu.add_item(Gosu::Image.new(self, "GFX/OptionUnclicked.png", false), x+35, y, 1, lambda {
        if @index==0 && @t>10
          @index=3
          @t = 0
        end

        }, Gosu::Image.new(self, "GFX/OptionClicked.png", false))
			y += lineHeight
  end
  def update
    @t = @t+1
    if @index==0
      @menu.update
      #appui sur la tete
      case mouse_x
        when (150..176)
          case mouse_y
            when (680..727)
              if (button_down?Gosu::MsLeft) && @o==0
                @o=1
                @amis.play
              end#end if button && o
            else#end when
              @o=0
            end#end mouse_y
          else
            @o=0
          end
    end#end mouse_x
  end#end update
  def draw

    if @index==0
      @cursor.draw(self.mouse_x, self.mouse_y, 2)
      @background_image.draw(0,0,0)
      @menu.draw
    elsif @index == 3
      @cursor.draw(self.mouse_x,self.mouse_y,2)
      @background_image.draw(0,0,0)
      #Image du bouton quitter (pas possible d'avoir 2 menus)
      @imageQuitter.draw(0,0,1)
      #si click la ou il y a l'image, retourne au menu de base
      case mouse_x
      when (0..@imageQuitter.width)
       case mouse_y
       when (0..@imageQuitter.height)
         if button_down?(Gosu::MsLeft)
           @index=0
         end#end if
       end#end mouse_y
      end#end mouse_x
      @font.draw("Musique",300,300,1,1,1,Gosu::Color::WHITE)

      if (@lesamis.volume==0)
        @musiqueOff.draw(500,280,1)
      else
        @musiqueOn.draw(500,280,1)
      end
      case mouse_x
      when (500..500+@musiqueOn.width)
        case mouse_y
        when (280..280+@musiqueOn.height)
          if (button_down?Gosu::MsLeft) && @test == 0
            @test = 1
            if @lesamis.volume==0
              @lesamis.volume=0.2
              @lesamis.play(true)
            else
              @lesamis.volume=0
            end
          end
        else
          @test = 0
        end
      else
        @test = 0

      end
    elsif @index==1
      @cursor.draw(self.mouse_x, self.mouse_y, 2)
      @background_image.draw(0,0,0)
      #Image du bouton quitter (pas possible d'avoir 2 menus)
      @imageQuitter.draw(0,0,1)
      #si click la ou il y a l'image, retourne au menu de base
     case mouse_x
     when (0..@imageQuitter.width)
       case mouse_y
       when (0..@imageQuitter.height)
         if button_down?(Gosu::MsLeft)
           @index=0
         end#end if
       end#end mouse_y
     end#end mouse_x
     #lecture du fichier score
      f = File.open("score.txt","r")
      #10 arrays vides pour stocker les scores et noms des joueurs
      @a=[]
      @b=[]
      @c=[]
      @d=[]
      @e=[]

      f.each_line{|ligne|
        @li = ligne.partition(";")#li : tableau avec
        # [score , ; , nomJoueur] de la ligne courante
        # remplit chaque array
        if @a.empty?
          @a = @li.dup
          @scoreA = @a[0]#score du 1er joueur
          @nomA= @a[2].partition("\n")#supprime le retour a la ligne de la fin
          @nomA=@nomA[0]#nom du 1er joueur
        elsif @b.empty?
          @b = @li.dup
          @scoreB = @b[0]#score du 2eme joueur
          @nomB= @b[2].partition("\n")#supprime le retour a la ligne de la fin
          @nomB=@nomB[0]#nom du 2eme joueur
        elsif @c.empty?
          @c = @li.dup
          @scoreC = @c[0]#score du 3eme joueur
          @nomC= @c[2].partition("\n")#supprime le retour a la ligne de la fin
          @nomC=@nomC[0]#nom du 3eme joueur
        elsif @d.empty?
          @d = @li.dup
          @scoreD = @d[0]#score du 4eme joueur
          @nomD= @d[2].partition("\n")#supprime le retour a la ligne de la fin
          @nomD=@nomD[0]#nom du 4eme joueur
        elsif @e.empty?
          @e = @li.dup
          @scoreE = @e[0]#score du 5eme joueur
          @nomE= @e[2].partition("\n")#supprime le retour a la ligne de la fin
          @nomE=@nomE[0]#nom du 5eme joueur
        end
      }
      # affichage du 1er joueur : Score  Nom
      if @scoreA.to_i < 10
        @font.draw("000"+@scoreA+"   -   "+@nomA,@WIDTH/3,@HEIGHT/4,1,1.0,1.0,Gosu::Color::WHITE)
      elsif @scoreA.to_i>9 && @scoreA.to_i<100
        @font.draw("00"+@scoreA+"   -   "+@nomA,@WIDTH/3,@HEIGHT/4,1,1.0,1.0,Gosu::Color::WHITE)
      elsif @scoreA.to_i>99&& @scoreA.to_i<1000
        @font.draw("0"+@scoreA+"   -   "+@nomA,@WIDTH/3,@HEIGHT/4,1,1.0,1.0,Gosu::Color::WHITE)
      end
      # affichage du 2eme joueur
      if @scoreB.to_i < 10
        @font.draw("000"+@scoreB+"   -   "+@nomB,@WIDTH/3,@HEIGHT/4+@font.height,1,1.0,1.0,Gosu::Color::WHITE)
      elsif @scoreB.to_i>9 && @scoreB.to_i<100
        @font.draw("00"+@scoreB+"   -   "+@nomB,@WIDTH/3,@HEIGHT/4+@font.height,1,1.0,1.0,Gosu::Color::WHITE)
      elsif @scoreB.to_i>99&& @scoreB.to_i<1000
        @font.draw("0"+@scoreB+"   -   "+@nomB,@WIDTH/3,@HEIGHT/4+@font.height,1,1.0,1.0,Gosu::Color::WHITE)
      end
      # affichage du 3eme joueur
      if @scoreC.to_i < 10
        @font.draw("000"+@scoreC+"   -   "+@nomC,@WIDTH/3,@HEIGHT/4+@font.height*2,1,1.0,1.0,Gosu::Color::WHITE)
      elsif @scoreC.to_i>9 && @scoreC.to_i<100
        @font.draw("00"+@scoreC+"   -   "+@nomC,@WIDTH/3,@HEIGHT/4+@font.height*2,1,1.0,1.0,Gosu::Color::WHITE)
      elsif @scoreC.to_i>99&& @scoreC.to_i<1000
        @font.draw("0"+@scoreC+"   -   "+@nomC,@WIDTH/3,@HEIGHT/4+@font.height*2,1,1.0,1.0,Gosu::Color::WHITE)
      end
      # affichage du 4eme joueur
      if @scoreD.to_i < 10
        @font.draw("000"+@scoreD+"   -   "+@nomD,@WIDTH/3,@HEIGHT/4+@font.height*3,1,1.0,1.0,Gosu::Color::WHITE)
      elsif @scoreD.to_i>9 && @scoreD.to_i<100
        @font.draw("00"+@scoreD+"   -   "+@nomD,@WIDTH/3,@HEIGHT/4+@font.height*3,1,1.0,1.0,Gosu::Color::WHITE)
      elsif @scoreD.to_i>99&& @scoreD.to_i<1000
        @font.draw("0"+@scoreD+"   -   "+@nomD,@WIDTH/3,@HEIGHT/4+@font.height*3,1,1.0,1.0,Gosu::Color::WHITE)
      end
      # affichage du 5eme joueur
      if @scoreE.to_i < 10
        @font.draw("000"+@scoreE+"   -   "+@nomE,@WIDTH/3,@HEIGHT/4+@font.height*4,1,1.0,1.0,Gosu::Color::WHITE)
      elsif @scoreE.to_i>9 && @scoreE.to_i<100
        @font.draw("00"+@scoreE+"   -   "+@nomE,@WIDTH/3,@HEIGHT/4+@font.height*4,1,1.0,1.0,Gosu::Color::WHITE)
      else @scoreE.to_i>99&& @scoreE.to_i<1000
        @font.draw("0"+@scoreE+"   -   "+@nomE,@WIDTH/3,@HEIGHT/4+@font.height*4,1,1.0,1.0,Gosu::Color::WHITE)
      end
    end

  end

  def button_down (id)
		if id == Gosu::MsLeft then
			@menu.clicked
    end # end if
	end # end button_down
end # END CLASS WINDOWMENU
