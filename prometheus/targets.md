## Targets

Let's break down each job from the provided `prometheus.yml` configuration file:

### 1. Prometheus Job

```yaml
- job_name: prometheus
  static_configs:
    - targets:
        - localhost:9090
```

This job is configured to scrape Prometheus itself, running on `localhost:9090`. It's useful for monitoring the health and performance of the Prometheus server.

### 2. Kubernetes API Servers Job

```yaml
- job_name: 'kubernetes-apiservers'
  kubernetes_sd_configs:
    - role: endpoints
  scheme: https
  tls_config:
    ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
  bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
  relabel_configs:
    - source_labels: [__meta_kubernetes_namespace, __meta_kubernetes_service_name, __meta_kubernetes_endpoint_port_name]
      action: keep
      regex: default;kubernetes;https
```

This job is configured to scrape Kubernetes API servers.
- `kubernetes_sd_configs` with `role: endpoints` automatically discovers API server endpoints.
- It scrapes over HTTPS using the CA certificate and bearer token stored in the service account secrets.
- The `relabel_configs` filters to keep only the default/kubernetes service endpoints on the HTTPS port.

### 3. Kubernetes Nodes Job

```yaml
- job_name: 'kubernetes-nodes'
  scheme: https
  tls_config:
    ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
  bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
  kubernetes_sd_configs:
    - role: node
  relabel_configs:
    - action: labelmap
      regex: __meta_kubernetes_node_label_(.+)
    - target_label: __address__
      replacement: kubernetes.default.svc:443
    - source_labels: [__meta_kubernetes_node_name]
      regex: (.+)
      target_label: __metrics_path__
      replacement: /api/v1/nodes/$1/proxy/metrics
```

This job scrapes metrics from Kubernetes nodes.
- `kubernetes_sd_configs` with `role: node` discovers all the nodes in the cluster.
- It uses HTTPS for secure communication with the API server, using service account credentials.
- The `relabel_configs` map node labels to Prometheus labels and set the target address and metrics path.

### 4. Kubernetes Nodes cAdvisor Job

```yaml
- job_name: 'kubernetes-nodes-cadvisor'
  scheme: https
  tls_config:
    ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
  bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
  kubernetes_sd_configs:
    - role: node
  relabel_configs:
    - action: labelmap
      regex: __meta_kubernetes_node_label_(.+)
    - target_label: __address__
      replacement: kubernetes.default.svc:443
    - source_labels: [__meta_kubernetes_node_name]
      regex: (.+)
      target_label: __metrics_path__
      replacement: /api/v1/nodes/$1/proxy/metrics/cadvisor
```

This job scrapes cAdvisor metrics from Kubernetes nodes.
- Similar to the `kubernetes-nodes` job, but specifically targets the cAdvisor metrics path (`/metrics/cadvisor`).

### 5. Kubernetes Service Endpoints Job

```yaml
- job_name: 'kubernetes-service-endpoints'
  honor_labels: true
  kubernetes_sd_configs:
    - role: endpoints
  relabel_configs:
    - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_scrape]
      action: keep
      regex: true
    - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_scrape_slow]
      action: drop
      regex: true
    # Additional relabel_configs to configure the scrape target based on annotations.
```

This job scrapes metrics from service endpoints within Kubernetes.
- It uses `kubernetes_sd_configs` with `role: endpoints` to discover all endpoint objects.
- The `honor_labels: true` directive ensures that labels in the scraped data are not overwritten by Prometheus's own labels.
- The `relabel_configs` filter services based on annotations like `prometheus.io/scrape` and `prometheus.io/scrape-slow`, and configure the scrape scheme, path, and port accordingly.

### 6. Kubernetes Service Endpoints Slow Job

```yaml
- job_name: 'kubernetes-service-endpoints-slow'
  honor_labels: true
  scrape_interval: 5m
  scrape_timeout: 30s
  kubernetes_sd_configs:
    - role: endpoints
  relabel_configs:
    - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_scrape_slow]
      action: keep
      regex: true
    # Additional relabel_configs to configure the scrape target based on annotations.
```

Similar to `kubernetes-service-endpoints`, but specifically for services annotated with `prometheus.io/scrape-slow`.
- It has a longer scrape interval (`5m`) and a longer timeout (`30s`).

### 7. Prometheus Pushgateway Job

```yaml
- job_name: 'prometheus-pushgateway'
  honor_labels: true
  kubernetes_sd_configs:
    - role: service
  relabel_configs:
    - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_probe]
      action: keep
      regex: pushgateway
```

This job scrapes metrics from Prometheus Pushgateway instances.
- It discovers services with the annotation `prometheus.io/probe: pushgateway`.
- The `honor_labels: true` directive ensures that labels in the scraped data are not overwritten by Prometheus's own labels.

### 8. Kubernetes Services Job (Blackbox Exporter)

```yaml
- job_name: 'kubernetes-services'
  honor_labels: true
  metrics_path: /probe
  params:
    module: [http_2xx]
  kubernetes_sd_configs:
    - role: service
  relabel_configs:
    # Relabeling configurations to set the target and other parameters.
```

This job uses the Blackbox Exporter to probe HTTP endpoints of Kubernetes services.
- It discovers services with the annotation `prometheus.io/probe: true`.
- The `relabel_configs` set the target URL and other parameters required by the Blackbox Exporter.

### 9. Kubernetes Pods Job

```yaml
- job_name: 'kubernetes-pods'
  honor_labels: true
  kubernetes_sd_configs:
    - role: pod
  relabel_configs:
    # Relabeling configurations to filter and set scrape parameters based on annotations.
```

This job scrapes metrics from Kubernetes pods.
- It uses `kubernetes_sd_configs` with `role: pod` to discover all pods in the cluster.
- The `honor_labels: true` directive ensures that labels in the scraped data are not overwritten by Prometheus's own labels.
- The `relabel_configs` filter pods based on annotations like `prometheus.io/scrape`, configure the scrape scheme, path, and port accordingly.

### 10. Kubernetes Pods Slow Job

```yaml
- job_name: 'kubernetes-pods-slow'
  honor_labels: true
  scrape_interval: 5m
  scrape_timeout: 30s
  kubernetes_sd_configs:
    - role: pod
  relabel_configs:
    # Relabeling configurations to filter and set scrape parameters based on annotations.
```

- Similar to `kubernetes-pods`, but specifically for pods annotated with `prometheus.io/scrape-slow`.
- It has a longer scrape interval (`5m`) and a longer timeout (`30s`).

Each job in this configuration file is tailored to scrape different components of the Kubernetes cluster, from API servers and nodes to services and individual pods, ensuring comprehensive monitoring.
