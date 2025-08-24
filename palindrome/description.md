# PALIND.ASM – Palindrome Checker in Assembly

## Overview
`PALIND.ASM` is a 16-bit DOS program written in **TASM**, which checks whether the entered string is a **palindrome**.  
The program works interactively: after each check, the user can decide to continue or exit.

## Features
- Input a word or phrase (up to 80 characters).
- Palindrome detection works **ignoring spaces**.
- Interactive mode:
  - After the result, the user is asked whether to continue (`Y/N`).
  - Both uppercase and lowercase answers are accepted.
- Uses DOS interrupts (`INT 21h`) for I/O.
- Implemented with string operations and manual pointer handling.

## Example Run
```bash
Enter your word (or string): qw
The string is NOT a palindrome.
Do you want to check another word? (Y(es) or N(o)): y

Enter your word (or string): lel
The string IS a palindrome.
Do you want to check another word? (Y(es) or N(o)): y

Enter your word (or string): a man a plan a canal panama
The string IS a palindrome.
Do you want to check another word? (Y(es) or N(o)): n
```

## How It Works
1. Program asks for input string.
2. The entered string is read into a buffer.
3. Spaces (`0x20`) are skipped during comparison.
4. The algorithm compares characters from the **start** and the **end** of the string.
5. If all pairs match → string is a palindrome. Otherwise → not a palindrome.
6. User is asked whether to check another word.

## File Structure
- **msg, msg1, msg2, msg3** – output messages.
- **buffer** – stores user input.
- **meeting** – procedure to read input string.
- **cont** – procedure to check if user wants to continue (`Y/N`).

## Limitations
- Case sensitivity: `A` and `a` are treated as **different** (improvement possible).
- Punctuation is not ignored.
- Empty string is treated as *not palindrome*.

## Requirements
- TASM / MASM assembler.
- DOSBox or real DOS environment.

