defmodule Stack.Server do
  use GenServer

  def start_link(stack), do:
    GenServer.start_link(__MODULE__, stack, name: __MODULE__)

  def pop(), do:
    GenServer.call __MODULE__, :pop

  def push(elem), do:
    GenServer.cast __MODULE__, {:push, elem}

  def init(init_arg), do:
    {:ok, init_arg}

  def handle_call(:pop, _from, []), do:
    {:reply, {:error, "stack empty"}, []}

  def handle_call(:pop, _from, [h|t]), do:
    {:reply, h, t}

  def handle_cast({:push, elem}, stack), do:
    {:noreply, [elem|stack]}
end
