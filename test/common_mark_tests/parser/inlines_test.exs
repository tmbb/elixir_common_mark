defmodule CommonMarkTests.Parser.InlinesTest do
  use ExUnit.Case, async: true
  use ExUnitProperties
  alias CommonMark.Parser.Inlines
  import Inlines, only: [parse_inlines: 1]

  test "recognize hard line breaks" do
    assert parse_inlines("\\\n") == [{:hard_line_break, %{}, []}]
  end

  test "recognize hard line breaks preceeded by text" do
    assert parse_inlines("abc\\\n") == ["abc", {:hard_line_break, %{}, []}]
  end

  test "recognize hard line breaks followed by text" do
    assert parse_inlines("\\\nxyz") == [{:hard_line_break, %{}, []}, "xyz"]
  end

  test "recognize hard line breaks preceeded and followed by text" do
    assert parse_inlines("abc\\\nxyz") == ["abc", {:hard_line_break, %{}, []}, "xyz"]
  end

  describe "HTML entities:" do
    @recognized_entities Inlines.recognized_html_entities() |> Map.keys() |> MapSet.new()

    def is_recognized_html_entity?(binary) do
      MapSet.member?(@recognized_entities, binary)
    end

    test "recognize the whitelisted entities that end in a `;`" do
      # `chars` is actually a binary
      for {name, %{"characters" => chars}} <- Inlines.recognized_html_entities() do
        assert parse_inlines(name) == [chars]
      end
    end

    test "valid html entities outside the whitelist are not recognized" do
      # These HTML entities don't end in `;` and according to the spec
      # should not be recognized by a compliant markdown parser
      for {"&" <> rest = name, _value} <- Inlines.unrecognized_html_entities() do
        assert parse_inlines(name) == [{:character, %{}, ?&}, rest]
      end
    end

    property "alphanumeric text ending in `;` after the `?&` is not recognized as an HTML entity" do
      check all binary <- StreamData.string(:alphanumeric),
                fake_entity = "&" <> binary <> ";",
                not is_recognized_html_entity?(fake_entity) do
        assert parse_inlines(fake_entity) == [{:character, %{}, ?&}, binary <> ";"]
      end
    end
  end

  describe "unicode characters:" do
    test "decimal representation; test all valid ascii codepoints (except the null byte)" do
      for c <- 1..127 do
        input = "&##{c};"
        expected_output = <<c>>
        assert parse_inlines(input) == [expected_output]
      end
    end

    test "decimal; null byte is replaced by replacement character" do
      assert parse_inlines("&#0000;") == [<<0xFFFD::utf8>>]
    end

    test "decimal; invalid codepoints are replaced by replacement character" do
      assert parse_inlines("&#11111111;") == [<<0xFFFD::utf8>>]
    end

    test "hex representation; test all valid ascii codepoints (except the null byte)" do
    end

    test "hex; null byte is replaced by replacement character" do
    end

    test "hex; invalid codepoints are replaced by replacement character" do
    end
  end

  describe "backslash escapes:" do
    test "recognize escaped ascii punctuation characters" do
      # copied from the spec
      for c <- '\!\"\#\$\%\&\'\(\)\*\+\,\-\.\/\:\;\<\=\>\?\@\[\\\]\^\_\`\{\|\}\~' do
        binary = <<"\\", c>>
        assert parse_inlines(binary) == [<<c>>]
      end
    end

    property "backslashes followed by characters other than the whitelisted ones are returned as literal backslashes" do
      # Guarantee we test alphanumeric characters, which will be the most common case
      check all <<c::utf8>> <- StreamData.string(:alphanumeric, length: 1),
                c != ?\n and
                  c not in '\!\"\#\$\%\&\'\(\)\*\+\,\-\.\/\:\;\<\=\>\?\@\[\\\]\^\_\`\{\|\}\~' do
        binary = <<"\\", c::utf8>>
        assert parse_inlines(binary) == [binary]
      end

      # Throw random printable characters at it to see if it works
      check all <<c::utf8>> <- StreamData.string(:printable, length: 1),
                c != ?\n and
                  c not in '\!\"\#\$\%\&\'\(\)\*\+\,\-\.\/\:\;\<\=\>\?\@\[\\\]\^\_\`\{\|\}\~' do
        binary = <<"\\", c::utf8>>
        assert parse_inlines(binary) == [binary]
      end
    end
  end
end
