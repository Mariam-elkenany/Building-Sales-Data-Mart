use MyAdventureWorks2017
go

-- Drop foregin Keys if exists
IF EXISTS (SELECT *
           FROM   sys.foreign_keys
           WHERE  NAME = 'fk_fact_sales_dim_customer'
                  AND parent_object_id = Object_id('FactSales'))
	ALTER TABLE FactSales
    DROP CONSTRAINT fk_fact_sales_dim_customer;

-- Drop and create the table
IF EXISTS (SELECT *
           FROM   sys.tables
           WHERE  NAME = 'CustomerDim')
  DROP TABLE CustomerDim

go

CREATE TABLE CustomerDim
  (
     customer_key       INT NOT NULL IDENTITY(1, 1),
     customer_id        INT NOT NULL,
     customer_name      NVARCHAR(150),
     address1           NVARCHAR(100),
     address2           NVARCHAR(100),
     city               NVARCHAR(30),
     phone              NVARCHAR(25),
     -- birth_date date,
     -- marital_status char(10),
     -- gender char(1),
     -- yearly_income money,
     -- education varchar(50),
     source_sys_code TINYINT NOT NULL,
     start_date         DATETIME NOT NULL DEFAULT (Getdate()),
     end_date           DATETIME NULL,
     is_current         TINYINT NOT NULL DEFAULT (1),
     CONSTRAINT pk_dim_customer PRIMARY KEY CLUSTERED (customer_key)
  );

-- Create Foreign Keys
IF EXISTS (SELECT *
           FROM   sys.tables
           WHERE  NAME = 'FactSales'
                  AND type = 'u')
  ALTER TABLE FactSales
    ADD CONSTRAINT fk_fact_sales_dim_customer FOREIGN KEY (customer_key)
    REFERENCES CustomerDim(customer_key);

-- Insert unknown record
SET IDENTITY_INSERT CustomerDim ON

INSERT INTO CustomerDim
            (customer_key,
             customer_id,
             customer_name,
             address1,
             address2,
             city,
             phone,
             source_sys_code,
             start_date,
             end_date,
             is_current)
VALUES      (0,
             0,
             'Unknown',
             'Unknown',
             'Unknown',
             'Unknown',
             'Unknown',
             0,
             '1900-01-01',
             NULL,
             1 )

SET IDENTITY_INSERT CustomerDim OFF

-- Create Indexes
IF EXISTS (SELECT *
           FROM   sys.indexes
           WHERE  NAME = 'dim_customer_customer_id'
                  AND object_id = Object_id('CustomerDim'))
  DROP INDEX CustomerDim.dim_customer_customer_id

go

CREATE INDEX dim_customer_customer_id
  ON CustomerDim(customer_id);

IF EXISTS (SELECT *
           FROM   sys.indexes
           WHERE  NAME = 'dim_customer_city'
                  AND object_id = Object_id('CustomerDim'))
  DROP INDEX CustomerDim.dim_customer_city

go

CREATE INDEX dim_customer_city
  ON CustomerDim(city); 