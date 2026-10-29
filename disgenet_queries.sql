-- CS3200: Database Design
-- DISGENET: A Catalog of Gene-Disease Associations


-- Write a query to answer each of the following questions
-- Save your script file as disgenet_yourname.sql (no spaces)
-- Submit this file with your homework submission


use disgenet;



-- 1. 
-- Explore the content of the various columns in your disgenet table.
-- List all genes whose name contains the phrase "G protein-coupled" in alphabetical order by gene symbol
-- Output the gene id, gene symbol, and name, as well as the DSI, and the DPI
-- (These genes are often the target for new drugs, so are of particular interest)
-- Each distinct gene should be listed only once!
-- Output the genes in alphabetical order by gene_symbol
-- Output only the first 10 genes in your list

select distinct gene_id, gene_symbol, gene_name, DSI, DPI
from disgenet
where gene_name like '%G protein-coupled%'
order by gene_symbol
limit 10;


-- 2. 
-- How many records are there for each disease type?
-- Output your list from most frequent to least frequent

select disease_type, count(*) as num_records
from disgenet
group by disease_type
order by num_records desc;


-- 3. 
-- What DISEASES (disease_type = 'disease') have the most genetic associations?
-- Include only genes where both the evidence index and the score > 0.5000
-- Show the top 10 diseases (by gene count) only.
-- Use column aliases where appropriate to improve output clarity and readability
-- Your output should display the name of the disease, and the number of associations (num_genes)

select disease_name, count(distinct gene_id) as num_genes
from disgenet
where disease_type = 'disease' 
	and evidence_index > 0.5000 
	and score > 0.5000
group by disease_name 
order by num_genes desc
limit 10;

-- 4.
-- Now we ask the opposite question
-- Which GENES have the most disease associations?
-- Display the gene id, symbol, and name, along with the DSI, DPI, and the number of disease associations.
-- Again limit to disease_type = 'disease' and only strong associations where both
-- the evidence index and score are both >= 0.50
-- Output only genes with 20 or more disease associations
-- Use column aliases where appropriate to improve output clarity and readability

select gene_id, gene_symbol, gene_name, DSI, DPI, count(disease_name) as num_diseases
from disgenet
where disease_type = 'disease'
	and evidence_index >= 0.5000
    and score >= 0.5000
group by gene_id, gene_symbol, gene_name, DSI, DPI
having num_diseases >= 20
order by num_diseases desc;


-- 5.
-- What are the top five diseases (disease_type='disease') in terms of TOTAL number of publications?
-- sort by total publications descending

select disease_name, sum(num_pubs) as total_pubs
from disgenet
where disease_type = 'disease'
group by disease_name
order by total_pubs desc
limit 5;


-- 6. 
-- We examine more closely those gene-disease associations with very strong evidence 
-- Find all associations with an evidence index and score > 0.90 and for 
-- Output gene id, symbol, name, evidence_index, score, and disease name
-- Only output gene-disease associations wehre there there is over 1000 publications
-- sort in descending order by the evidence index

select distinct gene_id , gene_symbol, gene_name, evidence_index, score, disease_name
from disgenet
where 
	evidence_index > 0.90
    and score > 0.90
    and num_pubs > 1000
order by evidence_index desc;



-- 7.
-- List the gene id, symbol, and name of genes strongly linked to Asthma. 
-- Include any disease name that contains the substring 'asthma'
-- Strongly-linked in this case means that both the score and evidence index >= 0.5
-- Include any disease name that contains the substring Asthma
-- sort output by gene_symbol

select distinct gene_id, gene_symbol, gene_name
from disgenet
where disease_name like '%asthma%'
	and evidence_index >= 0.5
    and score >= 0.5
order by gene_symbol;


-- 8.
-- In the previous question, we found asthma-linked genes
-- but these genes might also be implicated in other diseases.
-- Output disgenet records involving an association between ANY asthma-linked gene and ANY disease
-- As before the association with other diseases must be strong (evidence_index and score >= 0.5)
-- Only include associations with disease_type = 'disease'.
-- Sort your output alphabetically by disease name, and gene_symbol
-- Hint: Use a SELECT inside the IN operator
-- Output the gene id, symbol, and name, the disease_name, and the evidence_index, score, and number of publications
-- Make sure you are only linking asthma genes to diseases where there is strong evidence. (i.e., 
-- use the same criteria you used to find the original asthma-linked genes.)

select distinct gene_id, gene_symbol, gene_name, disease_name, evidence_index, score, num_pubs
from disgenet
-- find genes strongly associated with asthma
where gene_id in ( 
	select gene_id
	from disgenet
    where disease_name like '%asthma%'
		and evidence_index >= 0.5
		and score >= 0.5
    )
-- find strong disease associations for asthma-linked genes
and disease_type = 'disease'
and evidence_index >= 0.5
and score >= 0.5
order by disease_name, gene_symbol;

-- 9.
-- As you scroll through the results of your last query, you will notice that some
-- diseases are linked to one or two asthma genes, and some are linked to many asthma genes.
-- Modify your query so that it COUNTS the number of ASTHMA-linked genes associated with
-- each disease.   Rank the disease by how many ASTHMA-linked genes each disease is linked to.
-- Show the five disease that have the most overlapping gene associations with asthma.
-- Hint:  Asthma obviously overlaps will all asthma-linked genes and should be #1 in your output list!

select disease_name, count(distinct gene_id) as gene_count
from disgenet

where gene_id in ( 
	select gene_id
	from disgenet
    where disease_name like '%asthma%'
		and evidence_index >= 0.5
		and score >= 0.5
    )
and disease_type = 'disease'
and evidence_index >= 0.5
and score >= 0.5

group by disease_name
order by gene_count desc
limit 5;

-- Poster.
-- Research Question: Is the number of genes associated with a disease related to the total number of publications studying that disease?

select 
	disease_name, 
	count(distinct gene_id) as num_genes, 
    sum(num_pubs) as total_pubs
from disgenet
where disease_type = 'disease'
group by disease_name
limit 500;
