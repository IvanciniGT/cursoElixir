
defmodule Usuario do
  defstruct nombre: "", partidas_jugadas: 0, partidas_ganadas: 0

  def actualizar_estadisticas_usuario(usuario, gano) do
    Map.replace!( usuario, :partidas_jugadas, usuario.partidas_jugadas + 1) |>
    Map.replace!( :partidas_ganadas, usuario.partidas_ganadas + (if gano, do: 1, else: 0))
  end

end
