use MyAdventureWorks2017
go

if exists(
	select * from sys.foreign_keys
	where name = 'fk_fact_sales_dim_product' 
	AND parent_object_id = OBJECT_ID('FactSales'))
	ALTER TABLE FactSales
    DROP CONSTRAINT fk_fact_sales_dim_product;
--- Droping ProdictDim table
if exists(select * from sys.tables 
	where name = 'ProductDim' AND TYPE = 'U' 
	)
	DROP TABLE ProductDim;
go

create table ProductDim(
	product_key int not null identity(1,1) primary key clustered,--- surrogate key
	product_id int not null, ---alternate key, business key
	product_name        NVARCHAR(50),
    Product_description NVARCHAR(400),
    product_subcategory NVARCHAR(50),
    product_category    NVARCHAR(50),
    color               NVARCHAR(15),
    model_name          NVARCHAR(50),
	reorder_point       SMALLINT,
    standard_cost       MONEY,
	---Metadata
	source_sys_code tinyint not null,
	--SLOWLY CHANGING DIM
	start_date datetime not null default (getdate()),
	end_date datetime,
	is_current tinyint not null default (1),
)
--Enable user to set identity Column
SET IDENTITY_INSERT ProductDim ON

INSERT INTO ProductDim
            (product_key,
             product_id,
             product_name,
             Product_description,
             product_subcategory,
             product_category,
             color,
             model_name,
             reorder_point,
             standard_cost,
             source_sys_code,
             start_date,
             end_date,
             is_current)
VALUES      (0,0,
             'Unknown',
             'Unknown',
             'Unknown',
             'Unknown',
             'Unknown',
             'Unknown',
             0,
             0,
             0,
             '1900-01-01',
             NULL,
             1)
--Disble user to set identity Column
SET IDENTITY_INSERT ProductDim OFF
-- create foreign key
IF EXISTS (SELECT *
           FROM   sys.tables
           WHERE  NAME = 'FactSales')
	ALTER TABLE fact_sales
    ADD CONSTRAINT fk_fact_sales_dim_product FOREIGN KEY (product_key)
    REFERENCES ProductDim(product_key);
-- Create index on primary key
IF EXISTS (SELECT *
           FROM   sys.indexes
           WHERE  NAME = 'dim_product_product_id'
                  AND object_id = Object_id('ProductDim'))
	DROP INDEX ProductDim.dim_product_product_id;
CREATE INDEX dim_product_product_id
ON ProductDim(product_id);
-- Create Index on Category
IF EXISTS (SELECT *
           FROM   sys.indexes
           WHERE  NAME = 'dim_prodct_product_category'
                  AND object_id = Object_id('ProductDim'))
  DROP INDEX ProductDim.dim_prodct_product_category

CREATE INDEX dim_prodct_product_category
ON ProductDim(product_category); 