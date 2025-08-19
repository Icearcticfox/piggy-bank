
# 🧠 Наследование, инкапсуляция, полиморфизм

---

## 🧬 Наследование (Inheritance)

Позволяет создать новый класс на основе существующего.

```
class Animal:
    def speak(self):
        print("Animal speaks")

class Dog(Animal):  # Dog наследует Animal
    def speak(self):
        print("Woof!")

dog = Dog()
dog.speak()  # → Woof!
```

🔹 Ключевые моменты:

• Подкласс может переопределить методы родителя.

• super() позволяет вызвать метод родителя:

```
class Cat(Animal):
    def speak(self):
        super().speak()
        print("Meow!")
```

---
## 🔒 Инкапсуляция (Encapsulation)

Скрытие внутренней реализации объекта. В Python — через соглашения:

| **Префикс** | **Значение**                                              |
| ----------- | --------------------------------------------------------- |
| public      | без подчёркивания (self.x)                                |
| _protected  | с одним подчёркиванием (self._x) — по договорённости      |
| __private   | с двумя подчёркиваниями (self.__x) — “настоящее” сокрытие |

```
class User:
    def __init__(self, name):
        self.name = name           # public
        self._id = 123             # protected (не трогай без нужды)
        self.__password = "1234"   # private

    def get_password(self):
        return self.__password
```

---
## 🎭 Полиморфизм (Polymorphism)

Позволяет вызывать одинаковые методы у разных объектов — и получать разное поведение.

```
class Bird:
    def make_sound(self):
        print("Tweet")

class Cow:
    def make_sound(self):
        print("Moo")

def animal_sound(animal):
    animal.make_sound()

animal_sound(Bird())  # Tweet
animal_sound(Cow())   # Moo
```

