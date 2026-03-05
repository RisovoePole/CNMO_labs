 defmodule Main.CheckInput do
    def ask_input() do
      IO.gets("Choose file:") |>
      Integer.parse() |>
      check_input()
    end

    defp check_input(:error) do
      IO.puts("Wrong type!")
      ask_input()
    end

    defp check_input({number, _}), do: number
    end
