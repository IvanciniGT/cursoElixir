
# Fase 1: Hacemos el juego, sin los dibujitos
# Palabra fija -> Sacarla random de una lista fija -> Sacarla random de un fichero

# Fase 2: Hacer el dibujo

defmodule Usuario do
  defstruct nombre: "", partidas_jugadas: 0, partidas_ganadas: 0
end

defmodule Ahorcado do
  @moduledoc """
  Documentation for `Ahorcado`.
  """

  def iniciar_juego() do
    usuario = obtener_usuario()
    iniciar_partida(usuario)
  end

  def obtener_usuario() do
    nombre = IO.gets("Dame tu nombre: ") |> String.trim()
    %Usuario{nombre: nombre}
  end

  def preguntar_si_otro_usuario() do
    respuesta = IO.gets("Otro usuario desea jugar? ")
    cond do
      respuesta |> String.upcase() |> String.starts_with?("S") ->
        iniciar_juego()
      ! (respuesta |> String.upcase() |> String.starts_with?("N") )->
        IO.puts("Por favor, introduzca Si o No.")
        preguntar_si_otro_usuario()
    end
  end

  def actualizar_estadisticas_usuario(usuario, gano) do
    Map.replace!( usuario, :partidas_jugadas, usuario.partidas_jugadas + 1) |>
    Map.replace!( :partidas_ganadas, usuario.partidas_ganadas + (if gano, do: 1, else: 0))
  end

  def iniciar_partida(usuario) do

    # Seleccionar palabra
    palabra = seleccionar_palabra()
    palabra_normalizada = normalizar_palabra(palabra);
    # Mostrar bienvenida al juego
    mostrar_bienvenida()
    # Empezar una ronda
    jugar_ronda(usuario,palabra, enmascarar_palabra(palabra,palabra_normalizada, []),palabra_normalizada, [], 6)
  end

  def mostrar_bienvenida() do
    IO.puts("Bienvenido al juego del Ahorcado.")
    IO.puts(" Tienes que adivinar la palabra secreta.")
  end

  def seleccionar_palabra() do
    Enum.random(lista_palabras())
  end

  def lista_palabras() do
    ["murcielagó","león","tigré"]
  end

  def jugar_ronda(usuario , palabra,_ , _ , _, 0) do
    juego_finalizado(:nok, palabra, usuario)
  end

# 3- Resolver la comparacion de Strings
  def jugar_ronda(usuario, palabra, palabra_enmascarada, _,  _, _) when palabra == palabra_enmascarada do
    juego_finalizado(:ok, palabra, usuario)
  end

  def jugar_ronda(usuario, palabra, palabra_enmascarada, palabra_normalizada, letras, intentos) do
    # Mostrar pantalla
    mostrar_pantalla(palabra_enmascarada, intentos)
    # Pedir letra
    letra_actual=pedir_letra(letras)
    letras = letras ++ [letra_actual]
    # Ver si la tengo?
    if String.contains?(palabra_normalizada,letra_actual) do
      # Si-> enmascaro y Otra ronda
      jugar_ronda(usuario, palabra, enmascarar_palabra(palabra, palabra_normalizada, letras), palabra_normalizada, letras , intentos)
    else
      # No -> Otra ronda intentos -1
      jugar_ronda(usuario, palabra, palabra_enmascarada, palabra_normalizada, letras , (intentos - 1) )
    end
  end

  def mostrar_pantalla(palabra_enmascarada, intentos) do
    IO.puts("Le quedan #{intentos} intentos")
    IO.puts("La palabra a adivinar es: #{palabra_enmascarada}")
  end

  def pedir_letra(letras) do
    letra = IO.gets("Dame una letra: ") |> String.trim()
    letra = normalizar_palabra(letra)
    {respuesta, mensaje} = validar_letra(letra,letras)
    if respuesta == :ok do
      letra
    else
      IO.puts(mensaje)
      pedir_letra(letras)
    end
  end

  def validar_letra(letra,letras) do
    cond do
      String.length(letra) != 1 -> {:ko, "Solo puedes introducir una letra."}
      Enum.member?(letras, letra) -> {:ko, "Esa letra ya la has usado."}
      Regex.match?(~r/[A-ZÑ]/, letra) -> {:ok, :nil}
      true -> {:ko, "Solo puedes introducir letras"}
    end
  end

  def enmascarar_palabra(palabra, palabra_normalizada, letras) do
    # 3 palabras:
      # original:     Murciélago
      # nornmalizada: MURCIELAGO
      # enmascarada:  M____é__g_
      # letras:       [M, E, G]
      # Iterando MAP original y normalizada
      # ZIP

    letras_originales_y_normalizadas = Enum.zip(String.graphemes(palabra), String.graphemes(palabra_normalizada))
    enmascarar_letra = fn {letra_original, letra_normalizada} -> if letra_normalizada==" " or Enum.member?(letras, letra_normalizada), do: letra_original, else: "_" end
    Enum.map(letras_originales_y_normalizadas, enmascarar_letra) |> Enum.join()
  end

  # Quitar acentos, quedarnos con mayusculas o minusculas
  def normalizar_palabra(palabra) do

    conjunto = Enum.zip(String.graphemes("ÁÉÍÓÚ"), String.graphemes("AEIOU"))

    funcion = fn letra_para_reemplazar ->
      letra_nueva = conjunto |> Enum.filter( fn {letra, _} -> letra == letra_para_reemplazar end)
      if Enum.count(letra_nueva) != 0 do
        letra_nueva |> Enum.at(0) |> elem(1)
      else
        letra_para_reemplazar
      end
    end

    palabra |>  String.upcase() |> String.graphemes() |> Enum.map(funcion) |> Enum.join()

  end

  def juego_finalizado(:ok,_,usuario) do
    IO.puts("Has ganado")
    # Añadir estadisticas al usuario
    usuario = actualizar_estadisticas_usuario(usuario, true)
    preguntar_si_jugar_de_nuevo(usuario)
  end
  def juego_finalizado(:nok, palabra,usuario) do
    IO.puts("Has perdido. La palabra era: #{palabra}")
    # Añadir estadisticas al usuario
    usuario = actualizar_estadisticas_usuario(usuario, false)
    preguntar_si_jugar_de_nuevo(usuario)
  end

  def preguntar_si_jugar_de_nuevo(usuario) do
    respuesta = IO.gets("Desea jugar de nuevo? ")
    cond do
      respuesta |> String.upcase() |> String.starts_with?("S") ->
        iniciar_partida(usuario)
      ! (respuesta |> String.upcase() |> String.starts_with?("N") )->
        IO.puts("Por favor, introduzca Si o No.")
        preguntar_si_jugar_de_nuevo(usuario)
      true ->
        preguntar_si_otro_usuario()
    end

  end

end

#Ahorcado.iniciar_juego()
