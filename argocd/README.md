# ArgoCD

## Port-forwarding

To access ArgoCD from localhost, set up port-forwarding using the following `kubectl` command:

```bash
# Forward ArgoCD service to respective local port
kubectl port-forward svc/argocd-server 8080:443 -n argocd
```

After running these command, you can access the service at `https://localhost:<port>` via the specified local port.
