
defmodule Usuario do
  defstruct nombre: "", partidas_jugadas: 0, partidas_ganadas: 0

  def iniciar() do
    {:ok, pid} = Agent.start_link(fn -> %{} end)
    Process.register(pid, :cache)
  end

  def actualizar_estadisticas_usuario(usuario, gano) do
    Map.replace!( usuario, :partidas_jugadas, usuario.partidas_jugadas + 1) |>
    Map.replace!( :partidas_ganadas, usuario.partidas_ganadas + (if gano, do: 1, else: 0))
  end

  def tuplarizar(nil) do
    {:nok, nil}
  end

  def tuplarizar(usuario) do
    {:ok, usuario}
  end

  def recuperar_usuario(nombre)do
    Agent.get(:cache, fn map -> Map.get(map,nombre) end) |> tuplarizar()
  end

  def recuperar_usuarios() do
    Agent.get(:cache, fn map -> map end) |>
    Map.values()
  end

  def crear_usuario(nombre) do
    {respuesta, _} = recuperar_usuario(nombre)
    if respuesta == :ok do
      {:nok, nil}
    else
      usuario=%Usuario{nombre: nombre}
      Agent.update(:cache, fn map -> Map.put(map, nombre, usuario) end)
      usuario  |> tuplarizar()
    end
  end

  def borrar_usuario(nombre) do
    Agent.update(:cache, fn map -> Map.delete(map, nombre) end)
  end

end
