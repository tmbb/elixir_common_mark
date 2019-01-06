defmodule CommonMarkTests.SpecTest do
  use ExUnit.Case, async: true
  import CommonMarkTests.SpecTestsHelper, only: [tests_for_section: 1]

  @tag skip: "not implemented"
  test "Preliminaries - Tabs" do
    # Nr of test cases: 11
    for {input, output} <- tests_for_section("Preliminaries - Tabs") do
      assert CommonMark.to_html(input) == output
    end
  end

  @tag skip: "not implemented"
  test "Blocks and inlines - Precedence" do
    # Nr of test cases: 1
    for {input, output} <- tests_for_section("Blocks and inlines - Precedence") do
      assert CommonMark.to_html(input) == output
    end
  end

  @tag skip: "not implemented"
  test "Leaf blocks - Thematic breaks" do
    # Nr of test cases: 19
    for {input, output} <- tests_for_section("Leaf blocks - Thematic breaks") do
      assert CommonMark.to_html(input) == output
    end
  end

  @tag skip: "not implemented"
  test "Leaf blocks - ATX headings" do
    # Nr of test cases: 18
    for {input, output} <- tests_for_section("Leaf blocks - ATX headings") do
      IO.inspect({input, output})
      assert CommonMark.to_html(input) == output
    end
  end

  @tag skip: "not implemented"
  test "Leaf blocks - Setext headings" do
    # Nr of test cases: 26
    for {input, output} <- tests_for_section("Leaf blocks - Setext headings") do
      assert CommonMark.to_html(input) == output
    end
  end

  @tag skip: "not implemented"
  test "Leaf blocks - Indented code blocks" do
    # Nr of test cases: 12
    for {input, output} <- tests_for_section("Leaf blocks - Indented code blocks") do
      assert CommonMark.to_html(input) == output
    end
  end

  @tag skip: "not implemented"
  test "Leaf blocks - Fenced code blocks" do
    # Nr of test cases: 29
    for {input, output} <- tests_for_section("Leaf blocks - Fenced code blocks") do
      assert CommonMark.to_html(input) == output
    end
  end

  @tag skip: "not implemented"
  test "Leaf blocks - HTML blocks" do
    # Nr of test cases: 43
    for {input, output} <- tests_for_section("Leaf blocks - HTML blocks") do
      assert CommonMark.to_html(input) == output
    end
  end

  @tag skip: "not implemented"
  test "Leaf blocks - Link reference definitions" do
    # Nr of test cases: 24
    for {input, output} <- tests_for_section("Leaf blocks - Link reference definitions") do
      assert CommonMark.to_html(input) == output
    end
  end

  @tag skip: "not implemented"
  test "Leaf blocks - Paragraphs" do
    # Nr of test cases: 8
    for {input, output} <- tests_for_section("Leaf blocks - Paragraphs") do
      assert CommonMark.to_html(input) == output
    end
  end

  @tag skip: "not implemented"
  test "Leaf blocks - Blank lines" do
    # Nr of test cases: 1
    for {input, output} <- tests_for_section("Leaf blocks - Blank lines") do
      assert CommonMark.to_html(input) == output
    end
  end

  @tag skip: "not implemented"
  test "Container blocks - Block quotes" do
    # Nr of test cases: 25
    for {input, output} <- tests_for_section("Container blocks - Block quotes") do
      assert CommonMark.to_html(input) == output
    end
  end

  @tag skip: "not implemented"
  test "Container blocks - List items" do
    # Nr of test cases: 48
    for {input, output} <- tests_for_section("Container blocks - List items") do
      assert CommonMark.to_html(input) == output
    end
  end

  @tag skip: "not implemented"
  test "Container blocks - Lists" do
    # Nr of test cases: 26
    for {input, output} <- tests_for_section("Container blocks - Lists") do
      assert CommonMark.to_html(input) == output
    end
  end

  @tag skip: "not implemented"
  test "Inlines" do
    # Nr of test cases: 1
    for {input, output} <- tests_for_section("Inlines") do
      assert CommonMark.to_html(input) == output
    end
  end

  @tag skip: "not implemented"
  test "Inlines - Backslash escapes" do
    # Nr of test cases: 13
    for {input, output} <- tests_for_section("Inlines - Backslash escapes") do
      assert CommonMark.to_html(input) == output
    end
  end

  @tag skip: "not implemented"
  test "Inlines - Entity and numeric character references" do
    # Nr of test cases: 12
    for {input, output} <- tests_for_section("Inlines - Entity and numeric character references") do
      assert CommonMark.to_html(input) == output
    end
  end

  @tag skip: "not implemented"
  test "Inlines - Code spans" do
    # Nr of test cases: 21
    for {input, output} <- tests_for_section("Inlines - Code spans") do
      assert CommonMark.to_html(input) == output
    end
  end

  @tag skip: "not implemented"
  test "Inlines - Emphasis and strong emphasis" do
    # Nr of test cases: 129
    for {input, output} <- tests_for_section("Inlines - Emphasis and strong emphasis") do
      assert CommonMark.to_html(input) == output
    end
  end

  @tag skip: "not implemented"
  test "Inlines - Links" do
    # Nr of test cases: 84
    for {input, output} <- tests_for_section("Inlines - Links") do
      assert CommonMark.to_html(input) == output
    end
  end

  @tag skip: "not implemented"
  test "Inlines - Images" do
    # Nr of test cases: 22
    for {input, output} <- tests_for_section("Inlines - Images") do
      assert CommonMark.to_html(input) == output
    end
  end

  @tag skip: "not implemented"
  test "Inlines - Autolinks" do
    # Nr of test cases: 19
    for {input, output} <- tests_for_section("Inlines - Autolinks") do
      assert CommonMark.to_html(input) == output
    end
  end

  @tag skip: "not implemented"
  test "Inlines - Raw HTML" do
    # Nr of test cases: 21
    for {input, output} <- tests_for_section("Inlines - Raw HTML") do
      assert CommonMark.to_html(input) == output
    end
  end

  @tag skip: "not implemented"
  test "Inlines - Hard line breaks" do
    # Nr of test cases: 15
    for {input, output} <- tests_for_section("Inlines - Hard line breaks") do
      assert CommonMark.to_html(input) == output
    end
  end

  @tag skip: "not implemented"
  test "Inlines - Soft line breaks" do
    # Nr of test cases: 2
    for {input, output} <- tests_for_section("Inlines - Soft line breaks") do
      assert CommonMark.to_html(input) == output
    end
  end

  @tag skip: "not implemented"
  test "Inlines - Textual content" do
    # Nr of test cases: 3
    for {input, output} <- tests_for_section("Inlines - Textual content") do
      assert CommonMark.to_html(input) == output
    end
  end
end
