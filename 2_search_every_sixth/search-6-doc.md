# 🔎 SEARCH-6  

Программа на **TASM**, которая обрабатывает введённый пользователем текст:  
- выбирает **каждое шестое слово**;  
- **седьмое слово** из этого набора записывается в буфер в обратном порядке (буквы инвертируются);  
- результат выводится на экран и сохраняется в файл `search-6.txt`.  

---

## ⚙️ Компиляция и запуск
```bash
tasm search-6-2.asm
tlink search-6-2.obj
search-6-2.exe
```

---

## 📌 Пример работы
```
Enter some words separated by space: one two three four five six seven eight nine ten eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen
Selected words:
six neveS twelve eighteen$
```

(в примере седьмое слово `Seven` инвертировано → `neveS`)  

Результат также сохраняется в файл `search-6.txt`.  

---

## 📂 Структура программы
- `meeting` — процедура для приглашения и ввода текста.  
- `revers` — поиск седьмого слова среди выбранных и инверсия его букв.  
- `counter` — подсчёт длины результирующей строки.  
- Основной блок — логика выбора каждого шестого слова и запись результата в файл.  

---

## 📊 Сравнительный анализ версий

### 🔸 Первая версия (**search-6 (1).asm**, ~6 месяцев назад)  
- Вся логика была собрана в **один монолитный блок** с большим количеством меток (`proverka`, `copy_word`, `vozvrat` и т. д.).  
- Работала корректно, но код был трудночитаемым и тяжёлым для отладки.  
- Запись в файл уже присутствовала, что делало программу практичной.  
- Минусы:  
  - нет разбиения на процедуры;  
  - перемешаны ввод, обработка и вывод;  
  - трудно масштабировать.  

### 🔹 Вторая версия (**search-6-2.asm**, текущая)  
- Логика разделена на **процедуры**: ввод, инверсия, подсчёт.  
- Код стал **структурированным и модульным**, легче читать и дорабатывать.  
- Чётко прослеживается алгоритм: ввод → выбор 6-х слов → инверсия 7-го → вывод → запись в файл.  
- По сути, это уже «чистый код» по сравнению с ранней попыткой.  

---

## ✅ Итог
За полгода твой стиль сильно изменился:  
- от «рабочего комбайна» → к **структурированному и модульному коду**;  
- теперь программа не только работает, но и легко поддерживается/расширяется.  


---

# 🔎 SEARCH-6  

A **TASM** program that processes user input text:  
- selects **every sixth word**;  
- the **seventh word** from this set is written in reverse order (letters inverted);  
- the result is displayed on the screen and saved into the file `search-6.txt`.  

---

## ⚙️ Compilation and Run
```bash
tasm search-6-2.asm
tlink search-6-2.obj
search-6-2.exe
```

---

## 📌 Example Output
```
Enter some words separated by space: one two three four five six seven eight nine ten eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen
Selected words:
six neveS twelve eighteen$
```

(in this example, the seventh word `Seven` was reversed → `neveS`)  

The result is also saved into `search-6.txt`.  

---

## 📂 Program Structure
- `meeting` — procedure for prompting and reading input.  
- `revers` — searches for the seventh word among selected ones and reverses its letters.  
- `counter` — counts the length of the resulting string.  
- Main block — logic for selecting every sixth word and writing the result into the file.  

---

## 📊 Comparative Analysis of Versions

### 🔸 First version (**search-6 (1).asm**, ~6 months ago)  
- All logic was combined into **one monolithic block** with many labels (`proverka`, `copy_word`, `vozvrat`, etc.).  
- It worked correctly but the code was hard to read and debug.  
- File writing was already implemented, making the program practical.  
- Cons:  
  - no procedural decomposition;  
  - input, processing and output were mixed together;  
  - hard to extend.  

### 🔹 Second version (**search-6-2.asm**, current)  
- Logic is split into **procedures**: input, reversing, counting.  
- Code is **structured and modular**, easier to read and maintain.  
- Clear algorithm: input → select 6th words → reverse 7th → display → save to file.  
- Essentially, it’s already "clean code" compared to the earlier attempt.  

---

## ✅ Conclusion
In six months your coding style has evolved:  
- from a "working monolith" → to **structured and modular code**;  
- now the program not only works but is also easy to maintain and extend.  
