defmodule Edgarex.FTPStream do
	

	def from_uri(uri) do
    Stream.resource(
      fn -> 
        case :ftp.open('ftp.sec.gov') do
          {:error, err} -> raise Atom.to_string(err)
          {:ok, ftp} ->
            :ftp.user(ftp, 'anonymous', '')
            :ftp.recv_chunk_start(ftp, String.to_char_list(uri))
            ftp 

        end
      end,
      fn(ftp) ->
        case :ftp.recv_chunk(ftp) do
          :ok -> {:halt, ftp}
          {:ok, bin} -> 
            {[bin], ftp}
          {:error, reason} -> IO.inspect reason
        end
      end,
      fn(pid) -> :ftp.close(pid) end
    )
	end

end