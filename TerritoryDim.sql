use MyAdventureWorks2017
go

-- dropping the foreign keys
IF EXISTS (SELECT *
           FROM   sys.foreign_keys
           WHERE  NAME = 'fk_fact_sales_dim_territory'
                  AND parent_object_id = Object_id('FactSales'))
	ALTER TABLE FactSales
    DROP CONSTRAINT fk_fact_sales_dim_territory;

-- Drop and create the table
IF EXISTS (SELECT *
           FROM   sys.objects
           WHERE  NAME = 'TerritoryDim'
                  AND type = 'U')
  DROP TABLE TerritoryDim

go

CREATE TABLE TerritoryDim
  (
     territory_key      INT NOT NULL IDENTITY(1, 1),
     territory_id       INT NOT NULL,
     territory_name     NVARCHAR(50),
     territory_country  NVARCHAR(400),
     territory_group    NVARCHAR(50),
     source_sys_code TINYINT NOT NULL,
     start_date         DATETIME NOT NULL DEFAULT (Getdate()),
     end_date           DATETIME,
     is_current         TINYINT NOT NULL DEFAULT (1),
     CONSTRAINT pk_dim_territory PRIMARY KEY CLUSTERED (territory_key)
  );

-- Insert unknown record
SET IDENTITY_INSERT TerritoryDim ON

INSERT INTO TerritoryDim
            (territory_key,
             territory_id,
             territory_name,
             territory_country,
             territory_group,
             source_sys_code,
             start_date,
             end_date,
             is_current)
VALUES     (0,
            0,
            'Unknown',
            'Unknown',
            'Unknown',
            0,
            '1900-01-01',
            NULL,
            1)

SET IDENTITY_INSERT TerritoryDim OFF

-- create foreign key
IF EXISTS (SELECT *
           FROM   sys.tables
           WHERE  NAME = 'FactSales')
	ALTER TABLE FactSales
    ADD CONSTRAINT fk_fact_sales_dim_territory FOREIGN KEY (territory_key)
    REFERENCES TerritoryDim(territory_key);

-- create indexes
IF EXISTS (SELECT *
           FROM   sys.indexes
           WHERE  NAME = 'dim_territory_territory_code'
                  AND object_id = Object_id('TerritoryDim'))
  DROP INDEX TerritoryDim.dim_territory_territory_code;

CREATE INDEX dim_territory_territory_id
ON TerritoryDim(territory_id); 