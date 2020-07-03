# integral.exs

defmodule Integral do

  def area_trapecio(a,b,fa,fb) do
    base = b - a
    altura_media = ( fa + fb )/2
    base * altura_media
  end

  def solve(f, a, b, _, 0) do
    area_trapecio(a, b, f.(a), f.(b))
  end

  def solve(f, a, b, tolerancia, iteraciones) do
    fa = f.(a)
    fb = f.(b)
    m = (a+b)/2
    fm = f.(m)

    area_t1 = area_trapecio(a, m, fa, fm)
    area_t2 = area_trapecio(m, b, fm, fb)
    area_tt = area_trapecio(a, b, fa, fb)

    diferencia_areas = abs( area_tt - area_t1 - area_t2 )
    if diferencia_areas < tolerancia do
      area_t1 + area_t2
    else
      solve(f, a, m, tolerancia, iteraciones - 1) + solve(f, m, b, tolerancia, iteraciones - 1)
    end
  end
end

funcion = fn x -> (2 * x * x - 3 * x - 5) end
raiz = Integral.solve(funcion,0 ,5, 0.00001, 2)
IO.puts("La raiz vale #{raiz}")
