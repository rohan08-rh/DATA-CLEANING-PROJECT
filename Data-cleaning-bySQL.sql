/* 
Cleaning Data in SQL Queries 
===========================================================
                    SKILLS USED
===========================================================

-- Database:
MySQL / SQL

-- Data Cleaning:
Data Cleaning
Data Preprocessing
Data Standardization
Handling NULL Values
Data Validation

-- Data Transformation:
String Manipulation
REPLACE()
SUBSTRING_INDEX()
Data Type Conversion

-- Database Operations:
SELECT
UPDATE
ALTER TABLE
ADD COLUMN
DROP COLUMN
CREATE TABLE

-- Database Management:
Table Management
Column Management
Backup Creation
Schema Modification
INFORMATION_SCHEMA

-- SQL Concepts:
Filtering
Subqueries
Conditional Data Cleaning
Data Transformation

===========================================================
*/
 
SELECT * FROM data3.laptops;

-------------------------------------------------------------------------------------------------------------------------- 
 
-- Create Backup Table

CREATE TABLE latops_backup LIKE laptops;

--------------------------------------------------------------------------------------------------------------------------

-- Check if the laptops table exists

SELECT * FROM information_schema.TABLES
WHERE TABLE_SCHEMA='data3'
AND TABLE_NAME='laptops';

--------------------------------------------------------------------------------------------------------------------------

-- Check for completely NULL records

SELECT * FROM data3.laptops
WHERE Company IS NULL AND Product IS NULL AND TypeName IS NULL AND ScreenResolution IS NULL
AND Cpu IS NULL AND Ram IS NULL AND Ram IS NULL AND Memory IS NULL AND Gpu IS NULL AND OpSys IS NULL AND Weight IS NULL AND
Price_euros IS NULL;

--------------------------------------------------------------------------------------------------------------------------

-- View laptop data before cleaning

SELECT * FROM data3.laptops l1;

--------------------------------------------------------------------------------------------------------------------------

-- Change Weight column data type

ALTER TABLE data3.laptops MODIFY COLUMN Weight INT;

--------------------------------------------------------------------------------------------------------------------------

-- Verify the laptops table structure

SELECT * FROM information_schema.TABLES
WHERE TABLE_SCHEMA='data3'
AND TABLE_NAME='laptops';

--------------------------------------------------------------------------------------------------------------------------



-- Remove GB from RAM values
UPDATE data3.laptops l1
SET l1.Ram =(SELECT REPLACE(RAM,'GB','') FROM data3.laptops l2 WHERE l2.laptop_ID=l1.laptop_ID);

--------------------------------------------------------------------------------------------------------------------------



-- Remove kg from Weight values
UPDATE data3.laptops
SET Weight = REPLACE(Weight, 'kg', '');

--------------------------------------------------------------------------------------------------------------------------

-- Round laptop prices to the nearest integer

UPDATE data3.laptops
SET Price_euros = ROUND(Price_euros);

--------------------------------------------------------------------------------------------------------------------------

-- Change Price_euros column data type to INT

ALTER TABLE data3.laptops MODIFY COLUMN Price_euros INT;

--------------------------------------------------------------------------------------------------------------------------

-- Extract GPU Brand/Name from GPU column

UPDATE laptops
SET Gpu_name=SUBSTRING_INDEX(Gpu,' ',1);

SELECT * FROM laptops;

--------------------------------------------------------------------------------------------------------------------------

-- Extract GPU Brand from GPU column

UPDATE laptops
SET Gpu_brand=SUBSTRING_INDEX(Gpu,' ',-1);

SELECT * FROM laptops;

--------------------------------------------------------------------------------------------------------------------------

-- Remove the original GPU column after extracting required information

ALTER TABLE laptops
DROP COLUMN Gpu;

SELECT * FROM laptops;

--------------------------------------------------------------------------------------------------------------------------

-- Add separate columns for CPU Name, CPU Brand and CPU Speed

ALTER TABLE laptops
ADD COLUMN cpu_name VARCHAR(40) AFTER cpu ,
ADD COLUMN cpu_brand VARCHAR(40) AFTER cpu_name,
ADD COLUMN cpu_speed VARCHAR(255) AFTER cpu_brand;

--------------------------------------------------------------------------------------------------------------------------

-- Extract CPU Brand from CPU column

UPDATE laptops
SET cpu_brand=SUBSTRING_INDEX(Cpu,' ',1);

--------------------------------------------------------------------------------------------------------------------------

-- Extract CPU Speed from CPU column

UPDATE laptops
SET Cpu_speed=SUBSTRING_INDEX(Cpu,' ',-1);
