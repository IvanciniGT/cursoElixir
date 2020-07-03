#texto = "Hola yo soy Iván"

texto_capturado = IO.gets("Dame un texto: ")
texto = String.trim(texto_capturado)
IO.puts(texto)
IO.puts(String.length(texto))
IO.puts(String.capitalize(texto))
IO.puts(String.upcase(texto))
IO.puts(String.downcase(texto))
IO.puts(String.starts_with?(texto,"Hola"))
IO.puts(String.at(texto,3))
IO.puts(String.ends_with?(texto,"Hola"))
IO.puts(String.contains?(texto,"soy"))
IO.puts(String.graphemes(texto))
IO.puts(String.split(texto, " "))

impresora = fn texto -> IO.puts("-" <> texto <> "-") end

Enum.each(String.graphemes(texto), impresora )
