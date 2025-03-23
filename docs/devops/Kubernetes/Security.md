
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
