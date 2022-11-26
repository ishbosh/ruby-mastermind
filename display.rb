module DisplayText

  def show_intro
    "  --- MASTERMIND ----" \
    "\n Can you crack the code?"
  end

  def show_role_prompt
    "Do you want to be Code Breaker, or Code Maker? Type in 'Break' or 'Make':"
  end

  def show_role_error
    "Invalid input. Enter 'break' or 'make'. "
  end

  def show_name_prompt
    "Enter your name: "
  end

  def show_code_prompt
    'Choose a 4 digit code with each digit in the range 1-6: '
  end

  def show_guess_prompt
    'Guess 4 digit code with each digit in the range 1-6:  '
  end

  def show_computer_guess(guess)
    "Computer Guesses: #{guess}"
  end

  def show_invalid_error
    "\nInvalid entry. Each digit must be 1 through 6."
  end

  def show_turn_number(n)
    "- Turn Number #{n} -"
  end

  def show_feedback(feedback)
    "Guess Feedback: #{feedback.join}\n "
  end

  def show_game_over(code, breaker, maker)
    "Game over man, game over! " \
    "#{breaker} couldn't crack #{maker}'s code! It was #{code}"
  end

  def show_victory(code, breaker, maker)
    "Sweet, sweet victory! " \
    "#{breaker} successfully cracked #{maker}'s code! It was #{code}"
  end
end
