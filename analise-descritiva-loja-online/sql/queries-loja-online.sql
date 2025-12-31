USE loja_online;

# CONSULTAS SOBRE PRODUTOS

-- Produtos da categoria "Eletrônicos", do mais caro para o mais barato
SELECT p.produto AS Produto, p.preco AS Preco
FROM produtos AS p 
WHERE p.id_categoria IN (SELECT id FROM categorias WHERE categoria = 'Eletrônicos')
ORDER BY Preco DESC;

-- Quais são os 15 produtos mais vendidos até hoje?
SELECT p.produto AS Produto, SUM(pe_p.quantidade) AS Quantidade_vendida
FROM produtos AS p INNER JOIN pedidos_produtos AS pe_p
ON p.id = pe_p.id_produto
GROUP BY  p.produto
ORDER BY SUM(pe_p.quantidade) DESC
LIMIT 15;

-- Quais produtos nunca foram vendidos?
SELECT 
	p.id AS ID_produto, 
	p.produto AS Produto, 
    COALESCE(SUM(pe_p.quantidade), 0) AS Quantidade_vendida
FROM produtos AS p
LEFT JOIN pedidos_produtos AS pe_p ON p.id = pe_p.id_produto
GROUP BY p.id, p.produto
HAVING Quantidade_vendida = 0;

-- Qual a quantidade de produtos vendidos por mês ao longo de 2024?
SELECT DATE_FORMAT(pe.data, '%m-%Y') AS Mes_Ano, SUM(pe_p.quantidade) AS Quantidade
FROM pedidos AS pe
INNER JOIN pedidos_produtos AS pe_p ON pe.id = pe_p.id_pedido
WHERE YEAR(pe.data) = 2024
GROUP BY Mes_Ano
ORDER BY Mes_Ano;

-- Qual a quantidade total de produtos vendidos por categoria até hoje?
SELECT cat.categoria AS Categoria, SUM(pe_p.quantidade) AS Quantidade
FROM categorias AS cat
INNER JOIN produtos AS p ON cat.id = p.id_categoria
INNER JOIN pedidos_produtos AS pe_p ON pe_p.id_produto = p.id
GROUP BY Categoria
ORDER BY Categoria;

# CONSULTAS SOBRE PEDIDOS

-- Ranking dos pedidos por valor total (do maior pro menor).
WITH total_gasto_pedidos AS (
	SELECT 
		pe.id AS ID_pedido,
		SUM(pe_p.quantidade * p.preco) AS Valor_total
    FROM pedidos AS pe
	INNER JOIN pedidos_produtos AS pe_p ON pe.id = pe_p.id_pedido
	INNER JOIN produtos AS p ON pe_p.id_produto = p.id
	GROUP BY ID_pedido
)
SELECT 
	tgp.ID_pedido,
    tgp.Valor_total,
    RANK() OVER(ORDER BY tgp.Valor_total DESC) AS Posicao
FROM total_gasto_pedidos AS tgp;

-- Calculando vendas mensais, usando LAG para comparar por mês, além das diferenças entre cada mês
WITH 
vendas_por_mes AS(
	SELECT 
		DATE_FORMAT(pe.data, '%Y-%m') AS Mes_ano, 
		SUM(pe_p.quantidade) AS Quantidade_vendida, 
		SUM(pe_p.quantidade * p.preco) AS Total_vendido
	FROM pedidos AS pe
	INNER JOIN pedidos_produtos AS pe_p ON pe.id = pe_p.id_pedido
	INNER JOIN produtos AS p ON pe_p.id_produto = p.id
	GROUP BY Mes_ano
),
diferenca_por_mes AS (
	SELECT
		vpm.Mes_ano,
		vpm.Quantidade_vendida,
		vpm.Total_vendido,
		LAG(vpm.Total_vendido) OVER(ORDER BY vpm.Mes_ano) AS Mes_anterior
	FROM vendas_por_mes AS vpm
)
SELECT 
	vpm.Mes_ano,
    vpm.Quantidade_vendida,
    vpm.Total_vendido,
    COALESCE(dpm.Mes_anterior, 0) AS Mes_anterior,
    COALESCE((vpm.Total_vendido - dpm.Mes_anterior), 0) AS Diferenca_pro_mes_anterior,
    CASE
		WHEN dpm.Mes_anterior IS NULL OR dpm.Mes_anterior = 0 THEN 0 
        WHEN (vpm.Total_vendido - dpm.Mes_anterior) < 0 THEN (((vpm.Total_vendido - dpm.Mes_anterior) / dpm.Mes_anterior) * 100)
        ELSE
			(((vpm.Total_vendido - dpm.Mes_anterior) / dpm.Mes_anterior) * 100)
	END AS Diferenca_pct_pro_mes_anterior
