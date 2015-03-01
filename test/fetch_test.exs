defmodule EdgarexTest.FetchTest do
  use ExUnit.Case
  alias Edgarex.Fetcher, as: F
  alias Edgarex.FTP
  import EdgarexTest.Util

  test "can obtain via url" do
    F.form(2014, 4)
    |> Enum.take(2)
    |> Enum.map(fn r -> 
      {r.file_name, 
      r.file_name
      |> FTP.from_uri 
      |> Enum.into("")
      |> String.replace("\r", "")
      } end)
    |> Enum.each(fn {fname, res} ->
      fname = String.split(fname, "/") |> List.last
      assert res == result(fname)
    end)

  end


  defp wait_for(pool) do
    case FTP.Pool.checkout(pool, 10) do
      [] -> 
        :timer.sleep(500)
        wait_for(pool)
      items -> 
        items
    end
  end

  @tag timeout: 600_000
  test "can obtain many links" do
    lynx = [
      %{file_name: "edgar/data/1118974/0001065949-14-000251.txt"},
      %{file_name: "edgar/data/812149/0001144204-14-076183.txt"},
      %{file_name: "edgar/data/1400683/0001127855-14-000456.txt"}
    ]

    {:ok, pool} = FTP.Pool.start_link

    FTP.Pool.download(pool, lynx)
    [{form, file}] = wait_for(pool)
    
    assert form == %{file_name: "edgar/data/1118974/0001065949-14-000251.txt"}

  end


end