/*
Script purpose: 
This script creates a new database named "DataWarehouse"
The script set up three schemas within the database : "Bronze","Sliver","Gold"
*/

Use master;
Go

--Create Database
Create Database DataWarehouse;
Go
Use DataWarehouse;
Go

--Create Schemas
Create Schema Bronze;
Go
Create Schema Silver;
Go
Create Schema Gold;
Go
