# ClickHouse

## Architecture

ClickHouse distributes data across multiple nodes, each handling queries independently, with asynchronous multi-master replication ensuring redundancy. Data is stored in object storage, like VM disks or Kubernetes volumes, and recovery is mostly automatic.

## Accesing Clickhouse

Retrieve `default` user credentials from kubernetes secret.

```bash
kubectl get secret --namespace clickhouse clickhouse -o jsonpath="{.data.admin-password}" | base64 -d; echo
```

## Port-forwarding

To access Clickhouse from localhost, set up port-forwarding using the following `kubectl` command:

```bash
# Forward ClickHouse service to respective local port
kubectl port-forward svc/clickhouse 8123:8123 -n clickhouse
```

After running these command, you can access the service at `https://localhost:<port>` via the specified local port.