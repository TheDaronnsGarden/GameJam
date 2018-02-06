
class Hero

  attr_reader :x, :y

  def initialize(map, x, y)
    @x, @y = x, y
    @dir = :left
    @vy = 0 # Vertical velocity
    @map = map
    # Load all animation frames
    @standing, @walk1, @walk2, @jump = *Gosu::Image.load_tiles("../ressources/cptn_ruby.png", 50, 50)
    # This always points to the frame that is currently drawn.
    # This is set in update, and used in draw.
    @cur_image = @standing
  end

  def draw
    # Flip vertically when facing to the left.
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
    # Select image depending on action
    if (move_x == 0)
      @cur_image = @standing
    elsif (@dir == :left)
      @cur_image = @walk1
    else
      @cur_image = @walk2
    end

    if (@vy < 0)
      @cur_image = @jump
    end

    # Directional walking, horizontal movement
    if move_x > 0
      @dir = :right
      move_x.times { if would_fit(1, 0) then @x += 1 end }
    end
    if move_x < 0
      @dir = :left
      (-move_x).times { if would_fit(-1, 0) then @x -= 1 end }
    end

    # Acceleration/gravity
    # By adding 1 each frame, and (ideally) adding vy to y, the player's
    # jumping curve will be the parabole we want it to be.
    @vy += 1
    # Vertical movement
    if @vy > 0
      @vy.times { if would_fit(0, 1) then @y += 1 else @vy = 0 end }
    end
    if @vy < 0
      (-@vy).times { if would_fit(0, -1) then @y -= 1 else @vy = 0 end }
    end

  end

  def try_to_jump
    if @map.isSolid(@x, @y + 1)
      @vy = -15
    end
  end
end
