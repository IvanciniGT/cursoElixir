defmodule Parallel2 do
  def pmap(collection, tarea) do
    collection
    |> Enum.map(fn item -> (Task.async(fn -> tarea.(item) end))end)
    |> Enum.map(fn task -> Task.await(task) end)
  end

  def iniciar() do
    IO.inspect( pmap(1..10000, fn numero -> numero * 2 end))
  end
end
