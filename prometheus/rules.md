## Prometheus Rules

Below are the explanations and configurations for the alerting rules and recording rules.

### Alerting Rules

#### NodeDown

**Description:**
This alert checks if any individual Kubernetes node is down for more than 1 minute. It uses the `up` metric from Prometheus to determine node availability. A separate alert is triggered for each node that is down.

```yaml
## Alerts configuration
## Ref: https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/
alerting_rules.yml:
  groups:
    - name: Nodes
      rules:
        - alert: NodeDown
          expr: up{job="kubernetes-nodes"} == 0
          for: 1m
          labels:
            severity: critical
          annotations:
            description: 'Kubernetes node {{ $labels.instance }} is down for more than 1 minute.'
            summary: 'Node Down: {{ $labels.instance }}'
```

### Recording Rules

#### AverageNodeCPUUsage

**Description:**
This recording rule calculates the average CPU usage across all nodes over a 5-minute window. It helps in monitoring and analyzing overall CPU utilization without recalculating it every time in queries.

```yaml
## Records configuration
## Ref: https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/
recording_rules.yml:
  groups:
    - name: NodeMetrics
      rules:
        - record: instance:node_cpu_utilisation:rate5m
          expr: 100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
        - record: average_node_cpu_usage
          expr: avg(instance:node_cpu_utilisation:rate5m)
```
