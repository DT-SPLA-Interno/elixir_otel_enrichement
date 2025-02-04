# Etapa de compilación
FROM elixir:1.13 AS build

# Instalamos Hex y Rebar (si no están instalados)
RUN mix local.hex --force && mix local.rebar --force

WORKDIR /app

# Copiar archivos de definición del proyecto y configuración
COPY mix.exs mix.lock ./ 
COPY config config 

# Instalar dependencias (en ambiente prod)
RUN MIX_ENV=prod mix deps.get --only prod

# Copiar el resto del código fuente
COPY . .

# Compilar y construir el release
RUN MIX_ENV=prod mix release --overwrite

# Etapa final: imagen de runtime
FROM elixir:1.13-slim

WORKDIR /app

# Definir variables de entorno obligatorias (sin valores predeterminados)
ENV OTEL_EXPORTER_OTLP_ENDPOINT=""
ENV OTEL_EXPORTER_OTLP_TOKEN=""

# Copiar el release desde la etapa de compilación
COPY --from=build /app/_build/prod/rel/hola_mundo ./ 

# Exponer el puerto donde corre la aplicación
EXPOSE 4000

# Verificar si las variables de entorno están definidas antes de iniciar la app
ENTRYPOINT ["/bin/sh", "-c", "if [ -z \"$OTEL_EXPORTER_OTLP_ENDPOINT\" ] || [ -z \"$OTEL_EXPORTER_OTLP_TOKEN\" ]; then echo 'ERROR: Debes definir las variables OTEL_EXPORTER_OTLP_ENDPOINT y OTEL_EXPORTER_OTLP_TOKEN'; exit 1; fi; exec bin/hola_mundo start"]
