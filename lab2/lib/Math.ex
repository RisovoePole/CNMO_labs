#defmodule GaussJordan and GaussSeidel в mix проект.
defmodule Math do

  defmodule Matrix do
    defstruct rows: 0,
              columns: 0,
              data: []
  end

  defmodule Element do
    defstruct row: 0,
              col: 0,
              val: 0
  end


  def get_max_elements_for_each_row(matrix = %Matrix{data: data}) do
    data
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, r} ->
      # ищем максимум по модулю и его индекс
      {max_val, _idx} =
        row
        |> Enum.with_index()
        |> Enum.max_by(fn {v, _c} -> abs(v) end)

      # ищем все элементы с таким же val
      row
      |> Enum.with_index()
      |> Enum.filter(fn {v, _c} -> abs(v) == abs(max_val) end)
      |> Enum.map(fn {v, c} ->
        %Element{row: r, col: c, val: v}
      end)
    end)
  end

  def elements_dominant?(max_elements, matrix = %Matrix{data: data}) when is_list(max_elements) do

    row_abs_sums = data
    |> Enum.map(fn row ->
      row
      |> Enum.reduce(0, fn v,acc ->
        acc+abs(v)
      end)
    end)


    max_by_row = Enum.group_by(max_elements, & &1.row)

    Enum.with_index(row_abs_sums)
    |> Enum.all?(fn {row_sum, r} ->
        case Map.get(max_by_row, r, []) do
          [] -> true
          elems ->
            el = Enum.at(elems, 0)
            el.val >= row_sum - el.val
        end
      end)
  end

  @spec diagonal_dominant?(list(%Element{})) :: %{row::integer() => col::integer()} | false
  def diagonal_dominant?(dominant_elements)
  when is_list(dominant_elements) do

    graph =
      dominant_elements
      |> Enum.group_by(& &1.col)
      |> Enum.map(fn {c, els} ->
        {c, Enum.map(els, & &1.row)}
      end)
      |> Map.new()


    match_row = %{}
    Enum.reduce_while(Map.keys(graph), match_row, fn col, match ->
      case try_assign(col, graph, match, MapSet.new()) do
        {:ok, new_match} ->
          {:cont, new_match}
        :fail ->
          {:halt, false}
      end
    end)
  end





  defp try_assign(col, graph, match_row, visited) do
  Enum.reduce_while(graph[col], :fail, fn row, _ ->
    if MapSet.member?(visited, row) do
      {:cont, :fail}
    else
      visited = MapSet.put(visited, row)

      case Map.get(match_row, row) do
        nil ->
          {:halt, {:ok, Map.put(match_row, row, col)}}

        other_col ->
          case try_assign(other_col, graph, match_row, visited) do
            {:ok, new_match} ->
              {:halt, {:ok, Map.put(new_match, row, col)}}

            :fail ->
              {:cont, :fail}
          end
      end
    end
  end)
end

end



#после того, как будут мы поймём - может ли доминантные элементы состовлять диагональ, делим все остальные элементы строки на эл этой же строки, состовляющий диагональ.
#получаем уравнения вида xi = (-ai1/aii)*x1 ... (-ain/aii)xn + bi/aii
#максимум домингирующих элементов 2 т.к. иначе он нне >= чем сумма всех элементов по модулю
#
#
#
#
