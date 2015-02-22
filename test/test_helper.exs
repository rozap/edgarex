ExUnit.start()


defmodule EdgarexTest.Util do
  
  def fixture(name) do
    {:ok, c} = File.cwd
    path = "#{c}/test/fixtures/#{name}"
    File.read!(path)
  end

  def doc(name) do
    fixture "docs/#{name}"
  end

	def result(name) do
    fixture "results/#{name}"
  end
end