defmodule CommonMark.Parser.LeafBlocks.SetextHeader do
  import NimbleParsec

  newline = ascii_char([?\n])

  maybe_initial_whitespace = ascii_string([?\s], min: 1, min: 3) |> optional() |> ignore()

  level1_underline =
    ignore(newline) |> concat(maybe_initial_whitespace) |> ascii_string([?=], min: 1)

  level2_underline =
    ignore(newline) |> concat(maybe_initial_whitespace) |> ascii_string([?-], min: 1)

  header_line =
    maybe_initial_whitespace
    |> utf8_char(not: ?=, not: ?-, not: ?>)
    |> repeat(choice([utf8_char(not: ?\n), eos()]))

  header_text =
    header_line
    |> repeat(replace(newline, ?\s) |> concat(header_line))

  level1_header =
    header_text
    |> ignore(level1_underline)
    |> post_traverse({__MODULE__, :tag_with_level, [1]})

  level2_header =
    header_text
    |> ignore(level2_underline)
    |> post_traverse({__MODULE__, :tag_with_level, [2]})

  @doc false
  def tag_with_level(_rest, args, context, _line, _offset, level) do
    binary_content = List.to_string(args)
    result = [{:header, %{level: level}, binary_content}]
    {result, context}
  end

  setext_header =
    choice([
      level1_header,
      level2_header
    ])

  defparsec(
    :setext_header,
    setext_header
  )

  @setext_header setext_header

  def combinator() do
    @setext_header
  end
end
