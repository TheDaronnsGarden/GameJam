
class Hero

  attr_reader :x, :y
  attr_accessor :vy, :mort, :jumpPower

  def initialize(map, x, y) # x,y -> Point de spawn du perso
    @x, @y = x, y
    @dir = :left
    @vy = 0 # Vitesse en y
    @map = map
    @mort = false # Le perso n'est pas mort de base (logique)
    @jumpPower = -15 # Puissance du saut du personnage (négatif car y inversé)
    # Chargement images du perso
    @stop, @left, @jump, @dead = *Gosu::Image.load_tiles("ressources/TilesSprites3.png", 53, 53)

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

  def setPosition(x, y)
    @x, @y = x, y
  end

  # Could the object be placed at x + offs_x/y + offs_y without being stuck?
  def would_fit(offs_x, offs_y)
    # Check at the center/top and center/bottom for map collisions
    not @map.isSolid(@x + offs_x, @y + offs_y) and
      not @map.isSolid(@x + offs_x, @y + offs_y - 45)
  end

  def update(moveX)
      # Modification de l'image du perso en fonction de son mouvement
    # Si le perso est toujours en vie, mouvement normaux
    if (not self.isDead)

      if (moveX == 0)
        @cur_image = @stop
      else
        @cur_image = @left # image @left car Hero.draw effectue lui-même la symétrie
      end

      # Si le perso saute
      if (@vy < 0)
        # Si le perso est immobile
        if (moveX == 0)
          @cur_image = @stop
        else
          @cur_image = @jump
        end
      end
    else 
      @cur_image = @dead
    end

    # Direction et mouvement horizontal
    if moveX > 0
      @dir = :right
      moveX.times { if would_fit(1, 0) then @x += 1 end }
    end
    if moveX < 0
      @dir = :left
      (-moveX).times { if would_fit(-1, 0) then @x -= 1 end }
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
      @vy = @jumpPower
    end
  end

  def isDead
    @mort
  end




end
