# Prometheus

## Port-forwarding

To access Prometheus from localhost, set up port-forwarding using the following `kubectl` command:

```bash
# Forward Prometheus server service to respective local port
kubectl port-forward svc/prometheus-server 9090:9090 -n prometheus
```

After running these command, you can access the service at `https://localhost:<port>` via the specified local port.