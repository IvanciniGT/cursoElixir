defmodule DatosEnCache do
  def iniciar() do
    {:ok, pid} =Agent.start_link(fn -> %{} end)
    Agent.update(pid, fn map -> Map.put(map, :hello, :world) end)
    Process.register(pid, :cache)
    iniciar2()
  end
 def iniciar2() do
  dato = Agent.get(:cache, fn map -> Map.get(map, :hello) end)
  IO.puts(dato)
  end
end
