# frozen_string_literal: true

require_relative 'game.rb'

# puts 'How many rounds do you want to play? '
# rounds = gets.chomp.to_i
game = Game.new(12)
game_is_over = false

until game_is_over
  round_result = game.play_round
  if round_result.first == true
    puts "You #{round_result.last}"
    game_is_over = true
  end
end
