use MyAdventureWorks2017
go

IF EXISTS (SELECT *
           FROM   sys.tables
           WHERE  NAME = 'FactSales')
  DROP TABLE FactSales;

CREATE TABLE FactSales
  (
     product_key    INT NOT NULL,
     customer_key   INT NOT NULL,
     territory_key  INT NOT NULL,
     order_date_key INT NOT NULL,
     sales_order_id VARCHAR(50) NOT NULL,
     line_number    INT NOT NULL,
     quantity       INT,
     unit_price     MONEY,
     unit_cost      MONEY,
     tax_amount     MONEY,
     freight        MONEY,
     extended_sales MONEY,
     extened_cost   MONEY,
     created_at     DATETIME NOT NULL DEFAULT(Getdate()),
     CONSTRAINT pk_fact_sales PRIMARY KEY CLUSTERED (sales_order_id, line_number
     ),
     CONSTRAINT fk_fact_sales_dim_product FOREIGN KEY (product_key) REFERENCES
     ProductDim(product_key),
     CONSTRAINT fk_fact_sales_dim_customer FOREIGN KEY (customer_key) REFERENCES
     CustomerDim(customer_key),
     CONSTRAINT fk_fact_sales_dim_territory FOREIGN KEY (territory_key)
     REFERENCES TerritoryDim(territory_key),
     CONSTRAINT fk_fact_sales_dim_date FOREIGN KEY (order_date_key) REFERENCES
     DateDim(date_key)
  );

-- Create Indexes
IF EXISTS (SELECT *
           FROM   sys.indexes
           WHERE  NAME = 'fact_sales_dim_product'
                  AND object_id = Object_id('FactSales'))
  DROP INDEX FactSales.fact_sales_dim_product;

CREATE INDEX fact_sales_dim_product
 ON FactSales(product_key);

IF EXISTS (SELECT *
           FROM   sys.indexes
           WHERE  NAME = 'fact_sales_dim_customer'
                  AND object_id = Object_id('FactSales'))
  DROP INDEX FactSales.fact_sales_dim_customer;

CREATE INDEX fact_sales_dim_customer
  ON FactSales(customer_key);

IF EXISTS (SELECT *
           FROM   sys.indexes
           WHERE  NAME = 'fact_sales_dim_territory'
                  AND object_id = Object_id('FactSales'))
  DROP INDEX FactSales.fact_sales_dim_territory;

CREATE INDEX fact_sales_dim_territory
  ON FactSales(territory_key);

IF EXISTS (SELECT *
           FROM   sys.indexes
           WHERE  NAME = 'fact_sales_dim_date'
                  AND object_id = Object_id('FactSales'))
  DROP INDEX FactSales.fact_sales_dim_date;

CREATE INDEX fact_sales_dim_date
  ON FactSales(order_date_key); 