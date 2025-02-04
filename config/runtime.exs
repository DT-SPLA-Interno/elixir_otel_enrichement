import Config

config :opentelemetry,
  # Habilitamos la propagación de contexto:
  text_map_propagators: [:baggage, :trace_context],
  # Configuramos información sobre el servicio
  resource: [
    service: %{
      name: "hola_mundo",   # Ajusta según el nombre de tu app
      version: "0.1.0"      # Ajusta la versión a lo que necesites
    }
  ],
  # Ajusta cómo se procesan los spans
  span_processor: :batch,
  # Definimos el exportador
  traces_exporter: :otlp,
  # Detectores de recursos (opcional, agrega o elimina según requieras)
  resource_detectors: [
    :otel_resource_app_env,
    :otel_resource_env_var,
    ExtraMetadata
  ]

config :opentelemetry_exporter,
  # Tipo de protocolo para exportar trazas
  otlp_protocol: :http_protobuf,
  # La URL se obtiene de la variable de entorno OTEL_EXPORTER_OTLP_ENDPOINT
  otlp_traces_endpoint: System.get_env("OTEL_EXPORTER_OTLP_ENDPOINT", "https://default.dynatrace.com/api/v2/otlp/v1/traces"),
  # El token se obtiene de la variable de entorno OTEL_EXPORTER_OTLP_TOKEN
  otlp_traces_headers: [{"Authorization", "Api-Token #{System.get_env("OTEL_EXPORTER_OTLP_TOKEN", "default_token")}"}]
