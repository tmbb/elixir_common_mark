defmodule CommonMark.Parser do
  alias CommonMark.Parser.LeafBlocks.{
    AtxHeader,
    # SetextHeader,
    Paragraph
  }

  import NimbleParsec

  block_element =
    choice([
      AtxHeader.combinator(),
      Paragraph.combinator()
    ])

  # block_element = AtxHeader.combinator()

  defparsec(
    :parse_string,
    repeat(block_element)
  )

  def parse(text) do
    case parse_string(text) do
      {:ok, result, "", _, _, _} ->
        {:ok, result}

      {:error, _} ->
        {:error, nil}
    end
  end

  def parse!(text) do
    {:ok, result} = parse(text)
    result
  end
end
