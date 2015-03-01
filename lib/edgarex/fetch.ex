defmodule Edgarex.Fetcher do
  alias Edgarex.Transform
  
  defp index_stream(name, year, quarter) do
    uri = "/edgar/full-index/#{year}/QTR#{quarter}/#{name}.idx"
    Edgarex.FTP.from_uri(uri)
  end


  @indexes [
    crawler: "  ",
    form: "  ",
    master: "|",
    xbrl: "|"
  ]

  Enum.each(@indexes, fn {name, delimiter} ->
    def unquote(name)(year, quarter) do
      unquote(name)
      |> Atom.to_string
      |> index_stream(year, quarter)
      |> Transform.adapt_ftp(unquote(delimiter))
      |> Stream.filter(fn item -> is_map(item) end)
    end
  end)


  
end