# Projeto GuillimanNet — Análise Financeira e Inadimplência
## Visão Geral

O GuillimanNet é um projeto de Business Intelligence desenvolvido com SQL Server e Power BI, utilizando dados de cobranças (CSV) de um provedor de internet. O objetivo é analisar a saúde financeira do negócio, identificar padrões de inadimplência e apoiar a tomada de decisão por meio de dashboards interativos.

Os dados utilizados foram anonimizados, preservando a estrutura e a lógica de negócio, em conformidade com boas práticas de governança e LGPD.

## Objetivos do Projeto

* Analisar receita mensal recebida e valores em aberto

* Calcular taxa de inadimplência e sua evolução ao longo do tempo

* Avaliar desempenho financeiro por plano

* Identificar clientes com maior recorrência de atraso

* Analisar crescimento mensal da receita

* Criar um dashboard claro, intuitivo e orientado a métricas de negócio

## Tecnologias Utilizadas

* SQL Server (modelagem, views e análises)

* Power BI (visualização e DAX)

* DAX (medidas e cálculos analíticos)

* CSV (fonte de dados)

* Modelagem Dimensional (Star Schema)

GuillimanNet/
│
├── data/
│   └── cobrancas_anonimizadas.csv
│
├── sql/
│   ├── ViewsGuillimanNet.sql
│   ├── BulkInsert.sql
│
├── powerbi/
│   ├── Dashboard GuillimanNet.pbix
│   └── screenshots/
│       ├── dashboard.png
│       └── StarSchema.png
│
└── README.md

## Principais Métricas e Análises

* Receita total e receita mensal

* Valor total em aberto

* Taxa de inadimplência

* Crescimento mensal da receita

* Distribuição de pagamentos (em dia, atrasados, adiantados)

* Desempenho financeiro por plano

* Clientes com maior número de atrasos

## Dashboard

* O dashboard foi desenvolvido no Power BI com foco em:

* Visual limpo e objetivo

* KPIs financeiros claros

* Análises temporais e comparativas

* Facilidade de interpretação para tomada de decisão

Prints do dashboard e do modelo de dados estão disponíveis na pasta /powerbi/screenshots
