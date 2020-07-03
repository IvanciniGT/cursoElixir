IO.puts("Hola mundo") # Comentario
# Comentarios

# Variables
numero = 5
numero = 7
decimal = 7.2
logico = true # false

texto1="hola!"
texto2='hola!'

# atom
miatom=:hola
IO.puts(miatom)

:true
:false
:nil

mitupla = {1,2,3} # tupla
milista = [1,2,3] # list
# IMPERATIVA
  # Dar ordenes secuenciales
# FUNCION o PROCEDIMIENTO: PROCEDURAL
  # crearFunciones
# PARADIGMA FUNCIONAL
  # funcion -> variable
# OOP
  # Crearme mis propios tipos de variables, con funciones propias

mifuncion = fn argumento1, argumento2 -> argumento1 + argumento2 end
# mifuncion = lambda arg1,arg2: arg1+arg2

IO.puts(mifuncion.(1,3))

# Operadores: +, -, *, /, div(ar1,ar2), rem(ar1,ar2)
#             <> Concatenar
#      a || b  or excluyente
#      a && b  and
#      true  ambos sean true
#      falso: a sea falso o los dos sean falsos
#      ! not
# == >= <= < >  !=  ===

#  Asignación: = En elixir no
#  = -> Match... conclusiones o errores
x = 4 #=> x=4
4 = x #=> x=4

y = 2  #=> y=2
y = 3  #=> y=3
3 = y  #=> nada, todo ok (en este momento y=3)
#4 = y  #=> error => conclusion y=4, pero y=3... error!!!!!!!

{x, y, 2} = { 1, 2, 2}
# Conclusion: x=1, y=2, 2=2
"hola " <> texto = "hola Elias"
# Conclusion texto = "Elias"

n = 1
z = 2
n = z

# Pin
#^n = 3  # error, no hay cabida para esto
n = 3 # Conclusion de que n vale 3
IO.puts(n)


#_ = 3

#[1, 2, x] = [_,_, 5]



#funciones en linea (ANONIMA)
# funciones normales -> Modulo
defmodule MiLibreria do
  def funcion1(arg1, arg2) do
    #arg1 - arg2
    arg1 + arg2
  end

  def maximo(n1,n2) do
    if n1 >n2 do # unless
      n1
    else
      n2
    end
  end

  def maximode3(n1,n2,n3) do
    #maximo(n1,maximo(n2,n3))
    maximo(n1,n2) |> maximo(n3)
  end

#  def factorial(n) do
#    if n>1 do
#      n*factorial(n-1)
#    else
#      1
#    end
#  end

  def factorial(n) when n==1 do # guard
    1
  end

  def factorial(n) do
    n*factorial(n-1)
  end




  def fizzbuzz(n) when rem(n,5)==0 and rem(n,3)==0 do
    "fizzbuzz"
  end

  def fizzbuzz(n) when rem(n,5)==0 do
    "buzz"
  end

  def fizzbuzz(n) when rem(n,3)==0 do
    "fizz"
  end

  def fizzbuzz(n)  do
    n
  end

  def superfizzbuzz(n) when n==1 do
    IO.puts(fizzbuzz(n))
  end

  def superfizzbuzz(n) when n>1 do
    IO.puts(fizzbuzz(n))
    superfizzbuzz(n-1)
  end
end

IO.puts(MiLibreria.funcion1(1,2))
IO.puts(MiLibreria.maximo(7,2))
IO.puts(MiLibreria.maximode3(7,21,14))
IO.puts(MiLibreria.factorial(5))

# 5! = 5*4*3*2*1
# 5! = 5 * 4!

IO.puts(MiLibreria.fizzbuzz(30))
# Todos los numeros de 1 al 100

##FizzBuzz
# numero // 3 Fizz
# numero // 5 Buzz
# numero /3 y 5 FizzBuzz
# en caso contrario numero


# Modelo programación MAP-REDUCE
#Colleccion C : Map -> Ci=> f(Ci)
#Reduce: Ci, Ci+1=> J

#range(1,100)

# 1..100

fb = fn(n)-> IO.puts(MiLibreria.fizzbuzz(n)) end
#IO.puts(Enum.map(1..100,fb))
Enum.each(1..100,fb)


x = 1

3 = x

IO.puts(x)
