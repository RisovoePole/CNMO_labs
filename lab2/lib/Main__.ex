defmodule Main do
  alias Main.{CheckInput}
  import Main.FileUse, only: [write_files_list: 0]


  # IO.inspect(charlists: :as_lists) для вывода списка чисел входящие в ASCII

  def main() do
    choose_file()
  end

  defp choose_file() do
    case write_files_list() do
      {:ok, list} ->
        number = CheckInput.ask_input("Choose a file:\t", length(list))

        matrix =
          Enum.at(list, number - 1)
          |> Matrix.set_from_file()
          |> IO.inspect(charlists: :as_lists)

        case Math.has_absolute_diagonal?(matrix) do
          {:fail, reason} ->
            IO.inspect(reason)
            # TODO:
            # case CheckInput.ask_confirm("Continue anyway? (y/n):\n") do
            #   true ->
            #     LOGIC...
            #     calc_with_methods(matrix, absolute_els)
            #   false -> IO.inspect("Прервано...")
            #end

          {:ok, absolute_els} ->
            calc_with_methods(matrix, absolute_els)
        end

      {:empty} ->
        IO.puts("No files in directory.\nPlease add file.")

      {:error, reason} ->
        IO.inspect("Error ocured: " <> reason)
    end
  end

  defp calc_with_methods(matrix, absolute_els) do
    {time, result} = :timer.tc(fn -> Math.jacobi_method(matrix, absolute_els, 1.0e-6) end)
    IO.puts("Jacobi method:")
    IO.puts("Time duration: #{:erlang.float_to_binary(time / 1_000_000, [decimals: 6])} с")
    IO.puts("Iterations amount:  #{inspect(Map.get(result, :iterations))}")
    IO.puts("Result: \n\t#{inspect( Map.get(result, :results))}")
  end
end
