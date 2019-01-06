defmodule CommonMark.Parser.LeafBlocks.Paragraph do
  import NimbleParsec

  alias CommonMark.Parser.LeafBlocks.AtxHeader

  end_of_line = choice([ascii_char([?\n]), eos()])

  line_char =
    choice([
      ignore(ascii_char([?\\])) |> utf8_char(not: ?\n),
      utf8_char(not: ?\n)
    ])

  line =
    times(line_char, min: 1)
    |> ignore(end_of_line)
    |> post_traverse({__MODULE__, :make_line, []})

  @doc false
  def make_line(_rest, args, context, _line, _offset) do
    chars = :lists.reverse(args)
    binary_content = List.to_string(chars)
    {[binary_content], context}
  end

  paragraph_line =
    lookahead_not(AtxHeader.combinator())
    |> concat(line)

  empty_line = ignore(ascii_char([?\n]))

  end_of_paragraph = choice([times(empty_line, min: 1), eos()])

  paragraph =
    times(paragraph_line, min: 1)
    |> ignore(end_of_paragraph)
    |> post_traverse({__MODULE__, :make_paragraph, []})

  def make_paragraph(_rest, args, context, _line, _offset) do
    text = args |> Enum.reverse() |> Enum.join("\n")
    {[{:paragraph, %{}, text}], context}
  end

  defparsec(
    :paragraph,
    paragraph
  )

  @paragraph paragraph

  def combinator() do
    @paragraph
  end
end
