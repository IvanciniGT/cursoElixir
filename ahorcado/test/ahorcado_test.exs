defmodule AhorcadoTest do
  use ExUnit.Case
  doctest Ahorcado

  test "enmascarar_palabra_1" do
    assert Ahorcado.enmascarar_palabra("holamundo", "holamundo", ["a", "m", "u"]) == "___amu___"
  end
  test "enmascarar_palabra_2" do
    assert Ahorcado.enmascarar_palabra("holámundo", "holamundo", ["a", "m", "u"]) == "___ámu___"
  end
  test "enmascarar_palabra_3" do
    assert Ahorcado.enmascarar_palabra("holAmundo", "holamundo", ["a", "m", "u"]) == "___Amu___"
  end
  test "enmascarar_palabra_4" do
    assert Ahorcado.enmascarar_palabra("holAmundo", "holamundo", []) == "_________"
  end
  # Metodologia TDD

  test "enmascarar_palabra_5" do
    assert Ahorcado.enmascarar_palabra("holA mundo", "hola mundo", ["o"]) == "_o__ ____o"
  end

  test "actualizar_estadisticas_usuario_1" do
    usuario = %Usuario{nombre: "Ivan"}
    assert usuario.partidas_jugadas == 0
    assert usuario.partidas_ganadas == 0

    usuario = Ahorcado.actualizar_estadisticas_usuario(usuario,true)
    assert usuario.partidas_jugadas == 1
    assert usuario.partidas_ganadas == 1

    usuario = Ahorcado.actualizar_estadisticas_usuario(usuario,false)
    assert usuario.partidas_jugadas == 2
    assert usuario.partidas_ganadas == 1
  end

  test "lista_palabras" do
    listado=Ahorcado.lista_palabras()
    assert Enum.count(listado) > 0
    Enum.each(listado, fn palabra -> assert is_binary(palabra) end)
    Enum.each(listado, fn palabra -> assert String.trim(palabra) == palabra end)
  end

  test "elegir_palabra_azar" do
    palabra=Ahorcado.seleccionar_palabra()
    assert Enum.member?(Ahorcado.lista_palabras(),palabra)
    assert palabra in Ahorcado.lista_palabras()
  end


end
