#  spec for game
# include Game
require_relative './../game.rb'

describe 'Game'  do
  before(:all) do
    @game_obj = Game.new(2, 10)
  end

  context '#generate_randon_turn' do
    it 'returns the players in random order' do
      random_players = @game_obj.generate_random_turns
      expect(random_players.count).to eq(2)
      expect(random_players).to match_array([0, 1])
    end
  end
	
end