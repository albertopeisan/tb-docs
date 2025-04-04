# ClickHouse

## Architecture

ClickHouse distributes data across multiple nodes, each handling queries independently, with asynchronous multi-master replication ensuring redundancy. Data is stored in object storage, like VM disks or Kubernetes volumes, and recovery is mostly automatic.

## Accesing Clickhouse

Retrieve `default` user credentials from kubernetes secret.

```bash
kubectl get secret --namespace clickhouse clickhouse -o jsonpath="{.data.admin-password}" | base64 -d; echo
```

As we do not have an ingress in minikube, forward traffic to the clickhouse service on all ports.

```bash
kubectl port-forward -n clickhouse svc/clickhouse 8123:8123
```

Here's a brief description of each port used by ClickHouse:

- **8123 (HTTP Default Port)**: Used for HTTP connections to ClickHouse. This allows clients to interact with ClickHouse using HTTP requests, facilitating integration with various applications and services.
- **9000 (Native Protocol Port)**: The default port for ClickHouse's native TCP protocol. It's primarily used by ClickHouse's own applications and tools, such as clickhouse-client, for efficient data exchange and inter-server communication during distributed query processing.
- **2181 (ZooKeeper Default Service Port)**: The default port for Apache ZooKeeper, a centralized service for maintaining configuration information and providing distributed synchronization. In ClickHouse setups, ZooKeeper coordinates distributed processes like replication.
- **9444 (Inter-Server HTTPS Port)**: Used for secure inter-server communication over HTTPS. This port ensures that data exchanged between ClickHouse servers is encrypted, enhancing security in distributed environments.
- **9004 (MySQL Emulation Port)**: Allows ClickHouse to emulate a MySQL server, enabling clients and tools that communicate over MySQL's protocol to interact with ClickHouse seamlessly.
- **9005 (PostgreSQL Emulation Port)**: Enables ClickHouse to mimic a PostgreSQL server, facilitating integration with PostgreSQL-compatible clients and tools. This port also supports secure communication if SSL is enabled.
- **9009 (Inter-Server Communication Port)**: Utilized for low-level data exchange between ClickHouse servers. It's essential for replication, distributed query processing, and other inter-server communications.

As of now we will only use port 8123 to connect with Clickhouse.