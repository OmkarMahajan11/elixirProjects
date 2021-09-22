defmodule GuessingGame do

  # guess between a low number and high number -> guess middle number
  # "yes" -> game over
  # "bigger" -> bigger(low, high)
  # "smaller" -> smaller(low, high)
  # anything else -> ask for a valid response

  def guess(a, b) when a > b, do: guess(b, a)

  def guess(low, high) do
    ans = IO.gets "Is it #{mid(low, high)}?\n"

    case String.trim(ans) do
      "bigger" -> bigger(low, high)
      "smaller" -> smaller(low, high)
      "yes" -> "Cool!"
      _ ->
        IO.puts ~s{Type "bigger", "smaller" or "yes"}
        guess(low, high)
    end
  end

  def mid(low, high) do
    low + div(high-low, 2)
  end

  def bigger(low, high) do
    new_low = min(high, mid(low, high) + 1)
    guess(new_low, high)
  end

  def smaller(low, high) do
    new_high = max(low, mid(low, high) - 1)
    guess(low, new_high)
  end
end
