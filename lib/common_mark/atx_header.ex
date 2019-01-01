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
    |> reduce({List, :to_string, []})

  atx_header =
    ignore(optional(ascii_string([?\s], max: 3)))
    |> concat(prefix)
    |> optional(ignore(whitespace))
    |> optional(content)
    |> optional(ignore(suffix |> optional(whitespace)))
    |> ignore(end_of_header)
    |> post_traverse(:tag_with_level)

  @doc false
  def tag_with_level(_rest, [content, prefix] = _args, context, _line, _offset) do
    result = [{:header, [level: byte_size(prefix)], content}]
    {result, context}
  end

  defparsec(
    :atx_header,
    atx_header
  )
end
