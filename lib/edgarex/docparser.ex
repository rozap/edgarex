defmodule Edgarex.Docparser do


  defmodule Document do
    @derive [Access, Enumerable]
    defstruct type: "", sequence: "", filename: "", description: "", text: "", tree: nil
  end

  defp push_current(mode, current, doc) do
    Map.put(doc, mode, current)
  end

  defp parse_doc("", _, _, _, docs) do
    Enum.reverse(docs)
  end

  defp parse_doc("<DOCUMENT>" <> rest, :none, doc, current, docs) do
    parse_doc(rest, :doc, doc, current, docs)
  end

  defp parse_doc("</DOCUMENT>" <> rest, :doc, doc, current, docs) do
    parse_doc(rest, :none, %Document{}, "", [doc | docs])
  end

  defp parse_doc("<TYPE>" <> rest, mode, doc, current, docs) do
    doc = push_current(mode, current, doc)
    parse_doc(rest, :type, doc, "", docs)
  end

  defp parse_doc("<SEQUENCE>" <> rest, mode, doc, current, docs) do
    doc = push_current(mode, current, doc)
    parse_doc(rest, :sequence, doc, current, docs)
  end

  defp parse_doc("<FILENAME>" <> rest, mode, doc, current, docs) do
    doc = push_current(mode, current, doc)
    parse_doc(rest, :filename, doc, current, docs)
  end

  defp parse_doc("<DESCRIPTION>" <> rest, mode, doc, current, docs) do
    doc = push_current(mode, current, doc)
    parse_doc(rest, :description, doc, current, docs)
  end

  defp parse_doc("</TEXT>" <> rest, mode, doc, current, docs) do
    doc = push_current(mode, current, doc)
    parse_doc(rest, :doc, doc, current, docs)
  end
  defp parse_doc("<TEXT>" <> rest, mode, doc, current, docs) do
    doc = push_current(mode, current, doc)    
    parse_doc(rest, :text, doc, current, docs)
  end

  defp parse_doc(<<token::binary-size(1), rest::binary>>, :none, doc, current, docs) do
    parse_doc(rest, :none, doc, current, docs)
  end
  defp parse_doc(<<token::binary-size(1), rest::binary>>, :doc, doc, current, docs) do
    parse_doc(rest, :doc, doc, current, docs)
  end

  defp parse_doc("\n" <> rest, key, doc, current, docs) do
    parse_doc(rest, key, doc, current, docs)
  end

  defp parse_doc("\r" <> rest, key, doc, current, docs) do
    parse_doc(rest, key, doc, current, docs)
  end


  defp parse_doc(<<token::binary-size(1), rest::binary>>, key, doc, current, docs) do
    # doc = Map.put(doc, key, doc[key] <> token)
    current = current <> token
    parse_doc(rest, key, doc, current, docs)
  end


  # EDGAR uses this weird format without closing tags, but within the
  # <TEXT> tag of a document itself, things seem to be uniform. This
  # function will split a blob of text into documents, with some metadata
  # and then an actual parse tree
  def to_documents(text) do
    parse_doc(text, :none, %Document{}, "", [])
  end



  #Turn a list of doc's text fields in html trees
  def doc_trees(docs) do
    docs
    |> Enum.map(fn doc ->
      Task.async(fn ->
        tree = Exquery.tree(doc.text)
        Map.put(doc, :tree, tree)
      end)
    end)
    |> Enum.map(fn task ->
      Task.await(task, 10_000)
    end)
  end

end