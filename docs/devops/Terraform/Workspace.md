
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