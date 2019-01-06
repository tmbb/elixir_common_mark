defmodule CommonMark do
  alias CommonMark.Parser
  alias CommonMark.Formatters.HtmlFormatter

  def to_html(text) do
    {:ok, parsed} = Parser.parse(text)
    HtmlFormatter.to_binary(parsed)
  end
end
