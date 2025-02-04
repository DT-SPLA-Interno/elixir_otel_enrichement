# 📌 Elixir OpenTelemetry (OTEL) con Dynatrace

Este proyecto es una aplicación en **Elixir** instrumentada con **OpenTelemetry (OTEL)** para enviar trazas a **Dynatrace**. Permite realizar monitoreo distribuido de la aplicación y capturar métricas de desempeño.

---

## 🚀 Construcción y Ejecución de la Imagen Docker

### **1. Construir la Imagen**

Ejecuta el siguiente comando en la raíz del proyecto para construir la imagen Docker:

```sh
docker build -t elixir_otel:custom_exporter .
```

### **2. Verificar la Imagen**

Después de la construcción, verifica que la imagen fue creada correctamente con:

```sh
docker images | grep elixir_otel
```

### **3. Ejecutar la Imagen Localmente**

Para ejecutar la imagen y probarla en local, asegúrate de pasar las variables de entorno necesarias:

```sh
docker run -e OTEL_EXPORTER_OTLP_ENDPOINT="https://xxxxxxxx/api/v2/otlp/v1/traces" \
           -e OTEL_EXPORTER_OTLP_TOKEN="tu_token" \
           -p 4000:4000 elixir_otel:custom_exporter
```

Si las variables no se pasan, el contenedor fallará debido a las validaciones.

---

## 📦 Publicación de la Imagen en Docker Hub

Si deseas subir la imagen a Docker Hub, sigue estos pasos:

### **1. Etiquetar la Imagen**

```sh
docker tag elixir_otel:custom_exporter edunzz/elixir_otel:custom_exporter
```

### **2. Iniciar Sesión en Docker Hub**

```sh
docker login
```

Introduce tus credenciales de Docker Hub cuando lo solicite.

### **3. Subir la Imagen al Registro**

```sh
docker push edunzz/elixir_otel:custom_exporter
```
#### [Link de repositorio ya creado con la imagen](https://hub.docker.com/repository/docker/edunzz/elixir_otel/tags)
---

## ☸️ Despliegue en Kubernetes

### **1. Aplicar el YAML de Kubernetes (Modificar URL y token)**

El siguiente archivo `deployment.yaml` define la creación de la namespace, el secreto, el despliegue y el servicio:

```yaml
# Crear la Namespace
apiVersion: v1
kind: Namespace
metadata:
  name: elixirpoc

---
# Crear el Secret para credenciales de Dynatrace
apiVersion: v1
kind: Secret
metadata:
  name: otel-secrets
  namespace: elixirpoc
type: Opaque
data:
  OTEL_EXPORTER_OTLP_ENDPOINT: xxxurlbase64xxxxxxxxxxxxxx
  OTEL_EXPORTER_OTLP_TOKEN: xxxxxxxxxxxxxxxxxxbase64xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

---
# Crear el Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hola-mundo-deployment
  namespace: elixirpoc
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hola-mundo
  template:
    metadata:
      labels:
        app: hola-mundo
    spec:
      containers:
      - name: hola-mundo
        image: edunzz/elixir_otel:custom_exporter
        ports:
        - containerPort: 4000
        env:
        - name: OTEL_EXPORTER_OTLP_ENDPOINT
          valueFrom:
            secretKeyRef:
              name: otel-secrets
              key: OTEL_EXPORTER_OTLP_ENDPOINT
        - name: OTEL_EXPORTER_OTLP_TOKEN
          valueFrom:
            secretKeyRef:
              name: otel-secrets
              key: OTEL_EXPORTER_OTLP_TOKEN

---
# Crear el Service para exponer la aplicación
apiVersion: v1
kind: Service
metadata:
  name: hola-mundo-service
  namespace: elixirpoc
spec:
  selector:
    app: hola-mundo
  type: LoadBalancer
  ports:
    - name: http
      port: 80
      targetPort: 4000
```

### **2. Aplicar el YAML en Kubernetes**

```sh
kubectl apply -f deployment.yaml
```

### **3. Verificar los Recursos en Kubernetes**

```sh
kubectl get ns
kubectl get secret -n elixirpoc
kubectl get pods -n elixirpoc
kubectl get svc -n elixirpoc
```

### **4. Verificar el api**
```sh
curl -i http://{IP external of kubernetes svc}/
```

---

## 🛠️ ¿Qué Hace el Código?

### **1. Instrumentación con OpenTelemetry**
- Configura `opentelemetry_exporter` para enviar trazas a **Dynatrace**.
- Usa variables de entorno para la URL y el Token de Dynatrace.
- Implementa `otel_resource_env_var` para enriquecer la metadata de los spans.

### **2. Docker y Kubernetes**
- La imagen Docker empaqueta la app en **Elixir**.
- Kubernetes despliega la aplicación con un **LoadBalancer**.
- Las credenciales de Dynatrace se gestionan mediante **Secrets** en Kubernetes.

---

## 📌 Conclusión

Este proyecto demuestra cómo instrumentar una aplicación en **Elixir con OpenTelemetry**, empaquetarla en **Docker**, y desplegarla en **Kubernetes (AKS u otro cluster)** con seguridad utilizando **Secrets**.

🚀 ¡Listo para monitorear trazas con Dynatrace!

