
class Hero

  attr_reader :x, :y

  def initialize(map, x, y)
    @x, @y = x, y
    @dir = :left
    @vy = 0 # Vitesse en y
    @map = map
    # Chargement images du perso
    @stop, @left, @right, @jump = *Gosu::Image.load_tiles("../ressources/TilesSprites.png", 50, 50)

    # L'image de base est l'arrêt
    @cur_image = @stop
  end

  def draw
    # Symetrie verticale selon la direction où regarde le perso
    if @dir == :left
      offs_x = -25
      factor = 1.0
    else
      offs_x = 25
      factor = -1.0
    end
    @cur_image.draw(@x + offs_x, @y - 49, 0, factor, 1.0)
  end

  # Could the object be placed at x + offs_x/y + offs_y without being stuck?
  def would_fit(offs_x, offs_y)
    # Check at the center/top and center/bottom for map collisions
    not @map.isSolid(@x + offs_x, @y + offs_y) and
      not @map.isSolid(@x + offs_x, @y + offs_y - 45)
  end

  def update(move_x)
    # Modification de l'image du perso en fonction de son mouvement
    if (move_x == 0)
      @cur_image = @stop
    elsif (@dir == :left)
      @cur_image = @left
    else
      @cur_image = @right
    end

    if (@vy < 0)
      @cur_image = @jump
    end

    # Direction et mouvement horizontal
    if move_x > 0
      @dir = :right
      move_x.times { if would_fit(1, 0) then @x += 1 end }
    end
    if move_x < 0
      @dir = :left
      (-move_x).times { if would_fit(-1, 0) then @x -= 1 end }
    end

    # Mouvement vertical
    @vy += 1
    if @vy > 0
      @vy.times { if would_fit(0, 1) then @y += 1 else @vy = 0 end }
    end
    if @vy < 0
      (-@vy).times { if would_fit(0, -1) then @y -= 1 else @vy = 0 end }
    end

  end

  def jump
    # Si le bloc du dessus n'est pas solide, le perso peut sauter
    if @map.isSolid(@x, @y + 1)
      @vy = -15
    end
  end
end
