defmodule Matrix do
    defstruct rows: 0,
              columns: 0,
              data: [],
              results: []

    def set_from_file(file_name) when is_bitstring(file_name) do
      case File.open("Data/" <> file_name) do
        {:error, reason} ->
          {:error, reason}

        {:ok, io_device} ->
          try do
            num_str = IO.read(io_device, :line)

            num =
              String.slice(num_str, 0..-2//1)
              |> String.to_integer()

            case num do
              num when num <= 1 ->
                {:error, "Size of matrix #{num} < 2"}

              num when num > 1 ->
                size = num

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

    defp do_set_matrix_by_row(io_device, matrix = %Matrix{}, row_idx \\ 2) do
      IO.read(io_device, :line)
      |> set_matrix_by_row(io_device, matrix, row_idx)
    end

    defp set_matrix_by_row(empty_str, io_device, matrix, row_idx)
         when empty_str == " " or empty_str == "\n",
         do: do_set_matrix_by_row(io_device, matrix, row_idx + 1)

    defp set_matrix_by_row(:eof, _, matrix, _),
      do: %Matrix{matrix | data: Enum.reverse(matrix.data), results: Enum.reverse(matrix.results)}

    defp set_matrix_by_row(data, io_device, matrix, row_idx) do
      data = String.slice(data, 0..-2//1)
      list_str = String.split(data, " ", trim: true)

      case length(list_str) == matrix.columns + 1 do
        false ->
          {:fail, "Line #{row_idx}: Not enough data. Expected #{matrix.columns + 1} numbers"}

        true ->
          try do
            list_int =
              Enum.map(list_str, fn str ->
                case Integer.parse(str) do
                  {int, ""} ->
                    int

                  _ ->
                    case Float.parse(str) do
                      {float, ""} -> float
                      _ -> throw({:error, str})
                    end
                end
              end)

            case list_int do
              reason
              when is_bitstring(reason) ->
                {:fail, reason}

              list
              when is_list(list) ->
                matrix = %Matrix{
                  matrix
                  | data: [Enum.take(list, matrix.columns) | matrix.data],
                    results: [List.last(list) | matrix.results],
                    rows: matrix.rows + 1
                }

                do_set_matrix_by_row(io_device, matrix, row_idx + 1)
            end
          catch
            {:error, str} ->
              {:fail, "Line #{row_idx}: non-number \"#{str}\""}
          end
      end
    end
  end
