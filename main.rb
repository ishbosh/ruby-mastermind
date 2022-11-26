# frozen_string_literal: true
require_relative 'display'

# MasterMind Game
module MasterMind
  
  # - Game - #
  class Game
    include DisplayText

    attr_reader :computer, :player, :maker, :breaker, :code
    attr_accessor :guess

    def initialize
      @player = Player.new
      @computer = Computer.new
      play
    end

    def play
      intro
      game_setup
      game_loop
      game_result
    end
    
    def intro
      puts show_intro
    end

    def game_setup
      player_name
      define_roles
      reset_guesses
      create_code
    end

    def player_name
      player.name = gets.chomp.strip.downcase.capitalize
      player.name = 'You' if player.name.empty?
    end

    def define_roles
      puts show_role_prompt
      player.role = player.role_input
      if player.role == 'break'
        @breaker = @player
        @maker = @computer
      elsif player.role == 'make'
        @breaker = @computer
        @maker = @player
      end
    end

    def reset_guess
      @guess = ''
      @breaker.guesses = 12
    end

    def create_code
      if player.role == 'break'
        @code = computer.generate_code.freeze
      elsif player.role == 'make'
        @code = player.generate_code.freeze
      end
    end
    
    def game_loop
      feedback = nil
      until breaker.guesses == 0
        self.guess = breaker.guess if breaker == @player
        self.guess = breaker.guess(feedback) if breaker == @computer
        break if correct?(guess)
        
        feedback = feedback(compare_to_code(guess))
        puts 'Guess Feedback: ' + show_feedback(feedback)
      end
    end

    def game_result
      game_over if breaker.guesses == 0
      victory if correct?(guess)
    end

    def victory
      puts show_victory(code, breaker.name)
    end

    def game_over
      puts show_game_over(code, breaker.name)
    end

    def compare_to_code(guess)
      code_array = code.chars.each_with_index.to_a
      guess_array = guess.chars.each_with_index.to_a
      total_correct = code.chars.intersection(guess.chars).count
      correct = guess_array & code_array
      misplaced_count = total_correct - correct.count
      [correct.count, misplaced_count]
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

    def correct?(guess)
      code.eql?(guess)
    end
  end

  # - Player - #
  class Player
    include DisplayText

    attr_accessor :role, :name
    
    def initialize
      @name = 'You'
      @guesses = 12
      @role = 'break'
    end

    def guess
      puts show_guess_number(guesses)
      self.guesses -= 1
      guess = guess_input
    end

    def guess_input
      input = ''
      print show_guess_prompt
      loop do
        input = gets.chomp.slice(0...4).to_s
        break if input.chars.all? { |char| [*1..6].include?(char.to_i)}

        puts show_guess_error
      end
      input
    end

    def role_input
      valid_answers = ['break', 'make']
      input = 'break'
      loop do
        input = gets.chomp.downcase
        break if valid_answers.include?(input)

        puts show_role_error
      end
      input
    end

  end

  # - Computer - #
  class Computer
    include DisplayText

    attr_accessor :guess

    def initialize
      @name = 'Computer'
      @guesses = 12
      @guess = ''
    end
    
    def guess(feedback)
      puts show_guess_number(guesses)
      if feedback
        @guess = guess_using_feedback(feedback)
      else 
        @guess = guess_randomly
      end
      self.guesses -= 1
      @guess
    end

    def guess_randomly
      output = ''
      4.times {output += rand(1..6).to_s} 
      output
    end

    def guess_using_feedback(feedback)
      output = ''
      feedback.chars.each_with_index do |n, i|
        output[i] = rand(1..6) if n == '-'
        output[i] = guess[i] if n == 'o'
        output[i] = guess.each_char.map(&:to_i).sample.to_s if n == 'x'
      end
      output
    end

    def generate_code
      code = ''
      while code.size < 4
       code += rand(1..6).to_s
      end
      code
    end
  end

  Game.new
end
