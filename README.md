# 🍽️ Restaurant Orders — SQL Analysis (BigQuery)

![SQL](https://img.shields.io/badge/SQL-BigQuery-blue?logo=google-cloud&logoColor=white)
![Status](https://img.shields.io/badge/Status-Concluído-success)

Análise exploratória de um banco de dados de pedidos de restaurante utilizando **SQL no Google BigQuery**.  
O objetivo foi entender o cardápio, o comportamento dos pedidos e identificar os itens e categorias mais relevantes para o negócio.

> 📊 As métricas geradas neste projeto podem ser conectadas ao **Power BI** para construção de dashboards interativos, permitindo visualização dinâmica dos dados por data, categoria, ticket médio e volume de pedidos.

---

## 🔎 Principais Achados

- O restaurante registrou **5.370 pedidos únicos** no Q1 2023, com média de ~59 pedidos por dia
- A culinária **Asian é a mais pedida** (3.470 pedidos), apesar de não ser a mais cara nem a mais variada do cardápio
- O **Hamburger** ($12.95) lidera em volume individual com 622 pedidos, seguido pelo **Edamame** ($5.00) com 620 — itens com perfis opostos de preço
- O pedido de maior valor ($192.15) foi dominado por pratos **Italianos**, a categoria de maior preço médio ($16.75)
- A **composição do pedido** impacta o ticket mais do que a quantidade de itens
- **Segundas-feiras** concentram 6 dos 10 dias mais movimentados do trimestre
- O LEFT JOIN revelou registros com `item_id = NULL`, indicando **falhas no registro de pedidos** que precisariam ser tratadas antes de qualquer cálculo de faturamento

---

## 📁 Estrutura do Projeto

```
restaurant-sql-analysis/
│
├── data/
│   └── create_restaurant_db.sql
│
├── queries/
│   ├── 01_menu_exploration/
│   │   ├── num_dishes.sql
│   │   ├── number_of_dishes_per_category.sql
│   │   └── AVG_price_category.sql
│   │
│   ├── 02_orders_exploration/
│   │   ├── number_of_orders.sql
│   │   ├── order_dates_range.sql
│   │   ├── most_number_of_items.sql
│   │   └── num_more_than_12_orders.sql
│   │
│   └── 03_join_analysis/
│       ├── Join_menu_items-order_details.sql
│       ├── Join_menu_items-order_detailsNULLS.sql
│       ├── most_ordered_+_by_category.sql
│       ├── most_ordered_category.sql
│       ├── top_5_most_money_spent.sql
│       ├── most_expensive_order_details.sql
│       ├── dishes_per_category.sql
│       ├── avg_ticket_per_order.sql
│       ├── day_of_week_+_avg_ticket_per_order(by_ticket).sql
│       └── day_of_week_+_avg_ticket_per_order(by_num_orders).sql
│
└── README.md
```

---

## 🗃️ Sobre o Banco de Dados

O banco `restaurant_db` é composto por duas tabelas principais:

| Tabela | Descrição |
|---|---|
| `menu_items` | Cardápio do restaurante: nome, categoria e preço de cada prato |
| `order_details` | Registro de pedidos: data, horário e itens solicitados |

> **Período analisado:** Janeiro de 2023 a Março de 2023  
> **Total de pedidos:** 5.370 pedidos únicos

---

## 🔍 Análises e Insights

### 📋 Parte 1 — Exploração do Cardápio (`menu_items`)

#### Número de pratos por categoria

```sql
SELECT category, COUNT(menu_item_id) AS num_dishes
FROM restaurant_db.menu_items
GROUP BY category
```

| Categoria | Nº de Pratos |
|---|---|
| American | 6 |
| Asian | 8 |
| Mexican | 9 |
| Italian | 9 |

> 💡 **Insight:** A culinária Mexicana e Italiana dominam em variedade (9 opções cada), enquanto a Americana tem apenas 6. Variedade, porém, não equivale a popularidade — como veremos nas análises de pedidos, a categoria Asian, com apenas 8 pratos, é a mais pedida do restaurante. Isso indica que **a força de uma categoria está mais no apelo dos pratos do que na quantidade oferecida**.

---

#### Preço médio por categoria

```sql
SELECT category, ROUND(AVG(price), 2) AS avg_price
FROM restaurant_db.menu_items AS M
GROUP BY category
```

| Categoria | Preço Médio |
|---|---|
| American | $10.07 |
| Asian | $13.48 |
| Mexican | $11.80 |
| Italian | $16.75 |

> 💡 **Insight:** A culinária Italiana é a mais cara em média ($16.75), enquanto a Americana é a mais acessível ($10.07) — uma diferença de $6.68. Cruzando com os dados de pedidos, a culinária Americana é a **menos pedida** mesmo sendo a mais barata, o que refuta a hipótese de que menor preço resulta em maior volume. Já a Asian, com preço médio intermediário ($13.48), lidera em pedidos — indicando que **preferência e percepção de valor pesam mais que o preço** na decisão do cliente.

---

### 📦 Parte 2 — Exploração dos Pedidos (`order_details`)

#### Volume e período dos pedidos

```sql
SELECT COUNT(DISTINCT order_id) FROM order_details
-- Resultado: 5.370 pedidos

SELECT MIN(order_date) AS first_order, MAX(order_date) AS last_order
FROM order_details
-- Resultado: 2023-01-01 → 2023-03-31
```

> 💡 **Insight:** O dataset cobre exatamente 1 trimestre (Q1 2023), com 5.370 pedidos únicos — uma média de ~59 pedidos por dia. O período completo (01/01 a 31/03) sem lacunas indica dados consistentes e confiáveis para análise.

---

#### Pedidos com mais itens

```sql
SELECT order_id, COUNT(item_id) AS num_items
FROM order_details
GROUP BY order_id
ORDER BY num_items DESC
```

> 💡 **Insight:** Os maiores pedidos chegaram a **14 itens**, com vários registros empatados nesse valor (1957, 4305, 330, 2675, 4482, 3473, 440, 443). A concentração nesse número levanta a hipótese de um limite operacional ou de sistema por comanda — o que seria necessário validar com a equipe de operações ou nos logs do sistema.

---

#### Pedidos com mais de 12 itens

```sql
SELECT COUNT(*) FROM (
  SELECT order_id, COUNT(item_id) AS num_items
  FROM order_details
  GROUP BY order_id
  HAVING num_items > 12
)
-- Resultado: 23 pedidos
```

> 💡 **Insight:** Apenas **23 pedidos** (0,43% do total) ultrapassaram 12 itens. Esse volume reduzido, porém consistente, sugere a existência de um segmento de clientes com padrão de consumo acima da média — vale monitorar recorrência e avaliar iniciativas específicas para esse perfil.

---

### 🔗 Parte 3 — Análise com JOIN entre tabelas

#### Por que usamos `SAFE_CAST`?

Durante a junção das tabelas, identificamos uma **inconsistência de tipos**: a coluna `item_id` em `order_details` estava armazenada como `STRING`, enquanto `menu_item_id` em `menu_items` era `INT64`. O BigQuery não permite comparar tipos diferentes diretamente.

A conversão foi feita para `INT64` pois é o tipo nativo de `menu_item_id`. Optamos pelo `SAFE_CAST` em vez do `CAST` convencional pois a coluna continha **valores inválidos** que não podiam ser convertidos — o `SAFE_CAST` trata esses casos retornando `NULL` ao invés de interromper a query.

```sql
-- INNER JOIN (apenas pedidos com correspondência no cardápio)
FROM order_details AS od
INNER JOIN menu_items AS mi
  ON SAFE_CAST(od.item_id AS INT64) = mi.menu_item_id

-- LEFT JOIN (preserva todos os pedidos, mesmo sem item correspondente)
FROM order_details AS od
LEFT JOIN menu_items AS mi
  ON SAFE_CAST(od.item_id AS INT64) = mi.menu_item_id
```

> 💡 **Insight:** O LEFT JOIN revelou registros com `item_id = NULL` em `order_details` — pedidos que existem no sistema sem item associado. Esses registros podem indicar falhas de integração entre o sistema de registro e o banco de dados, cancelamentos não tratados corretamente, ou referências a itens removidos do cardápio. Em um contexto de negócio, esses NULLs precisariam ser investigados e tratados antes de qualquer cálculo de faturamento.

---

#### Itens mais pedidos

```sql
SELECT mi.item_name, mi.category, mi.price, COUNT(od.order_details_id) AS num_purchases
FROM order_details AS od
INNER JOIN menu_items AS mi ON SAFE_CAST(od.item_id AS INT64) = mi.menu_item_id
GROUP BY mi.category, mi.price, mi.item_name
ORDER BY num_purchases DESC
```

| # | Item | Categoria | Preço | Pedidos |
|---|---|---|---|---|
| 1 | Hamburger | American | $12.95 | 622 |
| 2 | Edamame | Asian | $5.00 | 620 |
| 3 | Korean Beef Bowl | Asian | $17.95 | 588 |
| 4 | Cheeseburger | American | $13.95 | 583 |
| 5 | French Fries | American | $7.00 | 571 |
| 6 | Tofu Pad Thai | Asian | $14.50 | 562 |
| 7 | Steak Torta | Mexican | $13.95 | 489 |
| 8 | Spaghetti & Meatballs | Italian | $17.95 | 470 |

> 💡 **Insight:** O **Hamburger** lidera com 622 pedidos, seguido pelo **Edamame** com 620 — uma diferença de apenas 2 registros em um trimestre. O contraste de preços é relevante: Hamburger a $12.95, Edamame a $5.00. O alto volume do Edamame com ticket unitário baixo sugere que ele funciona como item de acompanhamento recorrente, impactando volume sem impactar ticket médio. O Korean Beef Bowl ($17.95, 3º lugar), por sua vez, combina alto volume com maior valor unitário — perfil distinto do Edamame para fins de estratégia comercial.

---

#### Categoria mais pedida

```sql
SELECT mi.category, COUNT(category) AS num_purchases
FROM order_details AS od
INNER JOIN menu_items AS mi ON SAFE_CAST(od.item_id AS INT64) = mi.menu_item_id
GROUP BY category
ORDER BY num_purchases DESC
```

| Categoria | Total de Pedidos |
|---|---|
| Asian | 3.470 |
| Italian | 2.948 |
| Mexican | 2.945 |
| American | 2.734 |

> 💡 **Insight:** A culinária **Asian lidera com folga** (3.470 pedidos vs. 2.948 da Italiana em 2º). A categoria **American** ocupa a última posição (2.734 pedidos) mesmo tendo o Hamburger como item mais pedido individualmente — o que demonstra que o desempenho de um único prato não sustenta o resultado de uma categoria. Italian e Mexican estão praticamente empatadas (diferença de 3 pedidos em 3 meses), indicando equilíbrio real de preferência entre as duas.

---

#### Top 5 pedidos com maior gasto

```sql
SELECT order_id, ROUND(SUM(mi.price), 2) AS total_spent
FROM order_details AS od
INNER JOIN menu_items AS mi ON SAFE_CAST(od.item_id AS INT64) = mi.menu_item_id
GROUP BY order_id
ORDER BY total_spent DESC
LIMIT 5
```

| order_id | Total Gasto | Nº de Itens |
|---|---|---|
| 440 | $192.15 | 14 |
| 2075 | $191.05 | 13 |
| 1957 | $190.10 | 14 |
| 330 | $189.70 | 14 |
| 2675 | $185.10 | 14 |

> 💡 **Insight:** Os 5 maiores pedidos concentram-se em uma faixa estreita de $185 a $192. O dado mais relevante está no pedido **2075**: com 13 itens, gerou o segundo maior gasto ($191.05) — praticamente igual ao pedido 440, que tinha 14 itens e liderou com $192.15. Isso indica que **a composição do pedido impacta o ticket mais do que a quantidade de itens**.

---

#### Detalhamento do pedido mais caro (order_id = 440)

```sql
SELECT * FROM order_details AS od
INNER JOIN menu_items AS mi ON SAFE_CAST(od.item_id AS INT64) = mi.menu_item_id
WHERE order_id = 440
```

> 💡 **Insight:** O pedido 440 ($192.15) foi realizado em **08/01/2023** com 14 itens. Desses, 8 eram da culinária **Italiana** — a categoria de maior preço médio ($16.75) — incluindo Spaghetti & Meatballs, Fettuccine Alfredo (2x), Meat Lasagna e Chicken Parmesan. O pedido também incluiu itens Asian, Mexican e American, indicando uma mesa com preferências diversas.

---

#### Categorias nos top 5 pedidos mais caros

```sql
SELECT order_id, category, COUNT(item_id) AS num_items
FROM order_details AS od
INNER JOIN menu_items AS mi ON SAFE_CAST(od.item_id AS INT64) = mi.menu_item_id
WHERE order_id IN (440, 2075, 1957, 330, 2675)
GROUP BY order_id, category
```

> 💡 **Insight:** Entre os 5 maiores pedidos, a culinária Italiana está presente com maior concentração de itens nos pedidos de ticket mais alto — o que é coerente com seu maior preço médio por prato ($16.75). Com apenas 5 pedidos de amostra, no entanto, não é possível generalizar essa relação.

---

### 📅 Parte 4 — Análise Temporal e Ticket Médio

#### Por que usamos `FORMAT_DATE`?

Para extrair o nome do dia da semana a partir de uma coluna de data, utilizamos a função `FORMAT_DATE` do BigQuery:

```sql
FORMAT_DATE('%A', order_date) AS day_of_week
```

O `'%A'` retorna o nome completo do dia da semana em inglês (Monday, Tuesday, etc.) a partir de uma coluna do tipo `DATE`. Isso permite agrupar e comparar o comportamento dos pedidos por dia da semana sem a necessidade de uma tabela auxiliar de calendário — da mesma forma que o `SAFE_CAST` resolve uma incompatibilidade de tipos, o `FORMAT_DATE` transforma um dado bruto em uma dimensão analítica mais útil.

---

#### Ticket médio por dia (ordenado por volume de pedidos)

> **`avg_ticket_per_order`** representa o valor médio gasto por pedido em cada data — calculado dividindo o total faturado no dia pelo número de pedidos únicos daquele dia.

```sql
SELECT 
  order_date,
  COUNT(DISTINCT od.order_id) AS num_orders,
  ROUND(SUM(mi.price) / COUNT(DISTINCT od.order_id), 2) AS avg_ticket_per_order
FROM `restaurant-orders-494618.restaurant_db.order_details` AS od
INNER JOIN `restaurant-orders-494618.restaurant_db.menu_items` AS mi
  ON SAFE_CAST(od.item_id AS INT64) = mi.menu_item_id
GROUP BY order_date
ORDER BY num_orders DESC
```

| order_date | num_orders | avg_ticket_per_order |
|---|---|---|
| 2023-02-01 | 87 | $27.54 |
| 2023-02-20 | 73 | $29.50 |
| 2023-01-08 | 72 | $31.36 |
| 2023-02-27 | 71 | $31.15 |
| 2023-03-27 | 71 | $30.50 |
| 2023-03-17 | 71 | $33.05 |
| 2023-03-13 | 71 | $31.72 |

> 💡 **Insight:** O dia mais movimentado do trimestre foi **01/02/2023** com 87 pedidos e ticket médio de $27.54 — o menor entre os dias listados. Entre os 7 dias de maior volume, o ticket varia de $27.54 a $33.05, sem uma relação direta entre volume de pedidos e valor médio por pedido.

---

#### Ticket médio por dia com dia da semana (ordenado por maior ticket)

```sql
SELECT 
  order_date,
  FORMAT_DATE('%A', order_date) AS day_of_week,
  COUNT(DISTINCT od.order_id) AS num_orders,
  ROUND(SUM(mi.price) / COUNT(DISTINCT od.order_id), 2) AS avg_ticket_per_order
FROM `restaurant-orders-494618.restaurant_db.order_details` AS od
INNER JOIN `restaurant-orders-494618.restaurant_db.menu_items` AS mi
  ON SAFE_CAST(od.item_id AS INT64) = mi.menu_item_id
GROUP BY order_date, day_of_week
ORDER BY avg_ticket_per_order DESC
```

| order_date | day_of_week | num_orders | avg_ticket_per_order |
|---|---|---|---|
| 2023-01-31 | Tuesday | 54 | $35.68 |
| 2023-02-28 | Tuesday | 58 | $34.63 |
| 2023-03-03 | Friday | 53 | $34.56 |
| 2023-02-22 | Wednesday | 36 | $34.17 |
| 2023-02-18 | Saturday | 61 | $33.84 |
| 2023-03-15 | Wednesday | 49 | $33.75 |
| 2023-03-07 | Tuesday | 57 | $33.47 |
| 2023-02-09 | Thursday | 53 | $33.30 |
| 2023-02-26 | Sunday | 54 | $33.24 |

> 💡 **Insight:** Os dias com maior ticket médio por pedido chegam a $35.68 (31/01, Tuesday). **Terças-feiras** aparecem 3 vezes entre os 9 maiores tickets do período — padrão que merece acompanhamento em trimestres futuros para confirmar se é consistente ou variação pontual do Q1.

---

#### Ticket médio por dia com dia da semana (ordenado por volume de pedidos)

```sql
SELECT 
  order_date,
  FORMAT_DATE('%A', order_date) AS day_of_week,
  COUNT(DISTINCT od.order_id) AS num_orders,
  ROUND(SUM(mi.price) / COUNT(DISTINCT od.order_id), 2) AS avg_ticket_per_order
FROM `restaurant-orders-494618.restaurant_db.order_details` AS od
INNER JOIN `restaurant-orders-494618.restaurant_db.menu_items` AS mi
  ON SAFE_CAST(od.item_id AS INT64) = mi.menu_item_id
GROUP BY order_date, day_of_week
ORDER BY num_orders DESC
```

| order_date | day_of_week | num_orders | avg_ticket_per_order |
|---|---|---|---|
| 2023-02-01 | Wednesday | 87 | $27.54 |
| 2023-02-20 | Monday | 73 | $29.50 |
| 2023-01-08 | Sunday | 72 | $31.36 |
| 2023-02-27 | Monday | 71 | $31.15 |
| 2023-03-27 | Monday | 71 | $30.50 |
| 2023-03-17 | Friday | 71 | $33.05 |
| 2023-03-13 | Monday | 71 | $31.72 |
| 2023-01-23 | Monday | 69 | $28.80 |
| 2023-02-13 | Monday | 69 | $28.68 |
| 2023-02-11 | Saturday | 68 | $29.56 |

> 💡 **Insight:** **Segunda-feira** concentra 6 dos 10 dias mais movimentados do trimestre — o dia da semana com maior recorrência no topo do ranking de volume. O dia de maior movimento absoluto foi uma **quarta-feira** (01/02, 87 pedidos), com o menor ticket médio entre os dias listados ($27.54).

---

## 🚀 Próximos Passos

- Conectar os resultados ao **Power BI** para construção de dashboard interativo com filtros por categoria, dia da semana e ticket médio
- Expandir a análise para mais trimestres e validar se os padrões observados (terças com ticket alto, segundas com alto volume) se confirmam
- Investigar os registros com `item_id = NULL` para entender a causa e tratar a qualidade dos dados

---

## 🛠️ Tecnologias Utilizadas

![BigQuery](https://img.shields.io/badge/Google-BigQuery-4285F4?logo=google-cloud&logoColor=white)
![SQL](https://img.shields.io/badge/Language-SQL-orange)

- **Google BigQuery** — execução das queries
- **SQL (Standard SQL)** — linguagem de consulta
- **SAFE_CAST** — tratamento de inconsistência de tipos entre tabelas
- **FORMAT_DATE** — extração do dia da semana a partir de colunas do tipo `DATE`

---

## 📌 Como reproduzir

**Pré-requisitos:**
- Conta no [Google Cloud](https://cloud.google.com) com acesso ao BigQuery
- Projeto criado no Google Cloud com faturamento ativo (o BigQuery oferece uma camada gratuita generosa para consultas)

**Passos:**
1. No BigQuery, crie um dataset chamado `restaurant_db`
2. Execute o script `data/create_restaurant_db.sql` para criar e popular as tabelas
3. Substitua o project ID `restaurant-orders-494618` pelo ID do seu próprio projeto em todas as queries
4. Execute as queries na ordem das pastas: `01_menu_exploration` → `02_orders_exploration` → `03_join_analysis`

---

## 👤 Autor

**Alice Plentz**  
[LinkedIn](https://www.linkedin.com/in/alice-plentz-0423471b5/) · [GitHub](https://github.com/midisfanclub)

---

## 📎 Referências

- **Dataset:** [Maven Analytics — Data Playground](https://mavenanalytics.io/data-playground) (Restaurant Order Analysis)
- **Inspiração inicial:** [Data Analyst Portfolio Project: Restaurant Order Analysis in SQL](https://www.youtube.com/watch?v=JaUKDbCXMX4) — Maven Analytics (YouTube)
- **Queries adicionais, estrutura do projeto, documentação e insights:** desenvolvidos pela autora
