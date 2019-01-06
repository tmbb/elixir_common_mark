defmodule CommonMark.Formatters.HtmlFormatter do
  def element_to_iolist({:header, %{level: level}, text}) when is_integer(level) do
    binary_level = to_string(level)
    ["<h", binary_level, ">", text, "</h", binary_level, ">\n"]
  end

  def element_to_iolist({:paragraph, _meta, text}) do
    ["<p>", text, "</p>\n"]
  end

  def to_iolist(elements) do
    Enum.map(elements, &element_to_iolist/1)
  end

  def to_binary(elements) do
    elements |> to_iolist() |> IO.iodata_to_binary() |> String.trim()
  end
end
