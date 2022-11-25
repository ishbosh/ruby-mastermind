# frozen_string_literal: true
require_relative 'display'

# MasterMind Game
module MasterMind
  
  class Game
    attr_reader :computer, :player, :code, :guess

    def initialize
      @player = Player.new
      @computer = Computer.new
      game_setup
    end
    
    def game_setup
      @code = computer.generate_code
      @guess = ''
      play
    end

    def play
      game_loop
    end
    
    def game_loop
      until player.guesses == 0 || correct?(guess)
        self.guess = player.guess
      end
    end

    # check the guess
    def compare_to_code(guess)
      
      code_array = code.chars.each_with_index.to_a
      guess_array = guess.chars.each_with_index.to_a

      differences = code_array - guess_array
      correct_positions = code_array - differences
      
      total_correct = code.chars.intersection(guess.chars).count
      wrong_positions = total_correct - correct_positions.count
      
      [correct_positions, wrong_positions]
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
      self.guesses -= 1
      guess = input
    end

    def input(guess = '', input_count = 0)
      while input_count < 4
        print show_guess_prompt(input_count + 1)
        input = gets.chomp.to_i
        if [*1..6].include?(input)
          input_count += 1
          guess += input.to_s
        else
          puts show_guess_error
        end
      end
      guess
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
