
require_relative 'display'

# MasterMind Game
module MasterMind
  
  # - Game - #
  class Game
    include DisplayText

    attr_reader :computer, :player, :maker, :breaker, :code
    attr_accessor :guess

    MAX_GUESSES = 12

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

    # - Methods for Introducing and Concluding the Game - #
    def intro
      puts show_intro
    end

    def game_result
      correct?(guess) ? victory : game_over
    end

    def victory
      puts show_victory(code, breaker.name)
    end

    def game_over
      puts show_game_over(code, breaker.name)
    end

    # - Methods For Setting Up The Game - #
    def game_setup
      player_name
      define_roles
      reset_guesses
      create_code
    end

    def player_name
      print show_name_prompt
      player.name = gets.chomp.strip.downcase.capitalize
      player.name = 'You' if player.name.empty?
    end

    def define_roles
      puts show_role_prompt
      player.role = player.role_input
      if player.role == 'break'
        @breaker = @player
      elsif player.role == 'make'
        @breaker = @computer
      end
    end

    def reset_guesses
      @guess = ''
      breaker.guesses = MAX_GUESSES
    end

    def create_code
      if player.role == 'break'
        @code = computer.create_code.freeze
      elsif player.role == 'make'
        @code = player.create_code.freeze
      end
    end
    
    # - Methods For The Main Game Loop - #
    def game_loop
      feedback = nil
      until breaker.guesses == 0
        self.guess = new_guess(feedback)
        break if correct?(guess)
        
        feedback = feedback(*compare_to_code(guess))
        puts show_feedback(feedback)
        sleep(0.5)
      end
    end

    def new_guess(feedback)
      turn_number = MAX_GUESSES - breaker.guesses + 1
      puts show_turn_number(turn_number)
      breaker == @player ? breaker.guess : breaker.guess(feedback) 
    end

    # - Methods for Checking the Guess Against the Code & Providing Feedback - #
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

    attr_accessor :role, :name, :guesses
    
    def initialize
      @name = 'You'
      @guesses = 12
      @role = 'break'
    end

    def create_code
      print show_code_prompt
      code = code_input
    end

    def guess
      self.guesses -= 1
      print show_guess_prompt
      guess = code_input
    end

    def code_input
      input = ''
      loop do
        input = gets.chomp.slice(0...4).to_s
        break if input.chars.all? { |char| [*1..6].include?(char.to_i)}

        puts show_invalid_error
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

    attr_accessor :guess, :guesses
    attr_reader :name

    def initialize
      @name = 'Computer'
      @guesses = 12
      @guess = ''
      @numbers = ['1', '2', '3', '4', '5', '6']
      @possible_codes = @numbers.repeated_permutation(4).to_a
    end
    
    def guess(feedback)
      update_permutations(feedback)
      @guess = guesses == 12 ? first_guess : guess_random_permutation(feedback)
      update_guesses_remaining
      puts show_computer_guess(@guess)
      @guess
    end

    def update_guesses_remaining
      self.guesses -= 1
    end

    def guess_random_permutation
      output = @possible_codes.sample.join
    end

    # def guess_using_feedback(feedback)
    #   output = ''
    #   update_permutations(feedback)


    #   #   #deprecated
    #   # feedback.each_with_index do |n, i|
    #   #   # output[i] = @numbers.sample.to_s if n == '-'
    #   #   # output[i] = @guess[i] if n == 'o'
    #   #   # output[i] = @guess.each_char.map(&:to_i).sample.to_s if n == 'x'
    #   # end
    #   output
    # end

    def update_permutations(feedback)
      feedback_result = feedback.join == '----' ? true : false
      # When True, remove permutations that DO include any nums from guess
      # When False, remove permutations that do NOT include any nums from guess
      @possible_codes = @possible_codes.select do |code| 
        (code & @guess.chars).empty? == feedback_result
      end
      # Remove the last incorrect guess from the possible results so no repeats
      @possible_codes.delete(@guess.chars)
    end

    def first_guess
      ['1122', '2332', '4343', '6655', '4554'].sample
    end

    def create_code
      code = ''
      while code.size < 4
       code += rand(1..6).to_s
      end
      code
    end
  end

  Game.new
end
