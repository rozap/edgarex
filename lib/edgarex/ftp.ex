defmodule Edgarex.FTP do
	

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


  defmodule Pool do
    use GenServer

    def start_link(opts \\ []) do
      GenServer.start_link(__MODULE__, opts)
    end

    def init(_opts) do
      state = %{files: [], workers: []}
      {:ok, state}
    end


    def download(pid, links) do
      GenServer.cast(pid, {:download, links})
    end

    def checkout(pid, count) do
      GenServer.call(pid, {:checkout, count})
    end

    def is_downloading?(pid) do
      GenServer.call(pid, :is_downloading)
    end

    def handle_call(:is_downloading, _, state) do
      {:reply, length(state.workers) > 0, state}
    end

    def handle_call({:checkout, count}, _from, state) do
      checked = Enum.take(state.files, count)
      state = Dict.put(state, :files, Enum.drop(state.files, count))

      worker_count = length(state.workers)
      case checked do
        [] when worker_count == 0 -> {:reply, :not_downloading, state}
        _ -> {:reply, checked, state}
      end
    end

    def handle_call({:done, pid}, _, state) do
      workers = Enum.filter(state.workers, fn w -> w != pid end)
      {:reply, :ok, Dict.put(state, :workers, workers)}
    end

    def handle_call({:started, pid}, _, state) do
      workers = [pid | state.workers]
      {:reply, :ok, Dict.put(state, :workers, workers)}
    end


    def handle_cast({:add, file}, state) do
      files = [file | state.files]
      {:noreply, Dict.put(state, :files, files)}
    end

    def handle_cast({:download, forms}, state) do

      pool = self

      Task.async(fn ->
        GenServer.call(pool, {:started, self})

        files = forms
        |> Enum.map(fn form -> {form, Edgarex.FTP.from_uri(form.file_name)} end)
        |> Enum.map(fn {form, stream} -> 
          GenServer.cast(pool, {:add, {form, Enum.into(stream, "")}})
        end)
        GenServer.call(pool, {:done, self})
      end)

      {:noreply, state}
    end
  end
end