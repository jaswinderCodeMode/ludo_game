require './game'

class Play
  def initialize
    ::Game.new.start
  end
end

Play.new