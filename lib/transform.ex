defmodule Edgarex.Transform do

  @divider "-----"
  @exclude_cols ["", "\r"]
  @col_delimiter "  "


  defmodule Description do
    defstruct text: "" 
  end 

  defp clean(line) do
    Enum.filter(line, fn s -> not s in @exclude_cols  end)
    |> Enum.map(fn s -> 
      s
      |> String.strip
      |> String.replace("\r", "")
    end)
  end

  defp adapt_cols(cols, delimiter) do 
    cols
    |> String.split(delimiter)
    |> clean
    |> Enum.map(fn s ->
      s
      |> String.downcase
      |> String.replace(" ", "_")
      |> String.to_atom
    end)
  end

  defp into_row_map(cols, line, delimiter) do
    line = line
    |> String.split(delimiter)
    |> clean

    cols
    |> Enum.zip(line)
    |> Enum.into(%{})
  end
  
  def adapt_ftp(stream, delimiter) do
    stream
    |> Stream.flat_map(fn str -> String.split(str, "\n") end)
    |> Stream.transform("", fn line, acc ->
      #this handles the case where a chunk is divided between 
      #in the middle of a line
      if String.last(line) != "\r" do
        {[], line}
      else
        {[acc <> line], ""}
      end
    end)
    |> Stream.transform({false, ""}, fn(line, {has_cols, cols} = acc) ->
      case has_cols do
        false -> 
          if String.contains?(line, @divider) do
            {[line], {true, adapt_cols(cols, delimiter)}}
          else
            {[line], {false, line}}
          end
        true -> 
          {[into_row_map(cols, line, delimiter)], acc}
      end
    end)

  end


end