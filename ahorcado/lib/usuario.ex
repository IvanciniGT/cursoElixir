#defmodule MiError do
#  defexception message: "Error en el usuario"
#end
# raise MiError
# raise MiError, "Error con mensaje particular"
defmodule Usuario do
  defstruct nombre: "", partidas_jugadas: 0, partidas_ganadas: 0

  defp iniciar() do
    if !(Process.registered()|> Enum.member?(:cache)) do
      {:ok, pid} = Agent.start_link(fn -> %{} end)
      Process.register(pid, :cache)
      leer_fichero_usuarios()
    end
  end

  def imprimir(usuario) do
    IO.puts("Usuario: " <> usuario.nombre)
    IO.puts("  Partidas jugadas: " <> to_string(usuario.partidas_jugadas))
    IO.puts("  Partidas ganadas: " <> to_string(usuario.partidas_ganadas))
  end


  def leer_fichero_usuarios() do
    alias File.Error, as: Err
    try do
      File.stream!("./lib/usuarios.db") |>
      Enum.map(fn lineas -> lineas|>String.split(",") end) |>
      Enum.each(fn usuario_partes -> crear_usuario_desde_enum(usuario_partes) end)
#      raise "ERROR en el fichero "
#      throw 4
    rescue
      _ in Err -> crear_fichero_usuarios()
#    catch
#        x -> IO.puts(x)
#    after
#      IO.puts("Me imprimo en cualquier caso")
#    else
#      IO.puts("Me imprimo en Despues del otro me imprimo, pero solo si no ha habido error")
    end
  end

  def escribir_fichero_usuarios() do
    usuarios=recuperar_usuarios()
    if Enum.count(usuarios)!=0 do
      # AQUI ESTABA EL OTRO BUG...
      # Lo que se recibe como primer parametro en write es el fichero y no el contenido
#      usuarios|>
#        Enum.map(fn usuario -> usuario.nombre <> "," <> to_string(usuario.partidas_jugadas) <> "," <> to_string(usuario.partidas_ganadas) end) |>
#        Enum.join("\n") |>
#        File.write("./lib/usuarios.db")
      contenido=usuarios|>
        Enum.map(fn usuario -> usuario.nombre <> "," <> to_string(usuario.partidas_jugadas) <> "," <> to_string(usuario.partidas_ganadas) end) |>
        Enum.join("\n")
        File.write("./lib/usuarios.db",contenido)

    else
      crear_fichero_usuarios()
    end
  end

  def crear_fichero_usuarios() do
    File.write("./lib/usuarios.db","")
  end


  def actualizar_estadisticas_usuario(usuario, gano) do
    actualizar_estadisticas_usuario(usuario, usuario.partidas_jugadas + 1, usuario.partidas_ganadas + (if gano, do: 1, else: 0) )
#    Map.replace!( usuario, :partidas_jugadas, usuario.partidas_jugadas + 1) |>
#    Map.replace!( :partidas_ganadas, usuario.partidas_ganadas + (if gano, do: 1, else: 0))
  end

  def actualizar_estadisticas_usuario(usuario, jugadas, ganadas) do
    usuario=Map.replace!( usuario, :partidas_jugadas, jugadas) |>
            Map.replace!( :partidas_ganadas, ganadas)
    Agent.update(:cache, fn map -> Map.put(map, usuario.nombre, usuario) end)
    escribir_fichero_usuarios()
    usuario |> tuplarizar()
  end

  def tuplarizar(nil) do
    {:nok, nil}
  end

  def tuplarizar(usuario) do
    {:ok, usuario}
  end

  def recuperar_usuario(nombre)do
    iniciar()
    Agent.get(:cache, fn map -> Map.get(map,nombre) end) |> tuplarizar()
  end

  def recuperar_usuarios() do
    iniciar()
    Agent.get(:cache, fn map -> map end) |>
    Map.values()
  end

  def crear_usuario_desde_enum(partes) do
    [nombre, jugadas, ganadas] = partes |> Enum.map(fn parte -> parte|>String.trim() end)
    crear_usuario(nombre, Integer.parse(jugadas)|> elem(0), Integer.parse(ganadas)|> elem(0))
  end

  def crear_usuario(nombre, jugadas \\ 0, ganadas \\ 0) do
    iniciar()
    {respuesta, _} = recuperar_usuario(nombre)
    if respuesta == :ok do
      {:nok, nil}
    else
      usuario=%Usuario{nombre: nombre}
      actualizar_estadisticas_usuario(usuario, jugadas, ganadas)
    end
  end

  def borrar_usuario(nombre) do
    iniciar()
    Agent.update(:cache, fn map -> Map.delete(map, nombre) end)
    escribir_fichero_usuarios()
  end

end
