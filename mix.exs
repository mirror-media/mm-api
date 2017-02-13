defmodule BqMaru.Mixfile do
  use Mix.Project

  def project do
    [app: :bq_maru,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :dev,
     start_permanent: Mix.env == :dev,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    #[applications: [:maru]]
     [ applications: (Mix.env == :dev && [:exsync] || []) ++ [:maru] ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:maru, "~> 0.11"},
     {:exsync, "~> 0.1", only: :dev },
    ]
  end

end
