require 'colorize'
class Player
  attr_accessor :name, :points, :complete, :rank, :previous_step, :skip_next_turn
  
  def initialize(name)
    @name = name
    @points = 0
    @complete = false
    @previous_step = 0
    @skip_next_turn = false
    @rank = 6
  end
end

class Game
  # attr_accessor :no_of_players

  def initialize(no_of_players = read_players , total_points = read_points)
    @no_of_players = no_of_players.to_i
    @total_points = total_points.to_i
  end

  def generate_random_turns
    (0...@no_of_players).collect{|player_no| player_no}.shuffle
  end


  def print_table(players)
    puts "\nPlayer Name |  Points | Rank".green
    puts "------------------------------".green
    players.each do |player|
      puts "#{player.name}    |   #{player.points}    | #{player.rank}".green
    end
    puts "------------------------------".green
  end

  def update_rank(players)
    rank = 1
    players.sort_by{|obj| -obj.points}.map do |player|
      player.rank = rank
      rank +=1
    end
  end

  def read_players
    puts "Enter the number of Players"
    no_of_players = gets.chomp
  end

  def read_points
    puts "Enter the value of M(points to accumulate)"
    total_points = gets.chomp
  end

  def start
    player_turns = generate_random_turns
    players = []
    (1..@no_of_players).each_with_index do |player, indx|
      players << Player.new("Player-#{indx+1}")
    end


    i = 0
    again = ""
    winner_count = 0
    while(true)
      i = i % @no_of_players
      current_player = players[player_turns[i]]
      i +=1 and next if current_player.complete
      
      if current_player.skip_next_turn
        current_player.previous_step = 0
        current_player.skip_next_turn  = false
        puts "skipped the turn of #{current_player.name}".red
        print_table(players)
        i +=1
        next
      end

      puts "\n#{current_player.name}, its #{again} your turn (press ‘r’ to roll the dice)"
      input = gets.chomp
      if input == 'r'
        dice_points = rand(1..6)
        if dice_points == 6
          again = "again"
        elsif dice_points == 1 && current_player.previous_step == 1
          puts "#{current_player.name}, you got consecutive 1".red
          current_player.skip_next_turn = true
          i +=1
        else
          i +=1
          again = ""
        end
        current_player.previous_step = dice_points
        puts "\n dice value = " + dice_points.to_s.green

        if (current_player.points + dice_points) < @total_points
          current_player.points = current_player.points + dice_points
        elsif current_player.points + dice_points == @total_points
          current_player.points = current_player.points + dice_points
          current_player.complete = true
          puts "congratulation!! #{current_player.name} completed the points".yellow
          winner_count +=1
        end
      end
      update_rank(players)
      print_table(players)
      break if winner_count + 1 == @no_of_players
    end
    puts "\nfinal result\n".yellow
    print_table(players)
  end
end
