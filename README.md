# Truthtables for LaTeX

[![Unit testing with Dockerfile](https://github.com/kieferro/truthtablesLuaTex/actions/workflows/unittesting.yaml/badge.svg?event=push)](https://github.com/kieferro/truthtablesLuaTex/actions/workflows/unittesting.yaml)

## Order of precedence

| Operator           | Name | Precedence |
| ------------------ | ---- | ---------- |
| $\neg$             | NOT  | 1          |
| $\land$            | AND  | 2          |
| $\lor$             | OR   | 3          |
| $\Rightarrow$      | IF   | 4          |
| $\Leftarrow$       | RIF  | 5          |
| $\Leftrightarrow$  | EQU  | 6          |
| $\overline{\land}$ | NAND | 7          |
| $\overline{\lor}$  | NOR  | 8          |
| $\veebar$          | XOR  | 9          |
