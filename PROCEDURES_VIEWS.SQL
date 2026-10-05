/* 
======================================================
  PROJETO: GESTÃO DE ACADEMIA
  ARQUIVO: 04_procedures_views.sql
  OBJETIVO: Regras de Negócio, Automações e Relatórios Salvos
======================================================
*/

USE ACADEMIA;

-- ======================================================
-- 1. VIEWS (RELATÓRIOS SALVOS)
-- ======================================================

-- View 1: Resumo Financeiro com Status do Aluno
CREATE OR REPLACE VIEW VW_RESUMO_FINANCEIRO_ALUNO AS
SELECT 
    A.IDALUNO,
    A.NOME,
    A.EMAIL,
    SUM(IFNULL(P.VALOR, 0)) AS TOTAL_PAGO,
    CASE 
       WHEN SUM(IFNULL(P.VALOR, 0)) >= 200 THEN 'CLIENTE PREMIUM'
       WHEN SUM(IFNULL(P.VALOR, 0)) > 0 THEN 'CLIENTE ATIVO'
       ELSE 'SEM PAGAMENTO'
    END AS CATEGORIA_CLIENTE
FROM ALUNO A
LEFT JOIN PAGAMENTO P ON A.IDALUNO = P.ID_ALUNO
GROUP BY A.IDALUNO, A.NOME, A.EMAIL;

-- View 2: Relatório de Inadimplência (> 30 dias sem pagamento ou nunca pagaram)
CREATE OR REPLACE VIEW VW_ALUNOS_INADIMPLENTES AS
SELECT 
    A.NOME,
    A.EMAIL,
    MAX(P.DATA) AS ULTIMO_PAGAMENTO
FROM ALUNO A
LEFT JOIN PAGAMENTO P ON A.IDALUNO = P.ID_ALUNO
GROUP BY A.IDALUNO, A.NOME, A.EMAIL
HAVING MAX(P.DATA) IS NULL 
    OR MAX(P.DATA) < CURDATE() - INTERVAL 30 DAY;

-- View 3: Total Arrecadado por Aluno (Filtrado para pagantes Acima de R$ 300)
CREATE OR REPLACE VIEW VW_TOP_PAGANTES AS
SELECT 
    A.NOME,
    A.EMAIL,
    P_TOTAL.TOTAL
FROM ALUNO A
INNER JOIN (
    SELECT ID_ALUNO, SUM(VALOR) AS TOTAL
    FROM PAGAMENTO
    GROUP BY ID_ALUNO
) P_TOTAL ON A.IDALUNO = P_TOTAL.ID_ALUNO
WHERE P_TOTAL.TOTAL > 300;

-- ======================================================
-- 2. STORED PROCEDURES
-- ======================================================

DELIMITER //

-- Procedure 1: Retorna a lista de professores que possuem uma quantidade exata de alunos ativos
CREATE PROCEDURE SP_PROFESSORES_POR_QTD_ALUNOS (IN QTDE_ALUNO_PROF INT)
BEGIN
    SELECT 
        P.NOME AS PROFESSOR,
        COUNT(DISTINCT T.ID_ALUNO) AS TOTAL_ALUNOS     
    FROM PROFESSOR P
    INNER JOIN TREINO T ON P.IDPROFESSOR = T.ID_PROFESSOR
    GROUP BY P.NOME
    HAVING TOTAL_ALUNOS = QTDE_ALUNO_PROF;
END//

-- Procedure 2: Retorna o total de alunos que já realizaram pelo menos um pagamento
CREATE PROCEDURE SP_CONTAGEM_ALUNOS_PAGANTES (OUT QTDE_ALUNOS INT)
BEGIN
    SELECT COUNT(DISTINCT ID_ALUNO) INTO QTDE_ALUNOS
    FROM PAGAMENTO;
END//

DELIMITER ;