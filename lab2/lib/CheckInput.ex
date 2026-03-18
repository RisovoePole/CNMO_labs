 defmodule Main.CheckInput do
    def ask_input(msg,len) do
      IO.gets(msg) |>
      Integer.parse() |>
      check_input(len)
    end

    defp check_input(:error, len) do
      error_msg = "Wrong type!"
      ask_input(error_msg,len)
    end

    defp check_input({number, _}, len) do
      cond do
        number<=len and number >0 ->
          number
        true ->
          error_msg = "Wrong number! Enter file number from the list."
          ask_input(error_msg, len)
        end
      end

    def ask_confirm(msg) do
      case IO.gets(msg) do
        "y" -> true
        "n" -> false
        _ -> ask_confirm(msg)
      end

    end

    end
