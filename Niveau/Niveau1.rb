require 'gosu'

require_relative 'z_order'
require_relative 'Hero'
require_relative 'Window'

WindowWidth = 1920
WindowHeight = 1080

Window = Window.new(WindowWidth, WindowHeight)
Window.show
