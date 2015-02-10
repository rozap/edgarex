defmodule EdgarexTest do
  use ExUnit.Case
  alias Edgarex.Fetcher, as: F

  test "crawler stream" do
    F.crawler(2014, 4) 
    |> Enum.take(50)
    |> Enum.each(fn r -> 
      assert Dict.has_key?(r, :url)
      assert Dict.has_key?(r, :company_name)
      assert Dict.has_key?(r, :form_type)
      assert Dict.has_key?(r, :cik)
      assert Dict.has_key?(r, :date_filed)
    end)
  end

  test "form stream" do
    F.form(2014, 4) 
    |> Enum.take(50)
    |> Enum.each(fn r -> 
      assert Dict.has_key?(r, :file_name)
      assert Dict.has_key?(r, :company_name)
      assert Dict.has_key?(r, :form_type)
      assert Dict.has_key?(r, :cik)
      assert Dict.has_key?(r, :date_filed)
    end)
  end

  test "master stream" do
    F.master(2014, 4) 
    |> Enum.take(50)
    |> Enum.each(fn r -> 
      assert Dict.has_key?(r, :filename)
      assert Dict.has_key?(r, :company_name)
      assert Dict.has_key?(r, :form_type)
      assert Dict.has_key?(r, :cik)
      assert Dict.has_key?(r, :date_filed)
    end)
  end

  test "xbrl stream" do
    F.xbrl(2014, 4) 
    |> Enum.take(50)
    |> Enum.each(fn r -> 
      assert Dict.has_key?(r, :filename)
      assert Dict.has_key?(r, :company_name)
      assert Dict.has_key?(r, :form_type)
      assert Dict.has_key?(r, :cik)
      assert Dict.has_key?(r, :date_filed)
    end)
  end
end
