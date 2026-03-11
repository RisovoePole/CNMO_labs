defmodule Main do
  alias Main.{CheckInput}
  import Main.FileUse, only: [write_files_list: 0]

  def run() do
    choose_file()
  end

  def choose_file() do
    case write_files_list()  do
      {:ok, len} ->
        number = CheckInput.ask_input("Choose a file:",len)

      {:empty} ->
        IO.puts("No files in directory.\nPlease add file.")
      {:error, reason} ->
        IO.inspect("Error ocured: " <> reason)
    end
  end
end


# Main.choose_file()
