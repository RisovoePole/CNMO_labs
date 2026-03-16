# defmodule GaussJordan and GaussSeidel в mix проект.
defmodule Math do
  defmodule Matrix do
    defstruct rows: 0,
              columns: 0,
              data: [],
              results: []

    def set_from_file(file_name) when is_bitstring(file_name) do
      case File.open("Data/" <> file_name) do
        {:ok, io_device} ->
          try do
            num = IO.read(io_device, :line)
              IO.inspect(num)
            num = num
            |> String.to_integer()

            case num do
              :eof ->
                {:error, "File #{file_name} is empty."}

              {:error, reason} ->
                {:error, reason}

              num when num <= 1 ->
                {:error, "Size of matrix #{num} < 2"}

              num when num > 1 and is_integer(num) ->
                size = String.to_integer(num)

                matrix = %Matrix{columns: size}

                result = do_set_matrix_by_row(io_device, matrix)

                case result do
                  {:fail, reason} -> {:error, reason}
                  %Matrix{rows: ^size} -> result
                  %Matrix{} -> {:error, "Not enough data rows: require #{size}"}
                end
            end
          rescue
            ArgumentError -> {:error, "Invalid size - must be positive integer."}
          end
      end
    end

    defp do_set_matrix_by_row(io_device, matrix = %Matrix{}, row_idx \\ 3) do
      IO.read(io_device, :line)
      |> set_matrix_by_row(io_device, matrix, row_idx)
    end

    defp set_matrix_by_row(" ", io_device, matrix, row_idx),
      do: do_set_matrix_by_row(io_device, matrix, row_idx + 1)

    defp set_matrix_by_row(:eof, _, matrix, _), do: matrix

    defp set_matrix_by_row(data, io_device, matrix, row_idx) do
      list_str = String.splitter(data, " ") |> Enum.take_every(1)

      case length(list_str) == matrix.columns do
        false ->
          {:fail, "Line #{row_idx}: Not enough data. Expected #{matrix.columns + 1} numbers"}

        true ->
          list_int =
            list_str
            |> Enum.reduce_while([], fn str, acc ->
              try do
                {:cont, [String.to_integer(str) | acc]}
              rescue
                ArgumentError ->
                  try do
                    {:cont, [String.to_float(str) | acc]}
                  rescue
                    ArgumentError ->
                      {:halt, "Line #{row_idx}: In data is given non number value \"#{str}\""}
                  end
              end
            end)

          case list_int do
            reason when is_bitstring(reason) ->
              {:fail, reason}

            list when is_list(list) ->
              matrix = %Matrix{
                matrix
                | data: [Enum.take(list, matrix.columns) | matrix.data],
                  results: [List.last(list) | matrix.results],
                  rows: matrix.rows + 1
              }

              do_set_matrix_by_row(io_device, matrix, row_idx + 1)
          end
      end
    end
  end

  defmodule Element do
    defstruct row: 0,
              col: 0,
              val: 0
  end

  @spec has_absolute_diagonal?(matix :: %Matrix{}) ::
          {:ok, absolute_els :: %Element{}} | {:fail, reason :: bitstring()}
  def has_absolute_diagonal?(matrix = %Matrix{data: data}) do
    # row_abs_sums = [..absolute_sums_for_each_row]
    row_abs_sums =
      data
      |> Enum.map(fn row ->
        row
        |> Enum.reduce(0, fn v, acc ->
          acc + abs(v)
        end)
      end)

    # absolute_els =  [..%Element{}] | {:fail, row_idx}
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
        {:fail, "Failed at row_idx = #{row_idx}. Not an absolute element"}

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