FROM vendas_por_mes AS vpm
LEFT JOIN diferenca_por_mes AS dpm ON vpm.Mes_ano = dpm.Mes_ano
ORDER BY Mes_ano;


# CONSULTAS SOBRE CLIENTES

-- Quais clientes que fizeram pedidos em janeiro de 2025?
SELECT c.nome AS Cliente, pe.id AS ID_pedido, pe.data AS Data_pedido
FROM clientes AS c INNER JOIN pedidos AS pe
ON c.id = pe.id_cliente
WHERE pe.data BETWEEN '2025-01-01' AND '2025-01-31'
ORDER BY ID_pedido DESC;

-- Quais são os 15 clientes que mais compraram?
SELECT c.nome AS Cliente, SUM(pe_p.quantidade) AS Quantidade_comprada
FROM clientes AS c 
INNER JOIN pedidos AS pe ON c.id = pe.id_cliente
INNER JOIN pedidos_produtos AS pe_p ON pe.id = pe_p.id_pedido
GROUP BY Cliente
ORDER BY Quantidade_comprada DESC
LIMIT 15;

-- Ranking de 25 clientes por gasto total
SELECT 
	c.nome AS Cliente,
    SUM(pe_p.quantidade) AS Quantidade_de_produtos,
    SUM(pe_p.quantidade * p.preco) AS Total_gasto,
    RANK() OVER (ORDER BY SUM(pe_p.quantidade * p.preco) DESC) AS Posicao
FROM clientes AS c
INNER JOIN pedidos AS pe ON c.id = pe.id_cliente
INNER JOIN pedidos_produtos AS pe_p ON pe_p.id_pedido = pe.id
INNER JOIN produtos AS p ON p.id = pe_p.id_produto
GROUP BY c.nome
ORDER BY Posicao
LIMIT 25;

-- Classificando clientes de acordo com os gastos
SELECT
	c.nome As Cliente,
    SUM(pe_p.quantidade * p.preco) AS Total_gasto,
    CASE
		WHEN SUM(pe_p.quantidade * p.preco) < 500 THEN 'Baixo gasto'
        WHEN SUM(pe_p.quantidade * p.preco) BETWEEN 500 AND 2000 THEN 'Médio gasto'
        ELSE 'Alto gasto'
	END AS Categoria_cliente
FROM clientes AS c
INNER JOIN pedidos AS pe ON c.id = pe.id_cliente
INNER JOIN pedidos_produtos AS pe_p ON pe.id = pe_p.id_pedido
INNER JOIN produtos AS p ON p.id = pe_p.id_produto
GROUP BY Cliente
ORDER BY Total_gasto DESC;

-- Quais os clientes que nunca fizeram pedidos?
SELECT c.nome AS Cliente, COUNT(pe.id) AS Quantidade_pedidos
FROM clientes AS c
LEFT JOIN pedidos AS pe ON c.id = pe.id_cliente
GROUP BY Cliente
HAVING Quantidade_pedidos = 0;

-- Classificando clientes de acordo com os gastos comparados à media geral
WITH total_gasto_cliente AS (
	SELECT 
		c.id AS ID_cliente,
        c.nome AS Cliente,
        SUM(pe_p.quantidade * p.preco) AS Total_gasto
	FROM clientes AS c
    INNER JOIN pedidos AS pe ON c.id = pe.id_cliente
    INNER JOIN pedidos_produtos AS pe_p ON pe.id = pe_p.id_pedido
    INNER JOIN produtos AS p ON p.id = pe_p.id_produto
    GROUP BY ID_cliente, Cliente
)
SELECT tgc.Cliente, tgc.Total_gasto,
	CASE
		WHEN tgc.Total_gasto > (SELECT AVG(Total_gasto) FROM total_gasto_cliente) THEN 'Acima da média'
        ELSE 'Abaixo da média'
	END AS Comparacao_media
FROM total_gasto_cliente AS tgc
ORDER BY tgc.Total_gasto DESC;

