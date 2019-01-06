defmodule CommonMarkTests.SpecTestsLittleHelper do
  @moduledoc false
  import NimbleParsec
  alias CommonMark.Parser.LeafBlocks.AtxHeader

  backticks = String.duplicate("`", 32)

  open_example = string(backticks <> " example\n")
  close_example = string(backticks) |> choice([eos(), string("\n")])

  dot = string(".\n")

  example_line =
    lookahead_not(choice([dot, close_example]))
    |> choice([utf8_string([not: ?\n], min: 1), string("")])
    |> ignore(string("\n"))

  example_lines = repeat(example_line)

  line =
    lookahead_not(open_example)
    |> optional(utf8_string([not: ?\n], min: 1))
    |> ignore(string("\n"))

  example =
    ignore(open_example)
    |> reduce(example_lines, {Enum, :join, ["\n"]})
    |> ignore(dot)
    |> reduce(example_lines, {Enum, :join, ["\n"]})
    |> ignore(close_example)
    |> reduce({List, :to_tuple, []})

  spec =
    repeat(
      choice([
        example,
        AtxHeader.combinator(),
        ignore(line)
      ])
    )

  defparsec(:extract_examples_from_spec, spec)

  defguardp is_header(element) when is_tuple(element) and elem(element, 0) == :header

  def examples_from_spec(path) do
    spec = File.read!(path)
    {:ok, examples_and_headers, _, _, _, _} = extract_examples_from_spec(spec)
    Enum.reject(examples_and_headers, fn item -> is_header(item) end)
  end

  defp collapse_path({path, group}) do
    new_path =
      path
      |> Enum.map(&header_text/1)
      |> Enum.join(" - ")

    {new_path, group}
  end

  def grouped_examples_from_spec(path) do
    spec = File.read!(path)
    {:ok, examples_and_headers, _, _, _, _} = extract_examples_from_spec(spec)

    examples_and_headers
    |> group_spec_tests()
    |> Enum.reject(fn {_path, group} -> Enum.empty?(group) end)
    |> Enum.map(&collapse_path/1)
  end

  defp header_level({:header, %{level: level}, _text}), do: level

  defp header_text({:header, _meta, text}), do: text

  def new_path(path, next_header) do
    next_level = header_level(next_header)
    rest_of_path = Enum.drop_while(path, fn header -> header_level(header) >= next_level end)
    [next_header | rest_of_path]
  end

  def group_spec_tests(tests_and_headers) do
    group_spec_tests([], [], tests_and_headers)
  end

  def group_spec_tests(path, group, []) do
    [{Enum.reverse(path), Enum.reverse(group)}]
  end

  def group_spec_tests(path, group, [next_header | rest]) when is_header(next_header) do
    new_path = new_path(path, next_header)
    [{Enum.reverse(path), Enum.reverse(group)} | group_spec_tests(new_path, [], rest)]
  end

  def group_spec_tests(path, group, [test | rest]) when not is_header(test) do
    group_spec_tests(path, [test | group], rest)
  end
end
