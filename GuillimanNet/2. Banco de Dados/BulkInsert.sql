
CREATE TABLE Cobrancas(
	ID INT IDENTITY (1, 1),
	Cliente VARCHAR(100),
	Vencimento DATE,
	Credito DATETIME,
	Total FLOAT,
	Pago FLOAT
	--==================================
	CONSTRAINT ultranette_id_cliente_pk PRIMARY KEY (ID)
)

BULK INSERT Cobrancas 
FROM 'C:\Users\guilh\Downloads\Cobrancas Ultranette.csv'
WITH(
	FIELDTERMINATOR = ';',
	ROWTERMINATOR = '0x0A',
	FIRSTROW = 2
)

SELECT
	Cliente,
	Vencimento,
	Credito,
	Valor,
	Pago,
	CASE 
		WHEN Vencimento > CAST(Credito AS DATE) THEN 'Pagamento Adiantado'
		WHEN Vencimento = CAST(Credito as DATE) THEN 'Pagou no dia'
		ELSE 'Pagamento Atrasado'
	END AS 'Pagamentos'
FROM
	Cobrancas
WHERE
	Vencimento > Credito

SELECT DISTINCT Cliente FROM Cobrancas

--============================================================================
GO

-- TABELA COM TOTAL A RECEBER, TOTAL RECEBIDO, DIFERENÇA E DESVIO PADRÃO
SELECT
	YEAR(Credito) AS 'ANO',
	MONTH(Credito) AS 'MES',
	CONCAT('R$ ', FORMAT(STDEV(Pago), 'N2')) AS 'DESVIO PADRÃO',
	CONCAT('R$ ', FORMAT(SUM(Valor), 'N2')) AS 'TOTAL COBRADO',
	CONCAT('R$ ', FORMAT(SUM(Pago), 'N2')) AS 'TOTAL PAGO',
	CONCAT('R$ ', FORMAT(SUM(Pago) - SUM(Valor), 'N2')) AS 'DIFERENÇA'
FROM
	Cobrancas
GROUP BY 
	MONTH(Credito), YEAR(Credito)
ORDER BY MES

GO
DROP VIEW vwReceita
--CLIENTE, TOTAL DE COBRANÇAS, PAGAMENTOS ATRASADOS, PAGAMENTOS EM DIA, ANTES DA DATA

SELECT DISTINCT Cliente FROM Cobrancas
ORDER BY Cliente

SELECT 
    COUNT(*) AS 'Total Cobrancas',
    SUM(CASE WHEN Vencimento < CAST(Credito AS DATE) THEN 1 ELSE 0 END) AS 'Pagamentos Atrasados',
	SUM(CASE WHEN Vencimento = CAST(Credito AS DATE) THEN 1 ELSE 0 END) AS 'Pagamentos em dia',
	SUM(CASE WHEN Vencimento > CAST(Credito AS DATE) THEN 1 ELSE 0 END) AS 'Antes da Data',
    SUM(CASE WHEN Pago = 0 THEN 1 ELSE 0 END) AS 'Ainda Em Aberto',
	MIN(Valor) AS 'Valor',
	CONCAT('R$ ', FORMAT(SUM(Valor), 'N2')) AS 'Lucro por Cliente',
	CASE
		WHEN Valor = 60 THEN 'Velho'
		WHEN Valor = 70 THEN 'Básico'
		WHEN Valor = 80 THEN 'Turbo Lite'
		WHEN Valor = 90 THEN 'Mega Plus'
		WHEN Valor = 100 THEN 'Ultra Connect'
		WHEN Valor = 110 THEN 'Interstellar'
		ELSE 'Desconhecido'
    END AS 'Plano'
FROM Cobrancas
WHERE Valor IN (60, 70, 80, 90, 100, 110)
GROUP BY
	CASE
		WHEN Valor = 60 THEN 'Velho'
		WHEN Valor = 70 THEN 'Básico'
		WHEN Valor = 80 THEN 'Turbo Lite'
		WHEN Valor = 90 THEN 'Mega Plus'
		WHEN Valor = 100 THEN 'Ultra Connect'
		WHEN Valor = 110 THEN 'Interstellar'
		ELSE 'Desconhecido'
    END, Valor
ORDER BY Valor

-- =====SELECT CORRIGIDO=====
GO
CREATE VIEW vwEsquemadeCobrancas AS
SELECT 
    Cliente,
    COUNT(*) AS 'Total Cobrancas',
    SUM(CASE WHEN Vencimento < CAST(Credito AS DATE) THEN 1 ELSE 0 END) AS 'Pagamentos Atrasados',
	SUM(CASE WHEN Vencimento = CAST(Credito AS DATE) THEN 1 ELSE 0 END) AS 'Pagamentos em dia',
	SUM(CASE WHEN Vencimento > CAST(Credito AS DATE) THEN 1 ELSE 0 END) AS 'Antes da Data',
    SUM(CASE WHEN Pago = 0 THEN 1 ELSE 0 END) AS 'Ainda Em Aberto',
	CONCAT('R$ ', FORMAT(SUM(Valor), 'N2')) AS 'Lucro por Cliente'
FROM Cobrancas
GROUP BY Cliente
GO
--=======KPIS========

SELECT * FROM Cobrancas
GO
CREATE VIEW vwKPIS AS
SELECT
	CONCAT('R$ ', FORMAT(SUM(Pago) , 'N2')) AS 'Receita Total',
	CONCAT('R$ ', FORMAT(SUM(Valor) - SUM(Pago), 'N2')) AS 'Valor a receber',
	CONCAT(AVG(DATEDIFF(DAY, Vencimento, Credito)), ' Dias') AS 'Tempo medio de pagamento',
	COUNT(CASE WHEN Pago < Valor THEN 1 END) AS 'Taxa de inadimplência'
FROM
	Cobrancas
GO

--=======FIM KPIS=====


--PROCEDURE PARA CONSULTA INDIVIDUAL DE COBRANÇA DE CLIENTES
GO
CREATE OR ALTER PROCEDURE prConsultaCliente(@nome VARCHAR(100))
AS
BEGIN
	SELECT
		*,
		CASE 
			WHEN Vencimento > CAST(Credito AS DATE) THEN 'Antes da Data'
			WHEN Vencimento = CAST(Credito as DATE) THEN 'Pagou no dia'
			WHEN Credito IS NULL THEN 'Proximo mês'
			ELSE 'Atrasado'
		END AS 'Pagamentos'
	FROM Cobrancas
	WHERE Cliente = @nome
	ORDER BY Vencimento
END

EXECUTE prConsultaCliente 'ALENCAR NET'

SELECT * FROM Cobrancas
--======FIM DA PROCEDURE=============