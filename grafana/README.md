# Grafana

## Port-forwarding

To access Grafana from localhost, set up port-forwarding using the following `kubectl` command:

```bash
# Forward Grafana server service to respective local port
kubectl port-forward svc/grafana 3000:80 -n grafana
```

After running these command, you can access the service at `https://localhost:<port>` via the specified local port.