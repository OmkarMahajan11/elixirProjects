defmodule Stack do
  @moduledoc """
  Documentation for `Stack`.
  """

  def start(_type, _args) do
    {:ok, _pid} = Stack.Supervisor.start_link([5, "cat", 9.9])
  end
end
