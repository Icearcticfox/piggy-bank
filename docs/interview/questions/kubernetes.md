#### Как Kubernetes управляет масштабированием?

  

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

---

### Kubernetes Security

  

🔹 **Какие best practices ты используешь для защиты Kubernetes-кластера?**

Отлично, давай разберем **лучшие практики безопасности Kubernetes** с нуля, чтобы ты мог уверенно отвечать на интервью.

---

**🚀 Kubernetes Security Best Practices**

  

Kubernetes имеет **много уровней защиты** – от контейнеров до сети и RBAC. Разберем **ключевые практики**, которые помогут защитить кластер.

---

**1️⃣ Аутентификация и Авторизация (RBAC)**

  

✅ **Используй Role-Based Access Control (RBAC)**

• Включаем **минимальные привилегии (Principle of Least Privilege)**.

• Разделяем **права на уровне namespace**.

• Избегаем cluster-admin без необходимости.

  

📌 **Пример RBAC-роли для чтения подов:**

```
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: default
  name: read-only-role
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list"]
```

📌 **Применяем и назначаем:**

```
kubectl apply -f role.yaml
kubectl create rolebinding read-only-binding --role=read-only-role --user=developer --namespace=default
```

🚨 **Опасно:**

❌ **Не использовать kubectl create clusterrolebinding cluster-admin --user=dev** → это дает **полный доступ ко всему кластеру!**

---

**2️⃣ Безопасность контейнеров (Pod Security & Policies)**

  

✅ **Используй Pod Security Admission (PSA) или Pod Security Policies (PSP, устарело)**

• **Ограничивай привилегии контейнеров (privileged: false)**

• **Запрещай запуск от root (runAsNonRoot: true)**

• **Ограничивай доступ к хосту (volume mounts, hostNetwork, hostPID, hostIPC)**

  

📌 **Пример Pod Security Admission (PSA) для restricted уровня:**

```
apiVersion: policy/v1beta1
kind: PodSecurityPolicy
metadata:
  name: restricted
spec:
  privileged: false
  runAsUser:
    rule: MustRunAsNonRoot
  volumes:
    - "configMap"
    - "emptyDir"
    - "persistentVolumeClaim"
```

🚨 **Опасно:**

❌ Не запускать поды с securityContext.privileged: true (они могут получить доступ к ядру хоста).

---

**3️⃣ Сетевые политики (Network Policies)**

  

✅ **Запрещай межсервисные соединения по умолчанию**

• Kubernetes по умолчанию **не ограничивает сетевой трафик** между подами.

• **Используй Network Policies** для изоляции сервисов.

  

📌 **Пример запрета входящего трафика ко всем подам в default namespace:**

```
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all
  namespace: default
spec:
  podSelector: {}
  policyTypes:
  - Ingress
```

📌 **Как разрешить доступ только для frontend → backend?**

```
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-frontend-to-backend
  namespace: default
spec:
  podSelector:
    matchLabels:
      app: backend
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: frontend
```

🚨 **Опасно:**

❌ **Открытые сети между подами** → любой скомпрометированный сервис может атаковать другие.

---

**4️⃣ Контроль образов (Image Security)**

  

✅ **Проверяй и подписывай Docker-образы**

• **Используй cosign или Notary для подписи образов**

• **Сканируй образы на уязвимости (Trivy, Clair, Anchore)**

• **Запрещай запуск непроверенных образов (imagePullPolicy: Always)**

  

📌 **Как запретить запуск образов не из private-registry.com?**

```
apiVersion: policy/v1
kind: PodSecurityPolicy
metadata:
  name: restrict-registries
spec:
  allowedImages:
  - "private-registry.com/*"
```

🚨 **Опасно:**

❌ **Запускать образы latest** → невозможно контролировать версию и изменения.

❌ **Использовать образы с root правами** → уязвимость для атак.

---

**5️⃣ Безопасность Kubernetes API (Audit & Logging)**

  

✅ **Логируй все изменения в API-сервере**

• **Включи Audit Logging** (audit-policy.yaml)

• **Используй Falco для обнаружения атак**

  

📌 **Пример политики аудита в Kubernetes:**

```
apiVersion: audit.k8s.io/v1
kind: Policy
rules:
- level: RequestResponse
  resources:
  - group: ""
    resources: ["pods"]
  verbs: ["create", "delete", "patch"]
```

📌 **Применение политики аудита:**

```
kubectl apply -f audit-policy.yaml
```

🚨 **Опасно:**

❌ **Не логировать конфиденциальные данные (например, токены и секреты).**

❌ **Не игнорировать аномальные логи (например, массовые попытки входа).**

---

**6️⃣ Секреты и шифрование**

  

✅ **Используй безопасное хранилище для секретов**

• **Kubernetes Secrets + Encryption at Rest**

• **HashiCorp Vault / Sealed Secrets**

  

📌 **Как включить шифрование секретов в Kubernetes?**

```
apiVersion: apiserver.config.k8s.io/v1
kind: EncryptionConfiguration
resources:
  - resources:
      - secrets
    providers:
      - aescbc:
          keys:
            - name: key1
              secret: <base64-encoded-key>
```

📌 **Применение:**

```
kubectl apply -f encryption.yaml
```

🚨 **Опасно:**

❌ **Хранить секреты в ConfigMap** → они не зашифрованы!

❌ **Давать подам доступ к default ServiceAccount** → это риск утечки токенов.

---

**7️⃣ Обнаружение атак (Intrusion Detection & Runtime Security)**

  

✅ **Используй инструменты для обнаружения аномалий**

• **Falco** – мониторинг событий в реальном времени

• **KubeArmor** – блокировка подозрительных действий

• **Kubernetes Audit + SIEM** (Elasticsearch, Splunk)

  

📌 **Пример Falco-правила (запрет kubectl exec в продакшене):**

```
- rule: Detect kubectl exec
  desc: Someone is trying to exec into a pod
  condition: spawned_process and proc.name = "kubectl" and proc.args contains "exec"
  output: "User %user.name (uid=%user.uid) executed 'kubectl exec'"
  priority: WARNING
```

🚨 **Опасно:**

❌ **Не использовать инструменты мониторинга безопасности** → сложно обнаружить взлом.

❌ **Игнорировать runtime-security** → атаки могут происходить уже после деплоя.

---

**🎯 Итог**

|**Категория**|**Best Practice**|
|---|---|
|**RBAC (доступ)**|Минимальные привилегии, RoleBinding, избегать cluster-admin.|
|**Pod Security**|runAsNonRoot, privileged: false, readOnlyRootFilesystem.|
|**Сеть**|NetworkPolicy для изоляции сервисов.|
|**Контейнеры**|imagePullPolicy: Always, проверка образов (Trivy, Notary).|
|**API Security**|Включение **Audit Logging** и Falco.|
|**Secrets**|Kubernetes Secrets + шифрование **at rest**.|
|**Runtime Security**|Мониторинг событий (Falco, KubeArmor).|
