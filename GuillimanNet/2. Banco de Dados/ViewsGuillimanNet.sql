--====DIMENSAO PLANOS======

CREATE OR ALTER VIEW DimPlanos AS
SELECT
    CASE
        WHEN Valor = 60 THEN 'Velho'
        WHEN Valor = 70 THEN 'Básico'
        WHEN Valor = 80 THEN 'Turbo Lite'
        WHEN Valor = 90 THEN 'Mega Plus'
        WHEN Valor = 100 THEN 'Ultra Connect'
        WHEN Valor >= 110 THEN 'Interstellar'
        ELSE 'Desconhecido'
    END AS NomePlano,
    MIN(Valor) AS ValorMensal
FROM Cobrancas
GROUP BY
    CASE
        WHEN Valor = 60 THEN 'Velho'
        WHEN Valor = 70 THEN 'Básico'
        WHEN Valor = 80 THEN 'Turbo Lite'
        WHEN Valor = 90 THEN 'Mega Plus'
        WHEN Valor = 100 THEN 'Ultra Connect'
        WHEN Valor >= 110 THEN 'Interstellar'
        ELSE 'Desconhecido'
    END
GO

--=====DIMENSAO CLIENTES=====

CREATE OR ALTER VIEW DimClientes AS
SELECT
    ROW_NUMBER() OVER (ORDER BY Cliente) AS IdCliente,
    Cliente,
    MAX(
        CASE
            WHEN Valor = 60 THEN 'Velho'
            WHEN Valor = 70 THEN 'Básico'
            WHEN Valor = 80 THEN 'Turbo Lite'
            WHEN Valor = 90 THEN 'Mega Plus'
            WHEN Valor = 100 THEN 'Ultra Connect'
            WHEN Valor >= 110 THEN 'Interstellar'
            ELSE 'Desconhecido'
        END
    ) AS PlanoAtual
FROM Cobrancas
GROUP BY Cliente
GO

--====DIMENSAO DATAS======

CREATE OR ALTER VIEW DimDatas AS
SELECT DISTINCT
    CAST(Vencimento AS DATE) AS Data,
    YEAR(Vencimento) AS Ano,
    MONTH(Vencimento) AS Mes,
    DATENAME(MONTH, Vencimento) AS NomeMes,
    DATEPART(QUARTER, Vencimento) AS Trimestre
FROM Cobrancas
GO

--====FATO COBRANCAS=======

CREATE OR ALTER VIEW FatoCobrancas AS
SELECT
    ROW_NUMBER() OVER (ORDER BY Cliente, Vencimento) AS IdCobranca,
    Cliente,
    CAST(Vencimento AS DATE) AS DataVencimento,
    CAST(Credito AS DATE) AS DataPagamento,
    Valor,
    Pago,
    CASE
        WHEN Pago = 0 THEN 'Aberto'
        WHEN Credito > Vencimento THEN 'Antecipado'
        WHEN Credito = Vencimento THEN 'Em Dia'
        WHEN Credito < Vencimento THEN 'Atrasado'
    END AS StatusPagamento,
    CASE
        WHEN Valor = 60 THEN 'Velho'
        WHEN Valor = 70 THEN 'Básico'
        WHEN Valor = 80 THEN 'Turbo Lite'
        WHEN Valor = 90 THEN 'Mega Plus'
        WHEN Valor = 100 THEN 'Ultra Connect'
        WHEN Valor >= 110 THEN 'Interstellar'
        ELSE 'Desconhecido'
    END AS NomePlano
FROM Cobrancas
GO