-- Classificando clientes que gastam acima ou abaixo da média por categoria
WITH total_gasto_cliente_por_categoria AS (
	SELECT c.id AS ID_cliente,
		c.nome AS Cliente,
		ca.categoria AS Categoria,
        SUM(pe_p.quantidade * p.preco) AS Total_gasto
	FROM clientes AS c
    INNER JOIN pedidos AS pe ON c.id = pe.id_cliente
    INNER JOIN pedidos_produtos AS pe_p ON pe_p.id_pedido = pe.id
    INNER JOIN produtos AS p ON p.id = pe_p.id_produto
    INNER JOIN categorias AS ca ON ca.id = p.id_categoria
    GROUP BY ID_cliente, Cliente, Categoria
)
SELECT 
	tgcpc.ID_cliente, 
	tgcpc.Cliente, 
    tgcpc.Categoria,
	CASE 
		WHEN tgcpc.Total_gasto > (
			SELECT AVG(Total_gasto) 
			FROM total_gasto_cliente_por_categoria 
            WHERE Categoria = tgcpc.Categoria) THEN 'Acima da média'
        ELSE 'Abaixo da média'
	END AS Comparacao_media
FROM total_gasto_cliente_por_categoria AS tgcpc
ORDER BY tgcpc.Categoria, tgcpc.Total_gasto DESC;

-- Calculando, por cliente, gastos em relação a media da mesma cidade
WITH 
	total_gasto_cliente AS (
	SELECT
		c.nome AS Cliente,
        ci.nome AS Cidade,
        SUM(pe_p.quantidade * p.preco) AS Valor_total
	FROM cidades AS ci
    INNER JOIN clientes AS c ON ci.id = c.id_cidade
    INNER JOIN pedidos AS pe ON c.id = pe.id_cliente
    INNER JOIN pedidos_produtos AS pe_p ON pe_p.id_pedido = pe.id
    INNER JOIN produtos AS p ON pe_p.id_produto = p.id
	GROUP BY Cliente, Cidade
)
SELECT
    tgc.Cliente,
    tgc.Cidade,
    tgc.Valor_total,
    AVG(tgc.Valor_total) OVER(PARTITION BY tgc.Cidade) AS Media_cidade,
    (tgc.Valor_total - AVG(tgc.Valor_total) OVER(PARTITION BY tgc.Cidade)) AS Diferenca
FROM total_gasto_cliente AS tgc;


# CONSULTAS SOBRE CIDADES

-- Cidades que tem mais de 4 clientes cadastrados
SELECT ci.nome AS Cidade, ci.estado AS UF, COUNT(c.id_cidade) AS Quantidade_clientes
FROM cidades AS ci
INNER JOIN clientes AS c ON c.id_cidade = ci.id
GROUP BY Cidade, UF
HAVING COUNT(c.id_cidade) >= 4
ORDER BY COUNT(c.id_cidade) DESC;

-- Ranking das 20 cidades que mais gastaram até hoje
SELECT 
	ci.nome AS Cidade, 
	ci.estado AS UF,
    SUM(pe_p.quantidade) AS Quantidade_produtos,
    SUM(pe_p.quantidade * p.preco) AS Valor_gasto
FROM cidades AS ci
INNER JOIN clientes AS c ON ci.id = c.id_cidade
INNER JOIN pedidos AS pe ON c.id = pe.id_cliente
INNER JOIN pedidos_produtos AS pe_p ON pe_p.id_pedido = pe.id
INNER JOIN produtos AS p ON p.id = pe_p.id_produto
GROUP BY Cidade, UF
ORDER BY Valor_gasto DESC
LIMIT 20;

-- Ticket medio por UF
WITH gasto_total_cidade AS (
	SELECT 
		ci.estado AS UF,
        COUNT(DISTINCT pe.id) AS Total_pedidos,
        SUM(pe_p.quantidade * p.preco) AS Valor_gasto
	FROM cidades AS ci
    INNER JOIN clientes AS c ON ci.id = c.id_cidade
    INNER JOIN pedidos AS pe ON c.id = pe.id_cliente
    INNER JOIN pedidos_produtos AS pe_p ON pe_p.id_pedido = pe.id
    INNER JOIN produtos AS p ON p.id = pe_p.id_produto
    GROUP BY UF
)
SELECT
    gtc.UF,
    gtc.Total_pedidos,
    gtc.Valor_gasto,
    ROUND((gtc.Valor_gasto / gtc.Total_pedidos), 2) AS Ticket_medio
    FROM gasto_total_cidade AS gtc
    ORDER BY Ticket_medio DESC;
