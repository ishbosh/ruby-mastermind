module DisplayText

  def show_intro
    "  --- MASTERMIND ----" \
    " Can you crack the code?"
  end

  def show_role_prompt
    "Do you want to be Code Breaker, or Code Maker? Type in 'Break' or 'Make'."
  end

  def show_role_error
    "Invalid input. Enter 'break' or 'make'. "
  end

  def show_guess_prompt
    'Guess 4 digit code with each digit in the range 1-6:  '
  end

  def show_guess_error
    "\nInvalid guess. Each digit must be 1 through 6."
  end

  def show_guess_number(n)
    "- Guess Number #{n} -"
  end

  def show_feedback(feedback)
    "#{feedback.join}"
  end

  def show_game_over(code)
    "Game over man, game over! You couldn't crack the code! It was: #{code}"
  end

  def show_victory(code, breaker)
    "#{breaker} successfully cracked the code! It was: #{code}"
  end
end
