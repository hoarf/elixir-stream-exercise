defmodule Cache do
  use GenServer

  # Client API
  def start_link(), do: GenServer.start_link(__MODULE__, [])
  def save(pid, bounding_box), do: GenServer.call(pid, {:save, bounding_box})
  def find(pid, coordinate), do: GenServer.call(pid, {:find, coordinate})

  # Server
  def init(_args), do: {:ok, []}

  def handle_call({:save, bounding_box}, _from, state) when is_list(state),
    do: {:reply, :ok, [bounding_box | state]}

  def handle_call({:find, coordinate}, _from, state) when is_list(state) do
    {:reply, BoundingBox.find(state, coordinate), state}
  end
end
