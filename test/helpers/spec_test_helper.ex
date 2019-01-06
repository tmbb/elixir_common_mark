defmodule CommonMarkTests.SpecTestsHelper do
  @moduledoc false
  alias CommonMarkTests.SpecTestsLittleHelper

  spec_path = "test/fixtures/spec.md"
  @grouped_spec_tests SpecTestsLittleHelper.grouped_examples_from_spec(spec_path)

  defp grouped_spec_tests() do
    @grouped_spec_tests
  end

  def tests_for_section(section_name) do
    case Enum.find(grouped_spec_tests(), fn {path, _tests} -> path == section_name end) do
      {_path, tests} -> tests
    end
  end

  def generate_test_suite() do
    contents =
      EEx.eval_string(
        """
        defmodule CommonMarkTests.SpecTests do
          use ExUnit.Case, async: true
          import CommonMarkTests.SpecTestsHelper, only: [tests_for_section: 1]

          <%= for {name, tests} <- grouped_tests do %>
          @tag skip: "not implemented"
          test <%= inspect(name) %> do
            # Nr of test cases: <%= length(tests) %>
            for {input, output} <- tests_for_section(<%= inspect(name) %>) do
              assert CommonMark.to_html(input) == output
            end
          end
          <% end %>
        end
        """,
        grouped_tests: grouped_spec_tests()
      )

    File.write!("test/common_mark_tests/spec_test.exs", contents)
  end
end
