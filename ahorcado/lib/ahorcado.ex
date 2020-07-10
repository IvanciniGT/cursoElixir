defmodule Ahorcado do
  import Usuario

  @moduledoc """
  Documentation for `Ahorcado`.
  """

  def iniciar_juego() do
    mostrar_bienvenida()
    usuario = obtener_usuario()
    iniciar_partida(usuario)
  end

  def obtener_usuario() do
    nombre = IO.gets("Dame tu nombre: ") |> String.trim()
    {respuesta, usuario}=recuperar_usuario(nombre)
    if respuesta == :nok do
      {_, usuario}=crear_usuario(nombre)
      usuario
    else
      usuario
    end
  end

  def preguntar_si_otro_usuario() do
    respuesta = IO.gets("Otro usuario desea jugar? ")
    cond do
      respuesta |> String.upcase() |> String.starts_with?("S") ->
        iniciar_juego()
      ! (respuesta |> String.upcase() |> String.starts_with?("N") )->
        IO.puts("Por favor, introduzca Si o No.")
        preguntar_si_otro_usuario()
      true -> :nil
    end
  end

  def iniciar_partida(usuario) do

    # Seleccionar palabra
    palabra = seleccionar_palabra()
    palabra_normalizada = normalizar_palabra(palabra)
    # Mostrar bienvenida al juego
    mostrar_bienvenida()
    # Empezar una ronda
    jugar_ronda(usuario,palabra, enmascarar_palabra(palabra,palabra_normalizada, []),palabra_normalizada, [], 6)
  end

  def mostrar_bienvenida() do
    Enum.each(0..80, fn _ -> IO.puts("\n") end)
    IO.puts("Bienvenido al juego del:\n")
    IO.puts(" ▄▄▄       ██░ ██  ▒█████   ██▀███   ▄████▄   ▄▄▄      ▓█████▄  ▒█████")
    IO.puts("▒████▄    ▓██░ ██▒▒██▒  ██▒▓██ ▒ ██▒▒██▀ ▀█  ▒████▄    ▒██▀ ██▌▒██▒  ██▒")
    IO.puts("▒██  ▀█▄  ▒██▀▀██░▒██░  ██▒▓██ ░▄█ ▒▒▓█    ▄ ▒██  ▀█▄  ░██   █▌▒██░  ██▒")
    IO.puts("░██▄▄▄▄██ ░▓█ ░██ ▒██   ██░▒██▀▀█▄  ▒▓▓▄ ▄██▒░██▄▄▄▄██ ░▓█▄   ▌▒██   ██░")
    IO.puts(" ▓█   ▓██▒░▓█▒░██▓░ ████▓▒░░██▓ ▒██▒▒ ▓███▀ ░ ▓█   ▓██▒░▒████▓ ░ ████▓▒░")
    IO.puts(" ▒▒   ▓▒█░ ▒ ░░▒░▒░ ▒░▒░▒░ ░ ▒▓ ░▒▓░░ ░▒ ▒  ░ ▒▒   ▓▒█░ ▒▒▓  ▒ ░ ▒░▒░▒░")
    IO.puts("  ▒   ▒▒ ░ ▒ ░▒░ ░  ░ ▒ ▒░   ░▒ ░ ▒░  ░  ▒     ▒   ▒▒ ░ ░ ▒  ▒   ░ ▒ ▒░")
    IO.puts("  ░   ▒    ░  ░░ ░░ ░ ░ ▒    ░░   ░ ░          ░   ▒    ░ ░  ░ ░ ░ ░ ▒")
    IO.puts("      ░  ░ ░  ░  ░    ░ ░     ░     ░ ░            ░  ░   ░        ░ ░")
    IO.puts("                                    ░                   ░               ")

    IO.puts("Tienes que adivinar el país secreto.")
  end

  def seleccionar_palabra() do
    Enum.random(lista_palabras())
  end

  def lista_palabras() do
    File.stream!("./lib/paises.txt") |>
    Enum.map(fn palabra -> String.trim(palabra) end)
  end

  def jugar_ronda(usuario, palabra,_, _,letras, 0) do
    mostrar_pantalla(palabra, 0,letras,usuario)
    juego_finalizado(:nok, usuario)
  end

# 3- Resolver la comparacion de Strings
  def jugar_ronda(usuario, palabra, palabra_enmascarada, _,  _, _) when palabra == palabra_enmascarada do
    juego_finalizado(:ok, usuario)
  end

  def jugar_ronda(usuario, palabra, palabra_enmascarada, palabra_normalizada, letras, intentos) do
    # Mostrar pantalla
    mostrar_pantalla(palabra_enmascarada, intentos,letras,usuario)
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

  def mostrar_pantalla(palabra_enmascarada, intentos, letras, usuario) do
    Enum.each(0..80, fn _ -> IO.puts("\n") end)
    IO.puts("#{usuario.nombre}, te quedan #{intentos} intentos")
    #dibujar_ahorcado(intentos)
    lineas=cargar_imagenes_ahorcado() |> Enum.at(6-intentos)
    IO.puts(Enum.at(lineas,0))
    IO.puts(Enum.at(lineas,1))
    IO.puts(Enum.at(lineas,2) <> "   Letras utilizadas:")
    IO.puts(Enum.at(lineas,3) <> "   " <> Enum.join(letras," "))
    IO.puts(Enum.at(lineas,4) <> "    El país a adivinar es: #{palabra_enmascarada}")
    IO.puts(Enum.at(lineas,5))
    IO.puts(Enum.at(lineas,6))
    IO.puts("")
  end

  def cargar_imagenes_ahorcado() do
    File.stream!("./lib/ahorcado.txt") |> Enum.map(fn linea -> String.slice(linea,0..-2) end) |> Enum.chunk_every(7)
  end

#  def dibujar_ahorcado(intentos) do
#    cargar_imagenes_ahorcado() |> Enum.at(6-intentos) |> IO.puts()
#  end

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

  def juego_finalizado(:ok,usuario) do
    IO.puts("Has ganado")
    # Añadir estadisticas al usuario.
    # AQUI ESTABA EL BUG: Se recuperaba el usuario y no la tupla. Estou lo habiamos cambiado
    # usuario = Usuario.actualizar_estadisticas_usuario(usuario, true)
    {_, usuario} = Usuario.actualizar_estadisticas_usuario(usuario, true)
    imprimir(usuario)
    preguntar_si_jugar_de_nuevo(usuario)
  end

  def juego_finalizado(:nok,usuario) do

    IO.puts("Has perdido.")
    # Añadir estadisticas al usuario
    {_, usuario}  = actualizar_estadisticas_usuario(usuario, false)
    imprimir(usuario)
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
