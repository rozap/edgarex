defmodule EdgarexTest.FetchTest do
  use ExUnit.Case
  alias Edgarex.Fetcher, as: F
  alias Edgarex.FTPStream, as: FTP
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


end