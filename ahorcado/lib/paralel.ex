defmodule Parallel do
  def pmap(collection, tarea) do
    collection
    |> Enum.map(fn item -> (Task.async(fn -> tarea.(item) end))end)
    |> Enum.map(fn task -> Task.await(task) end)
  end

  def iniciar() do
#    IO.inspect( Enum.map(1..1000000, fn numero -> numero * numero * numero end))
    IO.inspect( pmap(1..1000000, fn numero -> numero * numero * numero end))
  end
end
#Parallel.iniciar()
