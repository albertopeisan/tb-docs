# Grafana

## Retrieve password

Default user for Granafa is `admin` and password can be retrieve using the following command:

```bash
kubectl get secret --namespace grafana grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

## Port-forwarding

To access Grafana from localhost, set up port-forwarding using the following `kubectl` command:

```bash
# Forward Grafana server service to respective local port
kubectl port-forward svc/grafana 3000:80 -n grafana
```

After running these command, you can access the service at `https://localhost:<port>` via the specified local port.