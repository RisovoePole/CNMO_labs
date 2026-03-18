# defmodule GaussJordan and GaussSeidel в mix проект.
defmodule Math do
  alias Matrix
  alias Element

  @spec has_absolute_diagonal?(matix :: %Matrix{}) ::
          {:ok, absolute_els :: list(%Element{})} | {:fail, reason :: bitstring()}
  def has_absolute_diagonal?(matrix = %Matrix{}) do
    # row_abs_sums = [..absolute_sums_for_each_row]
    row_abs_sums =
      matrix.data
      |> Enum.map(fn row ->
        row
        |> Enum.reduce(0, fn v, acc ->
          acc + abs(v)
        end)
      end)

    # absolute_els =  [..%Element{}] | {:fail, reason}
    absolute_els =
      Enum.with_index(matrix.data)
      |> Enum.reduce_while([], fn {row, row_idx}, acc ->
        {max, max_idx} =
          Enum.with_index(row)
          |> Enum.max_by(fn {val, _idx} -> abs(val) end)

        case abs(max) > Enum.at(row_abs_sums, row_idx) - abs(max) do
          true -> {:cont, [%Element{val: max, col: max_idx, row: row_idx} | acc]}
          false -> {:halt, {:fail, row_idx}}
        end
      end)

    case absolute_els do
      {:fail, row_idx} ->
        {:fail, "Failed at row_idx = #{row_idx}. This row doesn't contains an absolute element"}

      list ->
        cols_set =
          list
          |> MapSet.new(fn %Element{col: c} -> c end)

        if matrix.columns == MapSet.size(cols_set) do
          {:ok, list}
        else
          {:fail, "Can't create main diagonal from absolute elements"}
        end
    end
  end

  @spec jacobi_method(matrix :: %Matrix{}, absolute_els :: list(%Element{}), epsilon :: number()) ::
          %{results: [number()], iterations: integer()}
  def jacobi_method(matrix = %Matrix{}, absolute_els, epsilon)
      when is_list(absolute_els) and is_number(epsilon) and epsilon > 0 do
    # init_values = List.duplicate(0, matrix.columns)
    init_values =
      Enum.with_index(matrix.results)
      |> Enum.map(fn {b_val, b_idx} ->
        b_val /
          Enum.find_value(absolute_els, fn %Element{col: c, val: v} -> if b_idx == c, do: v end)
      end)

    do_jacobi_iteration(init_values, matrix, absolute_els, epsilon, 0)
  end

  defp do_jacobi_iteration(
         current_values,
         matrix = %Matrix{},
         absolute_els,
         epsilon,
         iteration_num
       ) do
    rigth_side =
      Enum.with_index(matrix.data)
      |> Enum.map(fn {row, r_idx} ->
        Enum.with_index(row)
        |> Enum.reduce(Enum.at(matrix.results, r_idx), fn {el, col_idx}, acc ->
          if col_idx != r_idx,
            do: acc - el * Enum.at(current_values, col_idx),
            else: acc
        end)
      end)

    next_values =
      Enum.with_index(rigth_side)
      |> Enum.map(fn {right_val, r_idx} ->
        left_val =
          Enum.find_value(absolute_els, fn %Element{col: c, val: v} -> if c == r_idx, do: v end)

        right_val / left_val
      end)

    max_diff =
      Enum.with_index(next_values)
      |> Enum.map(fn {el, el_idx} ->
        abs(el - Enum.at(current_values, el_idx))
      end)
      |> Enum.max()

    cond do
      max_diff <= epsilon -> %{results: next_values, iterations: iteration_num}
      true -> do_jacobi_iteration(next_values, matrix, absolute_els, epsilon, iteration_num + 1)
    end
  end

  def gauss_seidel_method(matrix = %Matrix{}, absolute_els, epsilon)
      when is_list(absolute_els) and is_number(epsilon) and epsilon > 0 do
    init_values =
      Enum.with_index(matrix.results)
      |> Enum.map(fn {b_val, b_idx} ->
        b_val /
          Enum.find_value(
            absolute_els,
            fn %Element{col: c, val: v} ->
              if b_idx == c, do: v
            end
          )
      end)

    do_gauss_seidel_iteration(init_values, matrix, absolute_els, epsilon, 0)
  end

  defp do_gauss_seidel_iteration(
         current_values,
         matrix = %Matrix{},
         absolute_els,
         epsilon,
         iteration_num
       ) do
    next_values =
      Enum.with_index(matrix.data)
      |> Enum.reduce(current_values, fn {row, r_idx}, acc_values ->
        right_val =
          Enum.with_index(row)
          |> Enum.reduce(Enum.at(matrix.results, r_idx), fn {el, col_idx}, acc ->
            if col_idx != r_idx,
              do: acc - el * Enum.at(acc_values, col_idx),
              else: acc
          end)

        left_val =
          Enum.find_value(absolute_els, fn %Element{col: c, val: v} ->
            if c == r_idx, do: v
          end)

        current_x = right_val / left_val

        List.update_at(acc_values, r_idx, fn _ -> current_x end)
      end)

    max_diff =
      Enum.with_index(next_values)
      |> Enum.map(fn {el, el_idx} ->
        abs(el - Enum.at(current_values, el_idx))
      end)
      |> Enum.max()

    cond do
      max_diff <= epsilon ->
        %{results: next_values, iterations: iteration_num}

      true ->
        do_gauss_seidel_iteration(next_values, matrix, absolute_els, epsilon, iteration_num + 1)
    end
  end

  def arrange_matrix(matrix = %Matrix{}, absolute_els) when is_list(absolute_els) do
    new_matrix = %Matrix{
      rows: matrix.rows,
      columns: matrix.columns,
      data: List.duplicate([], matrix.rows),
      results: List.duplicate(0, matrix.rows)
    }

    %{
      new_matrix
      | data:
          Enum.with_index(matrix.data)
          |> Enum.map(fn {_, r_idx} ->
            correspond_r_idx =
              Enum.find_value(absolute_els, fn %Element{col: c, row: r} ->
                if r_idx == c, do: r
              end)

            Enum.at(matrix.data, correspond_r_idx)
          end),
        results:
          Enum.with_index(matrix.results)
          |> Enum.map(fn {_, r_idx} ->
            correspond_r_idx =
              Enum.find_value(absolute_els, fn %Element{col: c, row: r} ->
                if r_idx == c, do: r
              end)

            Enum.at(matrix.results, correspond_r_idx)
          end)
    }
  end

  @deprecated "made because of a misunderstanding"
  @spec correspond_cubic_norm?(matrix :: %Matrix{}) ::
          {:fail, reason :: bitstring()} | {:ok, cubic_norm :: number()}
  def correspond_cubic_norm?(matrix = %Matrix{}) do
    matrix.data
    |> Enum.map(fn row ->
      row
      |> Enum.reduce(0, fn el, acc -> abs(el) + acc end)
    end)

    cubic_norm = Enum.max(matrix.data)

    case cubic_norm do
      num when num >= 1 ->
        {:fail, "Method may not converge."}

      num when num < 1 ->
        {:ok, cubic_norm}
    end
  end

  @deprecated "made by mistake"
  @spec diagonal_dominant?(list(%Element{}), integer()) ::
          %{(row :: integer()) => col :: integer()} | false
  def diagonal_dominant?(dominant_elements, matrix_columns)
      when is_list(dominant_elements) and is_integer(matrix_columns) do
    graph =
      dominant_elements
      |> Enum.group_by(& &1.col)
      |> Enum.map(fn {c, els} ->
        {c, Enum.map(els, & &1.row)}
      end)
      |> Map.new()

    graph =
      [0..matrix_columns]
      |> Enum.reduce(graph, fn key, acc ->
        Map.put_new(acc, key, [])
      end)

    # fun = fn key -> Map.put_new(graph, key, []) end

    # graph
    # |> Enum.each(fun)

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

  @deprecated "made by mistake"
  defp try_assign(col, graph, match_row, visited) do
    Enum.reduce_while(graph[col], :fail, fn
      row, _ ->
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

# после того, как будут мы поймём - может ли доминантные элементы состовлять диагональ, делим все остальные элементы строки на эл этой же строки, состовляющий диагональ.
# получаем уравнения вида xi = (-ai1/aii)*x1 ... (-ain/aii)xn + bi/aii
# максимум домингирующих элементов 2 т.к. иначе он нне >= чем сумма всех элементов по модулю
#
#
#
#
