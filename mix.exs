defmodule CommonMark.MixProject do
  use Mix.Project

  def project do
    [
      app: :common_mark,
      version: "0.1.0",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nimble_parsec, "0.5.0"},
      {:jason, "~> 1.1"},
      {:stream_data, "0.4.2", only: [:test, :dev]}
    ]
  end

  defp elixirc_paths(:dev), do: ["lib", "test/helpers"]
  defp elixirc_paths(:test), do: ["lib", "test/helpers"]
  defp elixirc_paths(_), do: ["lib"]
end
