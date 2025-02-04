defmodule HolaMundo.MixProject do
  use Mix.Project

  def project do
    [
      app: :hola_mundo,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [
        hola_mundo: [
          version: "0.1.0",
          # Ajusta la versión a la que quieras
          applications: [
            opentelemetry_exporter: :permanent,
            opentelemetry: :temporary
          ]
        ]
      ]
    ]
  end

  def application do
    [
      mod: {HolaMundo.Application, []},
      extra_applications: [:logger, :runtime_tools, :opentelemetry, :opentelemetry_exporter]
    ]
  end

  defp deps do
    [
      # Dynatrace Dependencias
      {:httpoison, version: :latest},
      {:plug_cowboy, version: :latest},
      {:jason, version: :latest},
      {:plug, version: :latest},
      {:opentelemetry_exporter, version: :latest},
      {:opentelemetry_api, version: :latest},
      {:opentelemetry, version: :latest}
    ]
  end
end
