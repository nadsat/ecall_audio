defmodule Ecall.Audio.MixProject do
  use Mix.Project
  @version "0.1.0"
  def project do
    [
      app: :ecall_audio,
      version: @version,
      elixir: "~> 1.7",
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
      {:circuits_uart, "~> 1.2"}
    ]
  end
end
