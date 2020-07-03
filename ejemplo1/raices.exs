# raices.exs

defmodule Raices do
  def solve(_, a, b, tolerancia) when b-a < tolerancia do
    (a+b)/2
  end
  def solve(f, a, b, tolerancia) do
    fa = f.(a)
    fb = f.(b)
    m = (a+b)/2
    fm = f.(m)
    cond do
      fa == 0 ->
        a
      fb == 0 ->
        b
      fm == 0 ->
        m
      fa * fm < 0 ->
        solve(f, a, m, tolerancia)
      fm * fb < 0 ->
        solve(f, m, b, tolerancia)
      true ->
        nil
    end
  end
end

funcion = fn x -> (2 * x * x - 3 * x - 5) end
raiz = Raices.solve(funcion,10 ,11, 0.00001)
if raiz == nil do
  IO.puts("No puedo garantizar que exista una raiz en ese intervalo")
else
  IO.puts("La raiz vale #{raiz}")
end
