defmodule Sequence do
  @moduledoc """
  Documentation for `Sequence`.
  """

  def start(_type, _args) do
    {:ok, _pid} = Sequence.Supervisor.start_link(123)
  end
end
