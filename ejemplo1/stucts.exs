
defmodule Usuario do
  defstruct nombre: "", partidas_jugadas: 0, partidas_ganadas: 0
end

ivan = %Usuario{nombre: "Ivan"}
jhon = %Usuario{nombre: "Jhon"}

ivan |> IO.inspect()
