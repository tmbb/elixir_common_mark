defmodule CommonMark.AtxHeader do
  import NimbleParsec

  whitespace = ascii_string([?\s], min: 1)

  escaped_hash = ascii_char([?\\]) |> ascii_char([?#])

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

  prefix = ascii_string([?#], min: 1, max: 6)
  suffix = ascii_string([?\s], min: 1) |> ascii_string([?#], min: 1)

  content =
    lookahead_not(string(" #"))
    |> concat(header_char)
    |> times(min: 1)

  closing_hashes = optional(whitespace) |> concat(end_of_header)

  extra_content = repeat(header_char) |> ignore(end_of_header)

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
    |> post_traverse(:tag_with_level)

  @doc false
  def tag_with_level(_rest, args, context, _line, _offset) do
    [prefix | content] = :lists.reverse(args)
    binary_content = List.to_string(content)
    result = [{:header, [level: byte_size(prefix)], binary_content}]
    {result, context}
  end

  defparsec(
    :atx_header,
    atx_header
  )
end
