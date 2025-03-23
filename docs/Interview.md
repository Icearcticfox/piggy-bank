preparing to interview

resources:

1. https://github.com/Swfuse/devops-interview?tab=readme-ov-file

2. https://github.com/rmntrvn/adm_linux_ops_questions


### Terraform

1. **Что такое Terraform state?**

• State-файл (terraform.tfstate) хранит текущее состояние инфраструктуры и сопоставляет описанные в HCL ресурсы с реальными объектами в облаке.

• Это позволяет Terraform определять, какие изменения нужно внести при terraform apply.

2. **Где его хранят?**

• **Локально** (terraform.tfstate в рабочей директории) → не подходит для командной работы.

• **Удаленно** (S3, GCS, Azure Blob, Terraform Cloud) → позволяет совместную работу и контроль версий.

3. **Какие проблемы могут возникнуть?**

• **Конфликты при одновременной работе** → решается блокировками (dynamodb для S3 backend).

• **Компрометация чувствительных данных** → решается с terraform state encrypt, terraform_remote_state, использование vault.

• **Потеря state-файла** → если удален без бэкапа, теряется возможность управлять ресурсами Terraform.
	• Если state **удален**, но инфраструктура еще есть → **terraform import** поможет.
	• Если state удален **и инфраструктуры нет** → **потеряно безвозвратно**.
	• **Вывод:** **Обязательно настраивай бэкапы state-файлов!** (S3 + DynamoDB, GCS, Azure Blob).


---


**🚀 Terraform Workspaces: Что это и зачем они нужны?**  

**Terraform Workspaces** – это встроенный механизм управления **разными средами (environments)** в одном конфигурационном коде, без необходимости дублирования кода или создания отдельных Terraform проектов.

**1️⃣ Как это работает?**

• По умолчанию у Terraform есть **один workspace** → default.

• Можно создать **дополнительные workspace** для разных окружений:

```
terraform workspace new dev
terraform workspace new prod
```

  

• Каждому workspace соответствует **свой state-файл**, например:

• terraform.tfstate.d/dev/terraform.tfstate

• terraform.tfstate.d/prod/terraform.tfstate

• При переключении workspace Terraform **работает с разным state**, но использует **тот же 
HCL-код**.

---

**2️⃣ Когда использовать Terraform Workspaces?**

✅ **Когда надо управлять разными окружениями (dev, staging, prod) из одного кода.**

✅ **Когда хочется избежать дублирования кода (например, модули для разных клиентов).**

✅ **Когда хочется проще управлять state для разных инстансов.**

🚨 **Когда НЕ стоит использовать workspaces?**

• Workspaces **не подходят** для крупных проектов с разными инфраструктурами, т.к. state-файл все равно общий для всех workspace.

• Лучше использовать **отдельные backend-хранилища** для каждого окружения (terraform.backend).

---

**3️⃣ Практическое использование**

```
terraform workspace new staging  # Создаем workspace
terraform workspace list         # Список всех workspaces
terraform workspace select dev   # Переключаемся на dev
terraform workspace show         # Текущий workspace
```

**Как использовать workspace в коде Terraform?**

```
resource "aws_instance" "example" {
  count = terraform.workspace == "prod" ? 3 : 1  # В prod создаем 3 VM, в dev — 1
  ami   = "ami-123456"
}
```

  

---

**4️⃣ Альтернативы Workspaces**

• **Разные Terraform backend (например, отдельные S3-бакеты) для разных окружений.**

• **Модули и переменные вместо workspace.**

• **Terraform Cloud + separate workspaces для разных окружений.**


💡 **Вывод**:

Terraform Workspaces – удобный инструмент для управления окружениями, но в **энтерпрайз-проектах** лучше **разносить state по разным backend’ам**.



---
### Gitlab

**ключевые методы ускорения CI/CD** – **оптимизацию раннеров, распараллеливание и автоматизацию процессов**.
  

**1️⃣ Оптимизация GitLab Runners**

