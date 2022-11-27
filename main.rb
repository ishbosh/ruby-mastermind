
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
      puts show_victory(code, breaker.name, maker.name)
    end

    def game_over
      puts show_game_over(code, breaker.name, maker.name)
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
        @breaker = player
        @maker = computer
      elsif player.role == 'make'
        @breaker = computer
        @maker = player
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
        sleep(1)
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
      update_permutations(feedback) if feedback
      @guess = guesses < 11 ? choose_guess_type(feedback) : initial_guesses
      puts show_computer_guess(@guess)
      update_guesses_remaining
      test_case = @possible_codes.include?(['4','5','5','6'])
      @guess
    end

    def initial_guesses
      if guesses == 12
        return first_guess 
      elsif guesses == 11
        return second_guess 
      elsif guesses == 10
        return third_guess 
      end
    end

    def update_guesses_remaining
      self.guesses -= 1
    end

    def random_permutation(feedback)
      if feedback.join.count('x' + 'o') == 4
        output = shuffle
      else
        output = @possible_codes.sample.join
      end
    end

    def choose_guess_type(feedback)
      slice = feedback.join.slice(0..2)
      best_matches(slice) if slice.count('o' + 'x') > 1
      random_permutation(feedback)
    end

  
    def best_matches(slice)
      if slice.count('o') == 3
        remove_by_triples
      elsif slice.count('o') == 2
        remove_by_pairs
      elsif slice.count('o' + 'x') == 3
        remove_by_triples_misplaced
      else
        remove_by_pairs_misplaced
      end
      test_case = @possible_codes.include?(['4','5','5','6'])
    end

    def remove_by_triples
      @possible_codes = @possible_codes.select do |code| 
        code = code.join
        code.include?(@guess[0..2]) ||
        code.include?(@guess[1..3]) ||
        (code.include?(@guess[0]) && code.include?(@guess[1]) && code.include?(@guess[3])) ||
        (code.include?(@guess[0]) && code.include?(@guess[2]) && code.include?(@guess[3]))
      end
    end

    def remove_by_triples_misplaced
      @possible_codes = @possible_codes.select do |code| 
        code = code.join
        (code.include?(@guess[0]) && code.include?(@guess[1]) && code.include?(@guess[2])) ||
        (code.include?(@guess[1]) && code.include?(@guess[2]) && code.include?(@guess[3])) ||
        (code.include?(@guess[0]) && code.include?(@guess[1]) && code.include?(@guess[3])) ||
        (code.include?(@guess[0]) && code.include?(@guess[2]) && code.include?(@guess[3]))
      end
    end

    def remove_by_pairs
      @possible_codes = @possible_codes.select do |code|
        code = code.join
        code.include?(@guess[0..1]) ||
        code.include?(@guess[1..2]) ||
        code.include?(@guess[2..3]) ||
        (code.include?(@guess[0]) && code.include?(@guess[3])) ||
        (code.include?(@guess[0]) && code.include?(@guess[2])) ||
        (code.include?(@guess[1]) && code.include?(@guess[3])) 
      end
    end

    def remove_by_pairs_misplaced
      @possible_codes = @possible_codes.select do |code|
        code = code.join
        (code.include?(@guess[2]) && code.include?(@guess[3])) ||
        (code.include?(@guess[1]) && code.include?(@guess[2])) ||
        (code.include?(@guess[0]) && code.include?(@guess[1])) ||
        (code.include?(@guess[0]) && code.include?(@guess[3])) ||
        (code.include?(@guess[0]) && code.include?(@guess[2])) ||
        (code.include?(@guess[1]) && code.include?(@guess[3])) 
      end
    end

    def update_permutations(feedback)
      remove_perms_missing_guess_nums(feedback)

      # Remove the last incorrect guess from the possible results so no repeats
      @possible_codes.delete(@guess.chars)

      @length = @possible_codes.size
      test_case = @possible_codes.include?(['4','5','5','6'])
    end

    def shuffle(feedback)
      output = @guess
      loop do
        output = @guess.shuffle
        break if output != @guess
      end
      output
    end

    def remove_perms_missing_guess_nums(feedback)
      # When last clue is x, selects perms that
      # include ALL nums in guess AT LEAST ONCE
      if feedback.join[-1] == 'x'
        @possible_codes = @possible_codes.select do |code|
          (@guess.chars - code).empty?
        end
      else
        # When True, selects perms that DO NOT include ANY nums in guess
        # When False, selects perms that include AT LEAST ONE num in guess
        feedback_result = feedback.join.include?('----')
        @possible_codes = @possible_codes.select do |code| 
          (code & @guess.chars).empty? == feedback_result
        end
      end
    end

    def first_guess
      @first = [@numbers.sample * 2, @numbers.sample * 2].join
    end

    def second_guess
      second = nil
      loop do
        second = [@numbers.sample * 2, @numbers.sample * 2].join
        no_duplicates = (second.chars & @first.chars).empty?
        break if no_duplicates
      end
      second
    end

    def third_guess
      third = nil
      loop do
        third = [@numbers.sample * 2, @numbers.sample * 2].join
        no_duplicates = (third.chars & second.chars & @first.chars).empty?
        break if no_duplicates
      end
      third
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
