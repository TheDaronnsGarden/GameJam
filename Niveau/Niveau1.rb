require 'gosu'

require_relative 'z_order'
require_relative '../Classes/Hero'
require_relative '../Classes/Window'

WindowWidth = 1920
WindowHeight = 1080

Window = Window.new(WindowWidth, WindowHeight)
Window.show
