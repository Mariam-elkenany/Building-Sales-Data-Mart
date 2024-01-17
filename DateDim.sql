use MyAdventureWorks2017
go

-- drop foreign key if exists
IF EXISTS (SELECT *
           FROM   sys.foreign_keys
           WHERE  NAME = 'fk_fact_sales_dim_date'
                  AND parent_object_id = Object_id('FactSales'))
  ALTER TABLE FactSales
    DROP CONSTRAINT fk_fact_sales_dim_date;

-- drop and create the table
IF EXISTS (SELECT *
           FROM   sys.tables
           WHERE  NAME = 'DateDim')
  DROP TABLE DateDim;

CREATE TABLE DateDim
  (
     date_key            INT NOT NULL,
     full_date           DATE NOT NULL,
     calendar_year       INT NOT NULL,
     calendar_quarter    INT NOT NULL,
     calendar_month_num  INT NOT NULL,
     calendar_month_name NVARCHAR(15) NOT NULL
     CONSTRAINT pk_dim_date PRIMARY KEY CLUSTERED (date_key)
  ); 