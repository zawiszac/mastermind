# frozen_string_literal: true

require_relative 'game.rb'

print 'How many guesses? '
rounds = gets.chomp.to_i
print 'Will you be the codemaker y/n?: '
choice = gets.chomp.downcase

game = Game.new(rounds, choice)
game_is_over = false

until game_is_over
  round_result = game.play_round
  if round_result.first == true
    puts "#{round_result.last} wins!"
    game_is_over = true
  end
end


