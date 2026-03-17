defmodule Main do
  alias Main.{CheckInput}
  import Main.FileUse, only: [write_files_list: 0]
  import Math

  #IO.inspect(charlists: :as_lists) для вывода списка чисел входящие в ASCII

  def main() do
    choose_file()
  end

  def choose_file() do
    case write_files_list() do
      {:ok, list} ->
        number = CheckInput.ask_input("Choose a file:", length(list))

        matrix =
        Enum.at(list, number-1)
        |> Math.Matrix.set_from_file()
        |> IO.inspect(charlists: :as_lists)


      {:empty} ->
        IO.puts("No files in directory.\nPlease add file.")

      {:error, reason} ->
        IO.inspect("Error ocured: " <> reason)
    end
  end
end

# Main.choose_file()
