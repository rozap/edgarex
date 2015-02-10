defmodule Edgarex.Fetcher do

  alias Edgarex.Transform
  
  def url_for(name, year, quarter) do
  end

  defp stream_it(name, year, quarter) do
    url = "/edgar/full-index/#{year}/QTR#{quarter}/#{name}.idx"
    Stream.resource(
      fn -> 
        {:ok, ftp} = :ftp.open('ftp.sec.gov')
        :ftp.user(ftp, 'anonymous', '')
        :ftp.recv_chunk_start(ftp, String.to_char_list(url))
        ftp 
      end,
      fn(ftp) ->
        case :ftp.recv_chunk(ftp) do
          :ok -> {:halt, ftp}
          {:ok, bin} -> 
            # IO.inspect bin
            {[bin], ftp}
          {:error, reason} -> IO.inspect reason
        end
      end,
      fn(pid) -> :ftp.close(pid) end
    )
  end


  @indexes [
    crawler: "  ",
    form: "  ",
    master: "|"
  ]

  Enum.each(@indexes, fn {name, delimiter} ->
    def unquote(name)(year, quarter) do
      unquote(name)
      |> Atom.to_string
      |> stream_it(year, quarter)
      |> Transform.adapt_ftp(unquote(delimiter))
      |> Stream.filter(fn item -> is_map(item) end)
    end
  end)

  
end