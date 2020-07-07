defmodule DatosEnCache do
  def iniciar() do # F1
    # Creo un Agente: Proceso con capacidad de almacenar y recuperar 1 objeto
    # En mi caso le paso un map vacio: %{}
    {:ok, pid} =Agent.start_link(fn -> %{} end) #F2
    # Guardarme en mi proceso bajo el nombre :cache, el id del Agente(que es un proceso)
    # Establecer un alias a nivel global (Pero dentro del proceso mio)
    Process.register(pid, :cache)
    # Agente con ese identificador de proceso :cache, que
    # modifique lo que tiene guardado, a través de una funcion
    Agent.update(:cache, fn map -> Map.put(map, :hello, 1) end) #F3


    proceso1 = Task.async(fn -> iniciar2() end) # iniciar2() #F4
    Task.await(proceso1)
    proceso2 = Task.async(fn -> iniciar2() end) # iniciar2() #F5
    Task.await(proceso2)
  end
  def iniciar2() do #F6
    # Llamar al agente :cache, recupere con una función
    # Sumar 1 a :hello antes de mostrarlo por pantalla
    dato = Agent.get(:cache, fn map -> Map.get(map, :hello) end) + 1 #F7
    Agent.update(:cache, fn map -> Map.put(map, :hello, dato) end) #F8
    IO.puts(dato)
  end
end
# 8 Funciones
# Procesos: 4 procesos: Agente, principal y 2 Tasks
# F1 - principal
# F2 - Agente
# F3 - Agente
# F4 - Task 1
# F5 - Task 2
# F6 - Task 1 y Task 2
# F7 - Agente
# F8 - Agente
