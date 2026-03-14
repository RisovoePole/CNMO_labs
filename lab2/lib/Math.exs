#defmodule GaussJordan and GaussSeidel в mix проект.
defmodule Math do

  defmodule Element do
    defstruct [:row ,:column, :value]

  end

  def dominant_diagonal(matrix) when is_list(matrix) do
    result = []
    for row <- matrix do
      max = 0
      Enum.each(row,
      fn el ->
        if(abs(el)>abs(max)) do max = el end
      end)
      result = [%Element()]
    end
  end


end
