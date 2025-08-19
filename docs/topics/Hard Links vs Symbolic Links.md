🔗 **Hard Link (жёсткая ссылка)**

• Указывает **не на файл**, а на **тот же inode**, что и оригинальный файл.

• Даже если исходный файл удалён, **данные остаются доступными** через жёсткую ссылку.

• Должен находиться **в той же файловой системе**.

• Размер жёсткой ссылки **равен размеру файла** (так как это тот же файл).


📌 **Пример создания Hard Link**:

```
ln original.txt hardlink.txt
```

📌 **Проверка inode (он одинаковый)**:

```
ls -li
```

🔗 **Symbolic Link (символическая ссылка, "symlink")**

• Это **файл-указатель** на другой файл или каталог.

• Если исходный файл удалён, симлинк становится **битым** (нерабочим).

• Может ссылаться на файл в **другой файловой системе**.

• Размер симлинка — это длина пути к файлу, а не размер самого файла.

📌 **Пример создания Symlink**:

```
ln -s original.txt symlink.txt
```

📌 **Проверка симлинка**:

```
ls -l
```

**Когда использовать?**

• **Hard links** хороши для создания резервных копий без дублирования данных.

• **Symbolic links** удобны для указания на файлы и каталоги в разных местах.



**3. Что такое DaemonSet в Kubernetes?**

  

🛠️ **DaemonSet** — это Kubernetes-объект, который гарантирует, что **Pod будет запущен на всех (или выбранных) узлах кластера**.

  

📌 **Для чего используется?**

• **Агент мониторинга** (например, Prometheus Node Exporter, Fluentd).

• **Логирование** (например, Filebeat, Fluent Bit).

• **Сетевые сервисы** (например, CNI-плагины: Calico, Flannel).

• **Системные демоны** (например, CSI-драйверы для хранения).

  

📌 **Пример манифеста DaemonSet**:

```
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: node-exporter
spec:
  selector:
    matchLabels:
      app: node-exporter
  template:
    metadata:
      labels:
        app: node-exporter
    spec:
      containers:
      - name: node-exporter
        image: quay.io/prometheus/node-exporter:latest
```

💡 **Разница с Deployment:**

Deployment управляет репликами, а **DaemonSet запускает по одному Pod на каждом узле**.

**4. Что такое Taints и Tolerations в Kubernetes?**

  

⚠️ **Taints (запреты)**

• Ограничивают размещение Pod'ов на узлах.

• Узел с taint принимает **только совместимые Pod'ы**.

  

📌 **Пример: сделать узел NoSchedule для обычных Pod'ов**:

```
kubectl taint nodes mynode dedicated=special:NoSchedule
```

✅ **Tolerations**

• Allow Pods to work on tainted nodes.

📌 **Example: Pod with toleration to work on tainted nodes**:

```yaml
tolerations:
- key: "dedicated"
  operator: "Equal"
  value: "special"
  effect: "NoSchedule"
```

💡 **Когда использовать?**

• Разделение кластера по типам нагрузок (например, узлы только для AI или базы данных).

• Запрет размещения Pod'ов на master-нодах (node-role.kubernetes.io/master).

🚀 **Вывод:**

• **Hard links** = тот же inode, **symlinks** = указатель на файл.

• **ICMP** нужен для диагностики сети (ping, traceroute).

• **DaemonSet** = Pod на каждом узле (логирование, мониторинг).

• **Taints/Tolerations** = управление размещением Pod'ов.