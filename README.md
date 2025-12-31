# Análise Descritiva de Dados — Loja Online  

##  Visão Geral

Este projeto apresenta uma análise descritiva completa de uma loja online fictícia.  
O banco de dados foi modelado, criado e populado no MySQL, onde todas as consultas e análises foram realizadas em SQL.  

Algumas consultas foram exportados para o Google Colab, onde foram gerados gráficos em Python utilizando matplotlib, seaborn e pandas.

Para tomada de decisões, foi elaborado um relatório no Power BI, abordando vários temas para visualição (visão geral, clientes, produtos, localidades).

O objetivo é explorar métricas de vendas, clientes e produtos de forma visual e interpretável, aplicando técnicas típicas de um analista de dados.  


##  Estrutura do Projeto

analise-descritiva-loja-online/

├── dashboards/ # Relatório em pbix e pdf

├── data/ # Arquivos brutos e tratados em formato CSV exportados das consultas

├── images/ # Gráficos gerados (matplotlib / seaborn)

├── notebooks/ # Notebook com alguns gráficos (Colab)

├── sql/ # Construção, inserção e consultas

├── requirements.txt # Bibliotecas utilizadas


O projeto segue um fluxo simples: consultas SQL → exportação dos resultados → relatório no Power BI / gráficos em Python.  

## Tecnologias Utilizadas

**Banco de Dados**
- MySQL — criação, inserção e consultas dos dados

**Linguagem e Bibliotecas**
- Python — análise e visualização de dados  
- Pandas — leitura e manipulação dos arquivos CSV  
- Matplotlib — geração de gráficos  
- Seaborn — complementação visual dos gráficos

**Ambiente**
- Google Colab — execução e visualização dos notebooks
- Power BI - elaboração do relatório de overview para tomada de decisões


## Como Executar o Projeto 

1. Clone o repositório e instale as dependências do arquivo `requirements.txt`.  

2. Crie o banco de dados executando o script SQL da pasta `/sql`.  

3.
  3.1 Abra o notebook da pasta `/notebooks` no Google Colab para visualizar os gráficos ligeiramente elaborados
  ou
  3.2 Abra o arquivo overview_loja_online.pbix ou o arquivo em PDF.


## Sobre o Projeto

Este projeto foi desenvolvido com o objetivo de praticar e demonstrar habilidades de análise de dados descritiva usando SQL, Python e ferramentas de visualização.  
Todo o processo foi feito do zero — desde a modelagem e criação do banco de dados MySQL, até a geração de consultas analíticas e visualização dos resultados em gráficos.

As consultas SQL foram usadas para identificar padrões, como:
- Clientes que mais gastaram;
- Produtos e categorias mais vendidos;
- Cidades com maior volume de compras;
- Evolução das vendas ao longo do tempo;
- Ticket Médio por unidade federativa.

## Contato 

Sinta-se à vontade para entrar em contato comigo ou conhecer outros projetos:  
- [LinkedIn] (https://www.linkedin.com/in/mitsuyoshijunior/)  
- [GitHub] (https://github.com/mitsuyoshijunior)  
- Email: mitsuyoshijunior@gmail.com
