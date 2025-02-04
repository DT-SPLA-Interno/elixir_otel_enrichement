defmodule HolaMundo.Router do
  use Plug.Router
  require OpenTelemetry.Tracer, as: Tracer

  plug :match
  plug :dispatch

  get "/" do
    # Iniciamos un span con nombre "GET /"
    Tracer.with_span "GET /" do
      # Podemos añadir atributos específicos (clave-valor) para ver más información en Dynatrace
      Tracer.set_attributes([
        {"http.method", "GET"},
        {"http.route", "/"}
      ])

      send_resp(conn, 200, "hola mundo")
    end
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end
end
