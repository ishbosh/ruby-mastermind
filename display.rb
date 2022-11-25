module DisplayText
  def show_guess_prompt(n)
    "Guess digit ##{n}:  "
  end

  def show_guess_error
    "\nInvalid guess. Must be a single digit 1 through 6."
  end

end
