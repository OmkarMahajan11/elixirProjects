defmodule MyList do
  def len([]), do: 0
  def len([_head|tail]), do: 1 + len(tail)

  def square([]), do: []
  def square([head|tail]), do: [head*head | square(tail)]

  def add1([]), do: []
  def add1([head|tail]), do: [head+1 | add1(tail)]

  def reverse([]), do: []
  def reverse([head|tail]), do: reverse(tail) ++ [head]

  def map([], _func), do: []
  def map([head | tail], func), do: [func.(head) | map(tail, func)]

  def sum(l), do: _sum(l, 0)
  defp _sum([], total), do: total
  defp _sum([head | tail], total), do: _sum(tail, head + total)

  def reduce([], value, _), do: value
  def reduce([head|tail], value, fun), do: reduce(tail, fun.(head, value), fun)

  def mapsum(l, fun), do: map(l, fun) |> reduce(0, &(&1 + &2))

  def max(l), do: _max(l, -1)
  defp _max([], max_t), do: max_t
  defp _max([head|tail], max_t) when head > max_t, do: _max(tail, head)
  defp _max([_head|tail], max_t), do: _max(tail, max_t)

  def caesar(s, n) do
    map(s, &rem(&1+n, 26))
  end

  def swap([]), do: []
  def swap([a, b | tail]), do: [b, a | swap(tail)]
  def swap([_]), do: raise "Can't swap a list with an odd number of elements"

  def span(from, to) when to < from, do: []
  def span(from, to), do: [from | span(from+1, to)]

  def all?([], _fun), do: true
  def all?([head | tail], fun), do: fun.(head) and all?(tail, fun)

  def each([], _fun), do: []
  def each([head | tail], fun), do: [fun.(head) | each(tail, fun)]

  def filter([], _fun), do: []
  def filter([head | tail], fun) do
    if fun.(head) do
      [head | filter(tail, fun)]
    else
      filter(tail, fun)
    end
  end

  def take(_l, 0), do: []
  def take([], _n), do: []
  def take([head | tail], n), do: [head | take(tail, n-1)]

  def split([], _n), do: []
  def split(l, 0), do: l
  def split(l, n) do
    a = take(l, n)
    [a | split(l -- a, n)]
  end
end

defmodule WeatherHistory do
  def for_location_27([]), do: []
  def for_location_27([[time, 27, temp, rain] | tail]), do: [[time, 27, temp, rain] | for_location_27(tail)]
  def for_location_27([_ | tail]), do: for_location_27(tail)

  def for_location([], _target_loc), do: []
  def for_location([head = [_, target_loc, _, _] | tail], target_loc), do: [head | for_location(tail, target_loc)]
  def for_location_27([_ | tail], target_loc), do: for_location(tail, target_loc)
end
