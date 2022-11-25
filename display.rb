module DisplayText
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
    "Game over man, game over! You couldn't crack the code! It was #{code}"
  end

  def show_victory(code)
    "You did it! The code was: #{code}"
  end


end
