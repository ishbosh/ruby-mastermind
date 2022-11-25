# frozen_string_literal: true
require_relative 'display'

# MasterMind Game
module MasterMind
  
  class Game
    include DisplayText

    attr_reader :computer, :player, :code
    attr_accessor :guess

    def initialize
      @player = Player.new
      @computer = Computer.new
      game_setup
    end
    
    def game_setup
      @code = computer.generate_code.freeze
      @guess = ''
      play
    end

    def play
      game_loop
    end
    
    def game_loop
      until player.guesses == 0
        self.guess = player.guess
        break if correct?(guess)
        
        correct, misplaced = compare_to_code(guess)
        puts 'Guess Feedback: ' + show_feedback(feedback(correct, misplaced))
        game_over if player.guesses == 0
      end
      puts show_victory(code) if correct?(guess)
    end

    def game_over
      puts show_game_over(code)
    end

    def feedback(correct_count, misplaced_count, feedback = ['-','-','-','-'])
      feedback.each_with_index do |val, i|
        if correct_count > 0
          feedback[i] = 'o' 
          correct_count -= 1
        elsif feedback[i] == '-' && misplaced_count > 0 
          feedback[i] = 'x'
          misplaced_count -= 1
        end
      end
      feedback
    end

    def compare_to_code(guess)
      code_array = code.chars.each_with_index.to_a
      guess_array = guess.chars.each_with_index.to_a
      total_correct = code.chars.intersection(guess.chars).count
      correct = guess_array & code_array
      misplaced_count = total_correct - correct.count
      [correct.count, misplaced_count]
    end

    def correct?(guess)
      code.eql?(guess)
    end


  end

  class Player
    include DisplayText

    attr_accessor :guesses
    
    def initialize
      @guesses = 12
    end

    def guess
      show_guess_number(guesses)
      self.guesses -= 1
      guess = input
    end

    def input(input = '')
      print show_guess_prompt
      loop do
        input = gets.chomp.slice(0...4).to_s
        break if input.chars.all? { |char| [*1..6].include?(char.to_i)}

        puts show_guess_error
      end
      input
    end

  end

  class Computer

    def generate_code
      code = ''
      while code.size < 4
       code += rand(1..6).to_s
      end
      code
    end
  end

  ## Do we need a separate class for the board?
  class Board
  end

  Game.new
end
