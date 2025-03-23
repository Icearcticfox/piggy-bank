**🚀 Как Kubernetes управляет масштабированием?**

  В Kubernetes есть **3 основных механизма масштабирования**:

|**Тип масштабирования**|**Как работает?**|**Когда использовать?**|
|---|---|---|
|**Ручное (Manual Scaling)**|Указываем количество реплик replicas: N|Когда нагрузка стабильная|
|**Горизонтальное (HPA – Horizontal Pod Autoscaler)**|Автоматически увеличивает/уменьшает кол-во подов|Когда нагрузка на CPU/RAM меняется|
|**Вертикальное (VPA – Vertical Pod Autoscaler)**|Автоматически меняет requests/limits CPU/RAM|Если поды потребляют слишком много ресурсов|
|**Автоскейлинг нод (Cluster Autoscaler)**|Добавляет/удаляет worker-ноды при нехватке ресурсов|Когда поды не помещаются на существующих нодах|

---

**1️⃣ Ручное масштабирование (Manual Scaling)**

  

Можно **задать фиксированное число реплик**:

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 3  # Количество реплик фиксировано
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: my-app
        image: nginx
        resources:
          requests:
            cpu: "100m"
            memory: "256Mi"
          limits:
            cpu: "500m"
            memory: "512Mi"
```

📌 **Когда использовать?**

✅ Если нагрузка **предсказуема**, и **динамическое масштабирование не нужно**.

  

📌 **Как изменить вручную?**

```
kubectl scale deployment my-app --replicas=5
```

  

---

**2️⃣ Горизонтальное масштабирование (HPA - Horizontal Pod Autoscaler)**

  

**HPA автоматически добавляет или удаляет поды в зависимости от нагрузки** (CPU, RAM, запросов).

  

📌 **Пример HPA по CPU:**

```
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: my-app-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: my-app
  minReplicas: 2
  maxReplicas: 10
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 70  # Если CPU >70%, увеличиваем поды
```

📌 **Как применить?**

```
kubectl apply -f hpa.yaml
kubectl get hpa
```

📌 **Когда использовать?**

✅ Если сервис **нагружается волнами** (например, утром больше пользователей, ночью меньше).

✅ Если **нагрузка зависит от API-запросов** (можно использовать **KEDA** – Kubernetes Event-driven Autoscaling).

---

**3️⃣ Вертикальное масштабирование (VPA - Vertical Pod Autoscaler)**

  

**VPA автоматически увеличивает CPU/RAM у подов, а не их количество**.

  

📌 **Пример VPA:**

```
apiVersion: autoscaling.k8s.io/v1
kind: VerticalPodAutoscaler
metadata:
  name: my-app-vpa
spec:
  targetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: my-app
  updatePolicy:
    updateMode: "Auto"
  resourcePolicy:
    containerPolicies:
      - containerName: my-app
        minAllowed:
          cpu: "200m"
          memory: "256Mi"
        maxAllowed:
          cpu: "1"
          memory: "1Gi"
```

📌 **Когда использовать?**

✅ Когда подов **мало, но они загружены**, и горизонтальное масштабирование неэффективно.

✅ Когда приложение **плохо работает с множеством реплик** (например, stateful-сервисы).

  

📌 **Как проверить текущие рекомендации VPA?**

```
kubectl describe vpa my-app-vpa
```

🚨 **Минус VPA** → **Поды пересоздаются при изменении ресурсов**, поэтому нужно учитывать **downtime**.

---

**4️⃣ Автоскейлинг нод (Cluster Autoscaler)**

  

**Если в кластере не хватает ресурсов для новых подов, Cluster Autoscaler добавляет новые worker-ноды.**

  

📌 **Как включить Cluster Autoscaler в AWS EKS?**

```
eksctl enable cluster-autoscaler --name=my-cluster
```

📌 **Как проверить, есть ли Pending Pods (ожидающие поды)?**

```
kubectl get pods --all-namespaces | grep Pending
```

📌 **Когда использовать?**

✅ Когда **нагрузка резко увеличивается**, и поды не влезают в существующие ноды.

✅ Когда **надо экономить на инфраструктуре**, удаляя ненужные ноды в низкой нагрузке.

---

**🎯 Итог: Когда использовать каждый механизм?**

|**Сценарий**|**Какой метод масштабирования использовать?**|
|---|---|
|**Хотим задать фиксированное число подов**|**Manual Scaling (replicas: N)**|
|**Нагрузка меняется в зависимости от CPU/RAM**|**HPA (Horizontal Pod Autoscaler)**|
|**Приложение нагружено, но плохо работает с репликами**|**VPA (Vertical Pod Autoscaler)**|
|**В кластере не хватает места для новых подов**|**Cluster Autoscaler (AWS, GCP, Azure)**|

🚀 **Оптимальное решение** – комбинировать **HPA + Cluster Autoscaler** (автоматически добавлять поды и ноды).
