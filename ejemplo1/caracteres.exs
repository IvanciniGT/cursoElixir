palabra = "ÁHLEÍÓÑ"
letras = String.graphemes(palabra)

letras_a_reemplazar = String.graphemes("ÁÉÍÓÚ")
reemplazos = String.graphemes("AEIOU")
conjunto = Enum.zip(letras_a_reemplazar, reemplazos)

funcion = fn letra_para_reemplazar ->
  letra_nueva = conjunto |> Enum.filter( fn {letra, _} -> letra == letra_para_reemplazar end)
  if Enum.count(letra_nueva) != 0 do
    letra_nueva |> Enum.at(0) |> elem(1)
  else
    letra_para_reemplazar
  end
end

letras |> Enum.map(funcion) |> Enum.join() |> IO.inspect()

palabra
  |> String.replace("Á","A")
  |> String.replace("É","E")
  |> String.replace("Í","I")
  |> String.replace("Ó","O")
  |> String.replace("Ú","U")
  |> IO.inspect()
