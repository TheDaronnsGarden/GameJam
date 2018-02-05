class Hero

  def initialize(x, y)
    @x = x
    @y = y
    @velocityX = 0.0
    @velocityY = 0.0
    # création d'un tableau qui contiendra les différentes images du héros
    @images = []
    # on ajoute les 4 images dans le tableau
    @images.push(Gosu::Image.new("res/hero/face.png"))
    @images.push(Gosu::Image.new("res/hero/dos.png"))
    @images.push(Gosu::Image.new("res/hero/gauche.png"))
    @images.push(Gosu::Image.new("res/hero/droite.png"))
    # de base, le héros est de face
    @image = @images[0]
  end

  def draw
    @image.draw(@x, @y, ZOrder::Hero)
  end

  def go_left
    @velocityX -=  0.4
    # changement de l'image du héros : tourné vers la gauche
    @image = @images[2]
  end

  def go_right
    @velocityX += 0.4
    # changement de l'image du héros : tourné vers la droite
    @image = @images[3]
  end

  def move
    @x += @velocityX
    @x %= 1024
    @y += @velocityY
    @y %= 576
    @velocityX *= 0
    @velocityY *= 0
  end

end
