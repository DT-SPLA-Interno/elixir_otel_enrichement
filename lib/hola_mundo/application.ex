defmodule HolaMundo.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Inicia el servidor HTTP en el puerto 4000
      {Plug.Cowboy, scheme: :http, plug: HolaMundo.Router, options: [port: 4000]}
    ]

    opts = [strategy: :one_for_one, name: HolaMundo.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
