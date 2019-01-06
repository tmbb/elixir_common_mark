defmodule CommonMark.Parser.LeafBlocks.AtxHeader do
  import NimbleParsec

  whitespace = ascii_string([?\s], min: 1)

  escaped_hash = ascii_char([?\\]) |> ignore() |> ascii_char([?#])

  header_char =
    choice([
      utf8_char(not: ?\n),
      escaped_hash
    ])

  end_of_header =
    choice([
      string("\n"),
      eos()
    ])

  prefix = ascii_string([?#], min: 1, max: 6) |> ignore(whitespace)
  suffix = ascii_string([?\s], min: 1) |> ascii_string([?#], min: 1)

  content =
    lookahead_not(string(" #"))
    |> concat(header_char)
    |> times(min: 1)

  closing_hashes = optional(ascii_string([?#], min: 1))

  extra_content = repeat(header_char)

  atx_header =
    ignore(optional(ascii_string([?\s], max: 3)))
    |> concat(prefix)
    |> optional(ignore(whitespace))
    |> optional(content)
    |> optional(
      suffix
      |> choice([
        ignore(closing_hashes),
        extra_content
      ])
    )
    |> ignore(end_of_header)
    |> post_traverse({__MODULE__, :tag_with_level, []})

  @doc false
  def tag_with_level(_rest, args, context, _line, _offset) do
    [prefix | content] = :lists.reverse(args)
    binary_content = List.to_string(content)
    result = [{:header, %{level: byte_size(prefix)}, binary_content}]
    {result, context}
  end

  @doc false
  defparsec(
    :atx_header,
    atx_header
  )

  @atx_header atx_header

  def combinator() do
    @atx_header
  end
end
