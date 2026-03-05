  defmodule Main.FileUse do
    def write_files_list() do
      case File.ls("Data/") do
        {:ok,list} ->
          case write_file(list, 1) do
          :ok -> {:ok, length(list)}
          :empty ->{:empty}
          end

        {:error, reason} ->
          {:error, reason}
      end

    end

    defp write_file([], 1) do
      :empty
    end

    defp write_file([h | t], num) do
      IO.puts("#{num}.  #{h}")
      write_file(t, num+1)
    end

    defp write_file([], _) do
      :ok
    end

  end
