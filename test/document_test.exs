defmodule EdgarexTest.DocParserTest do
  use ExUnit.Case
  import EdgarexTest.Util
  alias Edgarex.Docparser, as: D
  alias Exquery.Query, as: Q

  test "Docparser.tree " do
    doctypes = "small.html"
    |> doc
    |> D.to_documents
    |> Enum.map(fn doc ->
      doc.type
    end)
    
    assert doctypes == ["10-K", "EX-31", "EX-32", "EX-101.INS", 
    "EX-101.SCH", "EX-101.CAL", "EX-101.DEF", "EX-101.LAB", 
    "EX-101.PRE", "EXCEL", "XML", "XML", "EXCEL", "XML", "XML", 
    "XML", "XML", "XML", "XML", "XML", "XML", "ZIP", "XML", "XML",
    "XML", "XML", "XML", "XML", "XML", "XML", "XML", "XML", "XML", 
    "XML", "XML"]
  end

  test "docparser to documents and then into a list of docs with trees" do
    [exhibit] = "apple.html"
    |> doc
    |> D.to_documents
    |> Enum.filter(fn doc -> 
      doc.type == "EX-21.1"
    end)
    |> D.doc_trees

    subs = Q.one(exhibit.tree, {:tag, "table", []})
    |> List.wrap
    |> Q.all({:text, :any, []})
    |> Enum.filter(fn {:text, content, _} -> 
      content
      |> String.replace("&nbsp;", " ") 
      |> String.strip != "" 
    end)


    assert subs == [
      {:text, "Apple Sales International", []}, {:text, "Ireland", []},
      {:text, "Apple Operations International", []}, {:text, "Ireland", []},
      {:text, "Apple Operations Europe", []}, {:text, "Ireland", []},
      {:text, "Braeburn Capital, Inc.", []}, {:text, "Nevada,&nbsp;U.S.", []},
      {:text, "Jurisdiction", []}, {:text, "of&nbsp;Incorporation", []}
    ]
  end

  

end
