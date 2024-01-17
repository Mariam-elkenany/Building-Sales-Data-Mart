use master
go
if db_id('MyAdventureWorks2017') is not null
drop database MyAdventureWorks2017;

create database MyAdventureWorks2017;
go
