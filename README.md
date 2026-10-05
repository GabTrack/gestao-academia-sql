# Projeto de Banco de Dados MySQL

Este repositório contém o script completo de modelagem, povoamento e consultas analíticas para o sistema de gestão de treinos e pagamentos.

## 🛠️ Tecnologias Utilizadas
* **SGBD:** MySQL
* **Ferramenta:** MySQL Workbench / DBeaver

## 📁 Estrutura dos Scripts
1. `01_estrutura.sql`: Criação das tabelas e chaves primárias/estrangeiras.
2. `02_dados.sql`: Inserção de dados de teste.
3. `03_consultas.sql`: Consultas analíticas (`JOIN`, `GROUP BY`, `HAVING`, `NOT EXISTS`).
4. `04_procedures.sql`: Stored Procedures e rotinas automatizadas.

## 🚀 Como Executar
1. Clone este repositório.
2. Execute os ficheiros em ordem num cliente MySQL:
   ```bash
   mysql -u utilizador -p banco_dados < 01_estrutura.sql
   mysql -u utilizador -p banco_dados < 02_dados.sql
   ```