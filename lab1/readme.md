# Лабораторная работа 1

## Выполнил: Anisimov Victor

## Группа: IA2403

### Численные методы приближённого вычисления корня. 

В данной лабораторной работе представлены реализации численных методов на python.

Список методов: 
 - Метод деления отрезка пополам
 - Метод хорд
 - Метод Ньютона (метод касательных)
 - Метод простой итерации

### Анализ результатов методов 
 - Для фукнции `log(x/4) + 4*sin(3*x) + 1` :
 
        Borders: [1.051, 2]     | E = 1e-06
        -------------------------------\
        no root (or even amount of roots)
        0.0000269 sec.

        no root (or even amount of roots)
        0.0000129 sec.

        no root (or even amount of roots)
        0.0000138 sec.

        no root (or even amount of roots)
        0.0000088 sec.

        -------------------------------/

        Borders: [1.1, 2.09]    | E = 1e-06
        -------------------------------\

                method_half:
        left border: 2.0660802745819096
        right border: 2.0660812187194826
        iterations: 20
        0.0001268 sec.

                method_hord:
        root ≈ 2.0660811187926447
        iterations: 4
        0.0000582 sec.

                method_newton:
        root ≈ 2.0660811268025423
        iterations: 3
        0.0000460 sec.

                method_easy_itteration:
        root ≈ 2.0660807662865697
        iterations: 50
        0.0002038 sec.

        -------------------------------/

        Borders: [3.142, 4]     | E = 1e-06
        -------------------------------\

                method_half:
        left border: 3.2069283409118654
        right border: 3.206929159164429
        iterations: 20
        0.0000849 sec.

                method_hord:
        root ≈ 4.102386298346071
        iterations: 7
        0.0000741 sec.

                method_newton:
        root ≈ 3.2069284775294813
        iterations: 3
        0.0000432 sec.

                method_easy_itteration:
        root ≈ 3.206928019754852
        iterations: 131
        0.0002251 sec.

        -------------------------------/

        Borders: [3.3, 4.18]    | E = 1e-06
        -------------------------------\

                method_half:
        left border: 4.1023860168457045
        right border: 4.102386856079103
        iterations: 20
        0.0000901 sec.

                method_hord:
        root ≈ 4.102386316289548
        iterations: 6
        0.0000703 sec.

                method_newton:
        root ≈ 4.102386321561076
        iterations: 3
        0.0000439 sec.

                method_easy_itteration:
        root ≈ 4.1023859981770805
        iterations: 34
        0.0000761 sec.

        -------------------------------/

- Для функции `x**6 -5.5*x**5 + 6.18*x**4 + 18.54*x**3 - 56.9592*x**2 + 55.9872*x - 19.3156`: 

        Borders: [-3, -1.5]     | E = 1e-06
        -------------------------------\

                method_half:
        left border: -2.3000006675720215
        right border: -2.299999952316284
        iterations: 21
        0.0002298 sec.

                method_hord:
        root ≈ -2.3000000174043795
        iterations: 37
        0.0004768 sec.

                method_newton:
        root ≈ -2.300000018951008
        iterations: 6
        0.0000870 sec.

                method_easy_itteration:
        root ≈ -2.299999382540187
        iterations: 17
        0.0000870 sec.

        -------------------------------/

        Borders: [1.8, 4]       | E = 1e-06
        -------------------------------\

                method_half:
        left border: 1.8215782642364504
        right border: 1.8215787887573245
        iterations: 22
        0.0001228 sec.

                method_hord:
        root ≈ 1.8000000669295662
        iterations: 1
        0.0000441 sec.

                method_newton:
        root ≈ 1.8215785110473244
        iterations: 19
        0.0001438 sec.

                method_easy_itteration:
        root ≈ 1.8687192551053484
        iterations: 28985
        0.0800569 sec.

        -------------------------------/



| Метод           | Средняя скор. (сек) | Средняя устойчивость | Комментарий                                              |
| --------------- | ------------------- | -------------------- | -------------------------------------------------------- |
| Ньютона         | ~0.00006            | Очень высокая        | Оптимальный метод, если производная проста               |
| Хорд            | ~0.00007            | Средняя              | Хорош для нелинейных уравнений без нужды в производной   |
| Бисекции        | ~0.00012            | Высокая              | Надёжная, но медленная                                   |
| Прост. итерация | 0.0001–0.08         | Низкая               | Зависит от выбора φ(x); часто неэффективна               |

### Запуск проекта: 
**if user.isNixUser():** \
В данной папке выполнить: 
```bash 
nix develop 
python lab1.py 
```
**else :**
        
Перейдите в папку с проектом:

```bash
cd /путь/к/проекту
```

Создайте и активируйте виртуальное окружение:

```bash
python -m venv .venv
source .venv/bin/activate      # Linux/macOS
# .venv\Scripts\activate       # Windows
```

Установите зависимости:

```bash
pip install sympy
```

Запустите:

```bash
python lab1.py
```

Версия python - 3.13