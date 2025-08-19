
VictoriaMetrics in **Cluster Mode** consists of several components that can be deployed separately for **horizontal scaling and high availability**.

## Components in Cluster Mode:

| **Component** | **Description** |
| --- | --- |
| **VMInsert** | Receives data from Prometheus/Graphite/OpenTSDB and forwards it to VMStorage. |
| **VMSelect** | Executes queries against VMStorage and connects to Grafana and PromQL. |
| **VMStorage** | The main data storage, works with SSTable (similar to TSDB in Prometheus). |
| **VMAgent** | An alternative to Prometheus, collects metrics from endpoints. |
| **VMAlert** | Sends alerts, similar to Alertmanager. |

## 1. Running VictoriaMetrics Cluster with Docker Compose

This setup **deploys all components** with the necessary port mappings.

### **docker-compose.yml File**

```  
version: '3.7'

services:
  vmstorage:
    image: victoriametrics/vmstorage
    container_name: vmstorage
    restart: always
    ports:
      - "8400:8400"
    volumes:
      - ./data:/storage
    command:
      - "-storageDataPath=/storage"
      - "-retentionPeriod=30"  # Store metrics for 30 days

  vminsert:
    image: victoriametrics/vminsert
    container_name: vminsert
    restart: always
    ports:
      - "8480:8480"
    command:
      - "-storageNode=vmstorage:8400"

  vmselect:
    image: victoriametrics/vmselect
    container_name: vmselect
    restart: always
    ports:
      - "8428:8428"
    command:
      - "-storageNode=vmstorage:8400"

  vmagent:
    image: victoriametrics/vmagent
    container_name: vmagent
    restart: always
    ports:
      - "8429:8429"
    command:
      - "-remoteWrite.url=http://vminsert:8480/insert/0/prometheus"

  vmalert:
    image: victoriametrics/vmalert
    container_name: vmalert
    restart: always
    ports:
      - "8880:8880"
    command:
      - "-datasource.url=http://vmselect:8428"
      - "-remoteWrite.url=http://vminsert:8480"
```  

### **Starting the Cluster**

```  
docker-compose up -d
```  

Now the components are accessible at:

- **VMInsert** (metric ingestion): `http://localhost:8480/insert/0/prometheus`
- **VMSelect** (queries for Grafana): `http://localhost:8428`
- **VMStorage** (main storage): `http://localhost:8400`
- **VMAgent** (metric collector): `http://localhost:8429`
- **VMAlert** (alerting): `http://localhost:8880`

## 2. Configuring Grafana with VictoriaMetrics

### **Adding Data Source in Grafana**

1. Open **Grafana** (`http://localhost:3000`).
2. Navigate to **Configuration → Data Sources**.
3. Click **Add Data Source**.
4. Select **Prometheus**.
5. In the **URL** field, enter:

```  
http://localhost:8428
```    

6. Click **Save & Test**.

Now Grafana can query VictoriaMetrics using **PromQL**.

## 3. Example Metrics and Queries

### **Example PromQL Queries for Grafana**

- **CPU Usage:**

```  
rate(node_cpu_seconds_total[5m])
```  

- **Memory Usage:**

```  
node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes * 100
```  

- **Number of Active Pods in Kubernetes:**

```  
count(kube_pod_info)
```  

## Conclusion

✅ Successfully deployed **VictoriaMetrics in Cluster Mode**  
✅ Connected **Grafana**  
✅ Ready to **collect and analyze metrics**  

The system is now **scalable, resilient, and capable of processing metrics efficiently**!