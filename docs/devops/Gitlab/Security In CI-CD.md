**🚀 Как защитить CI/CD пайплайн? Best Practices для DevOps**

CI/CD пайплайн – одна из самых уязвимых частей инфраструктуры, потому что **он имеет доступ ко всем компонентам продакшена**. Если злоумышленник скомпрометирует CI/CD, он сможет **выполнять код в проде, красть секреты и модифицировать образы**.

  

Разберем ключевые **best practices**, чтобы защитить CI/CD.

---

**1️⃣ Защита секретов в CI/CD**

  

**Проблема**: **Секреты в коде → утечка токенов и паролей**.

**Решение**: Используем **защищенные хранилища секретов**, а не .gitlab-ci.yml.

  

✅ **Как правильно?**

• **Использовать HashiCorp Vault / AWS Secrets Manager** для хранения API-ключей.

• **GitLab CI/CD → CI/CD Variables (masked, protected)**.

• **Не передавать секреты как аргументы команд (--password=secret)**.

  

📌 **Пример безопасного использования секретов в GitLab CI:**

```
deploy:
  script:
    - export DB_PASSWORD=$CI_DB_PASSWORD  # Переменная из GitLab CI/CD
    - ./deploy.sh
  variables:
    CI_DB_PASSWORD: "MASKED"  # Переменная не логируется в CI
```

🚨 **Опасно:**

❌ **Хранить пароли в коде (.gitlab-ci.yml)**.

❌ **Записывать секреты в логи CI/CD (echo $DB_PASSWORD)**.

---

**2️⃣ Ограничение прав в CI/CD**

  

**Проблема**: **GitLab Runner работает с root-доступом → может выполнять вредоносный код**.

**Решение**: **Ограничиваем права и доступ к Runner’ам**.

  

✅ **Как правильно?**

• **Запускать GitLab Runner в Kubernetes (gitlab-runner helm chart)**.

• **Ограничить права Runner’а (rootless CI/CD)**.

• **Использовать защищенные раннеры для production (protected runners)**.

  

📌 **Как назначить раннер только для protected branch?**

```
gitlab-runner register --locked --access-level=ref_protected
```

🚨 **Опасно:**

❌ **Использовать общий runner для всех разработчиков** → любой может изменить прод.

❌ **Запускать docker-in-docker (dind) без --privileged=false** → полный доступ к системе.

---

**3️⃣ Проверка кода перед деплоем (SAST, DAST, IaC Security)**

  

**Проблема**: **Уязвимости в коде и инфраструктуре → эксплойты, SQL-инъекции, RCE**.

**Решение**: **Автоматическая проверка кода перед развертыванием**.

  

✅ **Как правильно?**

• **SAST (Static Analysis Security Testing)** → SonarQube, GitLab SAST.

• **DAST (Dynamic Analysis Security Testing)** → OWASP ZAP, Nikto.

• **Проверка инфраструктуры (IaC Security)** → Checkov, tfsec, kube-score.

  

📌 **Пример интеграции SAST в GitLab CI:**

```
sast:
  stage: test
  script:
    - gitlab-sast-check
```

📌 **Пример проверки Terraform-кода на уязвимости:**

```
iac-security:
  stage: test
  script:
    - pip install checkov
    - checkov -d .
```

🚨 **Опасно:**

❌ **Не проверять код перед деплоем** → уязвимости попадают в прод.

❌ **Игнорировать сканирование инфраструктуры (tfsec, checkov)** → Terraform может создать дырку в безопасности.

---

**4️⃣ Подпись и верификация контейнеров**

  

**Проблема**: **Запуск непроверенных Docker-образов → supply chain атаки**.

**Решение**: **Подписывать образы и проверять их перед деплоем**.

  

✅ **Как правильно?**

• **Используем Sigstore Cosign / Notary для подписи контейнеров**.

• **Сканируем образы на уязвимости (Trivy, Clair, Anchore)**.

• **Запрещаем запуск непроверенных образов в Kubernetes (OPA/Gatekeeper)**.

  

📌 **Пример подписи образа с Cosign:**

```
cosign sign --key cosign.key myrepo/myapp:latest
cosign verify --key cosign.pub myrepo/myapp:latest
```

📌 **Как запретить неподписанные образы в Kubernetes (OPA/Gatekeeper)?**

```
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sPSPContainerAllowedImages
metadata:
  name: enforce-signed-images
spec:
  match:
    kinds:
      - apiGroups: [""]
        kinds: ["Pod"]
  parameters:
    allowedImages:
      - "myrepo.com/*"
```

🚨 **Опасно:**

❌ **Запускать latest без проверки версии**.

❌ **Не проверять уязвимости в образах (docker scan)**.

---

**5️⃣ Защита артефактов и кеша в CI/CD**

  

**Проблема**: **Артефакты билдов и кеши могут содержать чувствительные данные**.

**Решение**: **Ограничиваем доступ к артефактам и шифруем их**.

  

✅ **Как правильно?**

• **Очищаем артефакты после билда (expire_in)**.

• **Ограничиваем доступ к кешу (cache: policy: pull-only)**.

  

📌 **Пример очистки артефактов через 1 день:**

```
artifacts:
  expire_in: 1 day
```

📌 **Пример запрета загрузки кеша неавторизованными пользователями:**

```
cache:
  policy: pull-only
```

🚨 **Опасно:**

❌ **Хранить чувствительные данные в артефактах (например, .env файлы)**.

---

**6️⃣ Контроль доступа к CI/CD (Branch Protection & MR Rules)**

  

**Проблема**: **Любой разработчик может деплоить код в прод**.

**Решение**: **Настроить защиту веток и мерж-реквестов**.

  

✅ **Как правильно?**

• **Включаем защиту main / master (branch protection)**.

• **Ограничиваем, кто может делать merge (Code Owners)**.

• **Обязательный CI/CD pipeline перед мерджем (merge checks)**.

  

📌 **Как включить защиту ветки в GitLab?**

```
gitlab project settings → Protected Branches → Protect "main"
```

📌 **Как запретить merge без CI/CD проверки?**

```
only:
  - main
  - staging
```

🚨 **Опасно:**

❌ **Давать всем доступ к merge в main**.

❌ **Разрешать деплой без CI/CD-проверки**.

---

**🎯 Итог: Как защитить CI/CD?**

|**Категория**|**Best Practice**|
|---|---|
|**Секреты**|Использовать Vault, GitLab CI/CD Variables, Masked Variables|
|**Доступ**|Ограничить runner’ы, запретить root-права|
|**Сканирование**|Использовать SAST, DAST, Checkov, Trivy|
|**Образы**|Подписывать (cosign), сканировать, проверять OPA|
|**Артефакты**|Очищать (expire_in), запрещать pull из кэша|
|**Branch Protection**|Ограничить merge, проверять через MR|
