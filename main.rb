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
      @code = computer.generate_code
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
        
        correct, close = compare_to_code(guess)
        puts 'Guess Feedback: ' + show_feedback(feedback(correct, close))
        game_over if player.guesses == 0
      end
      puts show_victory(code) if correct?(guess)
    end

    def game_over
      puts show_game_over
    end

    def feedback(correct, close)
      feedback = ['-','-','-','-']
      correct.each { |digit| feedback[digit[1]] = 'o'}
      close.each { |digit| feedback[digit[1]] = 'x' }
      feedback
    end

    def compare_to_code(guess)
      code_array = code.chars.each_with_index.to_a
      guess_array = guess.chars.each_with_index.to_a
      correct = guess_array & code_array
      differences = guess_array - code_array
      correct_digits = correct.map { |array| array.first }
      close_digits = (guess.chars & code.chars) - correct_digits
      close = close_digits.map { |digit| differences.assoc(digit) }
      [correct, close]
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
