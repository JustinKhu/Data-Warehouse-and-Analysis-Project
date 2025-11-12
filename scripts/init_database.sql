/*
-----------------------------------------------------------------------------------
Creating the Database and Schemas 
-----------------------------------------------------------------------------------
Script Purpose: 
  This script will create a new databse 'DataWarehouse'. It will then create the required schemas for this project, named 'bronze', 'silver', and 'gold'. 

*/

-- Creating the Database 'DataWarehouse' 

USE master; 

CREATE DATABASE DataWarehouse;

USE DataWarehouse; 

-- Create Schemas 
CREATE SCHEMA bronze; 
GO

CREATE SCHEMA silver; 
GO

CREATE SCHEMA gold; 
GO