🚀 **Что делать, если пайплайн работает медленно из-за раннеров?**

• Использовать **выделенные** раннеры для разных проектов → **уменьшает конкуренцию за ресурсы**.

• Поднимать **авто-скейлинг GitLab Runners** в Kubernetes / AWS Auto Scaling.

• Если в пайплайне много CPU-интенсивных задач → использовать **GPU-оптимизированные раннеры**.

---

**2️⃣ Распараллеливание шагов**

🚀 **Что делать, если пайплайн долго выполняется?**

• **Разбить тесты на группы** и запускать их параллельно:

```
test:
  stage: test
  parallel: 5
  script:
    - run_tests --shard $CI_NODE_INDEX/$CI_NODE_TOTAL
```

📌 Это позволяет запускать **5 тестовых джобов одновременно**.

• Запускать **разные стадии в одном пайплайне параллельно**, если между ними нет зависимостей:

```
stages:
  - build
  - test
  - deploy

build-job:
  stage: build
  script: make build

test-job:
  stage: test
  needs: ["build-job"]
  script: pytest
```

📌 **needs** указывает, что job **test-job** стартует сразу после **build-job**, **не дожидаясь завершения всех билдов**.

---

**3️⃣ Использование кэширования (cache & artifacts)**

🚀 **Что делать, если одни и те же зависимости скачиваются в каждом пайплайне?**

• Использовать **кэширование зависимостей**:

```
cache:
  key: $CI_COMMIT_REF_SLUG
  paths:
    - .venv/
    - node_modules/
```

📌 Это **сохраняет зависимости между джобами**, сокращая их время выполнения.

• Использовать **артефакты** для передачи артефактов между стадиями:

```
build-job:
  stage: build
  script:
    - make build
  artifacts:
    paths:
      - build/output
```

📌 Это **уменьшает дублирование**, т.к. не нужно пересобирать билды.

---

**4️⃣ Оптимизация триггеров и условий запуска**

🚀 **Что делать, если пайплайн запускается слишком часто?**

• **Пропускать ненужные джобы**, если код не изменился:

```
only:
  changes:
    - src/*
```

📌 Джоб запустится **только если изменились файлы в src/**.

• **Использовать merge trains (Авто-мержи в мастер)** → сокращает количество пайплайнов.

---

**5️⃣ Оптимизация образов Docker**

🚀 **Что делать, если билды и деплои занимают много времени?**

• Использовать **базовые образы**, а не тянуть всё с нуля:

```
image: python:3.10
```

📌 GitLab использует **готовый кэшированный образ**, а не собирает его заново.

• Использовать **многоступенчатую сборку (multi-stage builds)** в Docker:

```
FROM node:16 AS builder
WORKDIR /app
COPY . .
RUN npm install && npm run build

FROM nginx:latest
COPY --from=builder /app/build /usr/share/nginx/html
```

📌 Это **уменьшает размер контейнера** и ускоряет деплой.

---

**🎯 Итог**

  

✅ **Если проблема в медленных раннерах** → **используем выделенные раннеры, авто-скейлинг**.

✅ **Если долго выполняются джобы** → **распараллеливаем тесты, билды, деплои**.

✅ **Если много лишних перезапусков** → **ограничиваем триггеры в .gitlab-ci.yml**.

✅ **Если долго скачиваются зависимости** → **используем кэширование и артефакты**.

✅ **Если долго билдится Docker** → **многоступенчатая сборка, базовые образы**.

  

💡 **Если хочешь выделиться, можешь упомянуть GitOps и ArgoCD для оптимизации деплоя в Kubernetes.**

---

### Kubernetes

🔹 **Как Kubernetes управляет масштабированием? Какие механизмы есть и когда их лучше применять?**

Отлично, ты уже знаешь базовые механизмы масштабирования в Kubernetes! Давай разберем их подробнее, чтобы ты мог **на интервью рассказать структурированно и с примерами**.

---

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

---

**➡️ Следующий вопрос: Kubernetes Security**

  

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
