module DisplayText
  def show_guess_prompt(n)
    "Guess digit ##{n}:  "
  end

  def show_guess_error
    "\nInvalid guess. Must be a single digit 1 through 6."
  end

  def show_feedback(feedback)
    "#{feedback.join}"
  end

  def show_game_over
    "Game over man, game over! You couldn't crack the code!"
  end

  def show_victory(code)
    "You did it! The code was: #{code}"
  end

end
