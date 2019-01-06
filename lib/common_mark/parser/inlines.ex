defmodule CommonMark.Parser.Inlines do
  import NimbleParsec

  all_html_entities_map = "lib/data/entities.json" |> File.read!() |> Jason.decode!()

  recognized_html_entities_map =
    for {name, value} <- all_html_entities_map, String.ends_with?(name, ";"), into: %{} do
      {name, value}
    end

  unrecognized_html_entities_map =
    for {name, value} <- all_html_entities_map, not String.ends_with?(name, ";"), into: %{} do
      {name, value}
    end

  @all_html_entities_map all_html_entities_map

  @recognized_html_entities_map recognized_html_entities_map

  @unrecognized_html_entities_map unrecognized_html_entities_map

  def recognized_html_entities() do
    @recognized_html_entities_map
  end

  def all_html_entities() do
    @all_html_entities_map
  end

  def unrecognized_html_entities() do
    @unrecognized_html_entities_map
  end

  html_entity =
    choice(
      for {name, %{"characters" => characters}} <- recognized_html_entities_map do
        string(name) |> replace(characters)
      end
    )

  # Copied from the spec
  ascii_punctuation_characters =
    '\!\"\#\$\%\&\'\(\)\*\+\,\-\.\/\:\;\<\=\>\?\@\[\\\]\^\_\`\{\|\}\~'

  ampersand = string("&") |> replace({:character, %{}, ?&})

  decimal_numeric_character =
    ignore(string("&#"))
    |> ascii_string([?0..?9], min: 1, max: 8)
    |> ignore(string(";"))
    |> map({__MODULE__, :codepoint_to_utf8_char, [10]})

  hexadecimal_numeric_character =
    ignore(string("&#"))
    |> ignore(ascii_char([?x, ?X]))
    |> ascii_string([?0..?9, ?a..?f, ?A..?F], min: 1, max: 8)
    |> ignore(string(";"))
    |> map({__MODULE__, :codepoint_to_utf8_char, [16]})

  def is_valid_utf8_codepoint?(codepoint) do
    in_first_page? = 0x0000 <= codepoint and codepoint <= 0x007F
    in_second_page? = 0x0080 <= codepoint and codepoint <= 0x07FF
    in_third_page? = 0x0800 <= codepoint and codepoint <= 0xFFFF
    in_fourth_page? = 0x10000 <= codepoint and codepoint <= 0x10FFF
    # Test if the codepoint belongs to one of the pages
    in_first_page? or in_second_page? or in_third_page? or in_fourth_page?
  end

  def codepoint_to_utf8_char(binary, base) do
    codepoint = String.to_integer(binary, base)

    cond do
      codepoint == 0 ->
        # Unicode replacement character
        0xFFFD

      is_valid_utf8_codepoint?(codepoint) ->
        codepoint

      true ->
        # Unicode replacement character
        0xFFFD
    end
  end

  backslash_escaped_char =
    ascii_char([?\\])
    |> ignore()
    |> ascii_char(ascii_punctuation_characters)

  hard_line_break =
    ascii_char([?\\])
    |> ignore()
    |> ascii_char([?\n])
    |> replace({:hard_line_break, %{}, []})

  chars =
    lookahead_not(hard_line_break)
    |> choice([
      html_entity,
      hexadecimal_numeric_character,
      decimal_numeric_character,
      backslash_escaped_char,
      utf8_char(not: ?&, not: ?<)
    ])
    |> times(min: 1)
    |> reduce({List, :to_string, []})

  inlines =
    repeat(
      choice([
        hard_line_break,
        chars,
        ampersand
      ])
    )

  defparsec(:inlines, inlines)

  def parse_inlines(text) do
    {:ok, parsed, "", _, _, _} = inlines(text)
    parsed
  end
end
