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

  def diagonal_dominant?(dominant_elements)
  when is_list(dominant_elements) do
    # initial indexes of rows in order, that dominant diagnol is possible
    result = []

    by_columns = dominant_elements|> Enum.group_by(& &1.col)
    by_rows = dominant_elements |> Enum.group_by(& &1.row)

    result = by_columns
    |> Enum.reduce([], fn {_col, list}, acc ->
      cond do
        Enum.empty?(list) -> acc
        len(list)==1 -> [Enum.at(list,0).row | acc]

        true ->
          els_in_rows = list
          |> Enum.map(fn %Element{row: r, col: c, val: v} ->
            len(by_rows[r])
          end)

          single_el_row_idx = Enum.find_index(els_in_rows, fn len -> len == 1 end)



          case single_el_row_idx do
            nil ->
              nil #логика...
            num ->
              [el] = by_rows[single_el_row_idx]

              [el|acc]
          end
        end
      end )





      def try(col, graph, match_row, visited) do
        Enum.find_value(graph[col], fn row ->
          if MapSet.member?(visited, row) do
            false
          else
            visited = MapSet.put(visited, row)

            case match_row[row] do
              nil ->
                {:ok, Map.put(match_row, row, col)}

              other_col ->
                case try(other_col, graph, match_row, visited) do
                  {:ok, new_match} ->
                    {:ok, Map.put(new_match, row, col)}

                  _ ->
                    false
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
end
