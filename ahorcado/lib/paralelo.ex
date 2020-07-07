defmodule Paralelo do

  def iniciar() do
    numeros = 1..2000000
    veces = 1..20

    tareas = veces |>
      Enum.map( fn _-> Task.async(fn -> calcular_cubos(numeros) end) end)
    IO.puts("Hola")
    tareas|> Enum.each(fn tarea-> Task.await(tarea,60000) end)
    IO.puts("Adios")
  end
  # 3 hilos
  # Operaciones 20 procesos---> 2.000.000 secuencial
  # P1  -> O1(done) O2(done) O3
  # P2  -> O1
  #....
  # P20 -> O1
  # En un momento Ti vamos a tener 20 operaciones a realizar en "paralelo": 1 de cada proceso
  #      O_1_10 O_2_5 O_3_14... O_20_34
  # Elixir: 3 hilos que se van a encargar de ir haciendo esas 20 operaciones
  #         Baja latencia: Procedimientos tiempo compartido (10ms) por operacion
  # Hilo1: O_1_10 (10ms) O_2_5 (10ms) ... O_1_10 (10ms)
  # Lo más eficiente como T TOTAL es hacer las tareas secuencialmente en cada hilo
  # Lo más eficiente para MINIMIZAR el T de CADA operacion es darle un tiempo a cada una

  def calcular_cubos(secuencia) do
    secuencia |>  Enum.map( fn numero -> cubo( numero ) end)|>
    IO.inspect
  end

  def cubo(numero) do
    numero * numero * numero
  end

  def saludar() do
    # spawn FUNCION como un proceso aparte. Devuelve el ID del proceso
    info_ivan = Task.async(fn -> saludar(:ivan, 1000) end)
    info_elias = Task.async(fn -> saludar(:elias, 1500) end)
    Task.await(info_ivan,20000)
    Task.await(info_elias,20000)

    saludar(:jhon, 500)
  end

  def saludar(nombre,siesta) do
    1..10 |> Enum.each(fn _ -> IO.puts("Soy #{nombre}, Hola!"); Process.sleep(siesta) end)

  end
end
