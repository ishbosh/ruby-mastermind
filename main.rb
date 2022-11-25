# frozen_string_literal: true
require_relative 'display'

# MasterMind Game
module MasterMind
  
  class Game
    attr_reader :computer, :player, :code, :guess

    def initialize
      @player = Player.new
      @computer = Computer.new
      play
    end
    
    def play
      @code = computer.generate_code
      @guess = player.guess
    end

    # check the guess
    def correct?
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
