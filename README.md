# Gene–Disease Associations in DisGeNET (SQL)

**Do diseases with more associated genes receive more research attention?** This project uses SQL to explore DisGeNET, one of the largest public catalogs of links between human genes and diseases, and answers that question with a research poster.

**Solo project** for CS3200 (Database Design), Northeastern University, Fall 2026.

## Research poster

📄 **[View the poster (PDF)](poster.pdf)**

I counted the distinct genes linked to each disease and the total number of publications studying it, then plotted one against the other. The result was a **strong positive relationship (R² = 0.91)**: diseases with more known genetic associations tend to have far more published research. One possible explanation is that each newly linked gene opens up new questions, drawing more researchers to that disease.

## Queries

[`disgenet_queries.sql`](disgenet_queries.sql) answers nine questions about the dataset, including:

- Which **G protein-coupled receptor genes** (common drug targets) are in the catalog?
- Which diseases have the most **strong** genetic associations, and which genes are linked to the most diseases?
- Which gene–disease links have the **strongest evidence** and over 1,000 publications?
- Which genes are strongly linked to **asthma**, and which *other* diseases share the most of those genes?

**SQL skills used:** filtering with `WHERE` and `LIKE`, `DISTINCT`, aggregation (`COUNT`, `SUM`), `GROUP BY` with `HAVING`, sorting and `LIMIT`, and subqueries with `IN`.

## Files

| File | What it is |
|---|---|
| `disgenet_queries.sql` | All queries, with comments explaining each question |
| `poster.pdf` | Research poster with method, results, and conclusions |
| `poster_data.csv` | Query results behind the poster's chart (disease name, number of genes, total publications) |

## How to run

1. Download the gene–disease associations dataset from [DisGeNET](https://www.disgenet.com/). The raw file is too large for GitHub (over 100 MB), so it isn't included here.
2. Import it into a MySQL table named `disgenet` in a database named `disgenet`.
3. Run the queries in `disgenet_queries.sql` (for example, in MySQL Workbench).
