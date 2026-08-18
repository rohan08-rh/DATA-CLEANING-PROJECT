USE data;

--------------------------------------------------------------------------------------------------------------------------
-- View the laptops dataset
SELECT * FROM data.laptops1;

--------------------------------------------------------------------------------------------------------------------------

-- Extract CPU speed from the CPU column
UPDATE data.laptops1
SET Cpu_speed=SUBSTRING_INDEX(Cpu,' ',-1);

--------------------------------------------------------------------------------------------------------------------------

-- Remove GB from RAM values

-- REPLACE(column_name, old_text, new_text)
UPDATE laptops1
SET Ram = REPLACE(Ram, 'GB', '');

--------------------------------------------------------------------------------------------------------------------------

-- Extract CPU name by removing CPU brand and CPU speed

UPDATE laptops1
SET Cpu_name=REPLACE(REPLACE(Cpu ,cpu_brand,' '),Cpu_speed,' ');

--------------------------------------------------------------------------------------------------------------------------

-- Remove GPU column

ALTER TABLE laptops1
DROP  COLUMN Gpu;

--------------------------------------------------------------------------------------------------------------------------

-- Remove G from CPU speed values

UPDATE laptops1
SET Cpu_speed = REPLACE(Cpu_speed, 'G', '');

--------------------------------------------------------------------------------------------------------------------------

-- Convert CPU speed column to FLOAT

ALTER TABLE laptops1 MODIFY COLUMN Cpu_speed FLOAT;

--------------------------------------------------------------------------------------------------------------------------

-- Round laptop prices to the nearest integer

UPDATE laptops1
set Price_euros=ROUND(Price_euros);

--------------------------------------------------------------------------------------------------------------------------

-- Standardize operating system names

UPDATE laptops1
SET OpSys = CASE 
    WHEN OpSys LIKE '%Windows%' THEN 'windows'
    WHEN OpSys LIKE '%linux%' THEN 'linux'
	WHEN OpSys LIKE '%mac%' THEN 'macos'
    WHEN OpSys LIKE '%No%' THEN 'N/A'
  ELSE 'others'
END;

--------------------------------------------------------------------------------------------------------------------------

-- Add columns for screen resolution height, width and touchscreen

ALTER TABLE laptops1
ADD COLUMN screenresolution_height VARCHAR(10) AFTER ScreenResolution,
ADD COLUMN screenresolution_width VARCHAR(10) AFTER screenresolution_height,
ADD COLUMN touchscreen VARCHAR(10) AFTER screenresolution_width;

--------------------------------------------------------------------------------------------------------------------------

-- View the updated laptops dataset

SELECT * FROM data.laptops1;

--------------------------------------------------------------------------------------------------------------------------

-- Convert screen resolution width and touchscreen columns to INT

ALTER TABLE laptops1 MODIFY COLUMN screenresolution_width INT;
ALTER TABLE laptops1 MODIFY COLUMN touchscreen INT;

--------------------------------------------------------------------------------------------------------------------------

-- Extract screen resolution height

UPDATE laptops1
SET screenresolution_height= SUBSTRING_INDEX(ScreenResolution,' ',1);

--------------------------------------------------------------------------------------------------------------------------

-- Extract screen resolution width

UPDATE laptops1
SET screenresolution_width=SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution,' ',-1),'x',-1);

--------------------------------------------------------------------------------------------------------------------------

-- Remove the 'x' portion from screen resolution height

UPDATE laptops1
SET screenresolution_height =SUBSTRING_INDEX(screenresolution_height,'x',1);

--------------------------------------------------------------------------------------------------------------------------

-- Identify touchscreen laptops and assign 1 for touchscreen and 0 for non-touchscreen

UPDATE laptops1
SET touchscreen=CASE
    WHEN ScreenResolution LIKE '%Touchscree%' THEN 1
    ELSE 0
    END;



USE data3;

--------------------------------------------------------------------------------------------------------------------------

-- View the laptops dataset

SELECT * FROM data3.laptops1;

--------------------------------------------------------------------------------------------------------------------------

-- Extract screen resolution width

UPDATE laptops1
SET screenresolution_width= SUBSTRING_INDEX(ScreenResolution,' ',1);

--------------------------------------------------------------------------------------------------------------------------

-- Add a column to identify the type of laptop memory

ALTER TABLE data3.laptops1
ADD COLUMN memory_type VARCHAR(100) AFTER Memory;

--------------------------------------------------------------------------------------------------------------------------

-- Categorize laptop memory as Hybrid, SSD, HDD, Flash Storage or Other

UPDATE data3.laptops1
SET memory_type=CASE
   WHEN Memory LIKE '%SSD%' AND Memory LIKE'%HDD%' THEN 'hybrid'
   WHEN Memory LIKE '%SSD%' THEN 'SSD'
   WHEN Memory LIKE '%HDD%' THEN 'HDD'
   WHEN Memory LIKE '%Flash%' THEN 'flash storage'
   ELSE 'other'
   END;

--------------------------------------------------------------------------------------------------------------------------

-- Remove TB and GB units from primary memory values

UPDATE data3.laptops1
SET primary_memory=REPLACE(
        REPLACE(primary_memory,'TB',''),
    'GB','');

--------------------------------------------------------------------------------------------------------------------------

-- Extract secondary memory information from the Memory column

UPDATE data3.laptops1
SET secondary_memory=CASE
   WHEN Memory LIKE '%SSD%' AND Memory LIKE'%HDD%' THEN SUBSTRING_INDEX(Memory,' ',-2)
   WHEN Memory LIKE '%SSD%' THEN '0'
   WHEN Memory LIKE '%HDD%' THEN '0'
   WHEN Memory LIKE '%Flash%' THEN '0'
   ELSE '0'
   END;

--------------------------------------------------------------------------------------------------------------------------

-- Remove storage units from secondary memory values

UPDATE data3.laptops1
SET secondary_memory =
REPLACE(REPLACE(
    REPLACE(
        REPLACE(secondary_memory,'TB HDD',''),
    'GB',''),
'TB',''),'HDD',' ');

--------------------------------------------------------------------------------------------------------------------------

-- Convert secondary memory column to INT

ALTER TABLE data3.laptops1 MODIFY COLUMN secondary_memory INT;

--------------------------------------------------------------------------------------------------------------------------

-- Convert primary memory column to INT

ALTER TABLE data3.laptops1 MODIFY COLUMN primary_memory INT;

--------------------------------------------------------------------------------------------------------------------------

-- Convert primary memory from TB to GB

UPDATE data3.laptops1
SET primary_memory =CASE
WHEN primary_memory LIKE 1 THEN 1024
WHEN primary_memory LIKE 2 THEN 2048
ELSE primary_memory
END;

--------------------------------------------------------------------------------------------------------------------------

-- Remove the original Memory column after extracting required information

ALTER TABLE data3.laptops1
DROP COLUMN Memory;


USE data3;

--------------------------------------------------------------------------------------------------------------------------

-- View the backup table

SELECT * FROM latops_backup;

--------------------------------------------------------------------------------------------------------------------------

-- Create a new laptops table using the backup table structure

-- CREATE TABLE data3.laptops1 LIKE data3.latops_backup;

--------------------------------------------------------------------------------------------------------------------------

-- Insert backup data into the new laptops table

INSERT INTO laptops1
SELECT * FROM latops_backup;

--------------------------------------------------------------------------------------------------------------------------

-- View the newly created laptops table

SELECT * FROM laptops1;

--------------------------------------------------------------------------------------------------------------------------

-- Add separate columns for GPU name and GPU brand

ALTER TABLE laptops1
ADD COLUMN gpu_name VARCHAR(255) AFTER Gpu,
ADD COLUMN gpu_brand VARCHAR(255) AFTER gpu_name;

--------------------------------------------------------------------------------------------------------------------------

-- Extract GPU name from the GPU column

UPDATE laptops1
SET gpu_name=SUBSTRING_INDEX(Gpu,' ',1);

--------------------------------------------------------------------------------------------------------------------------

-- Extract GPU brand from the GPU column

UPDATE laptops1
SET gpu_brand=SUBSTRING_INDEX(Gpu,' ',-2);

--------------------------------------------------------------------------------------------------------------------------

-- Add separate columns for CPU name, CPU brand and CPU speed

ALTER TABLE laptops1
ADD COLUMN cpu_name VARCHAR(255) AFTER Cpu,
ADD COLUMN cpu_brand VARCHAR(255) AFTER cpu_name,
ADD COLUMN cpu_speed VARCHAR(255) AFTER cpu_brand;

--------------------------------------------------------------------------------------------------------------------------

-- Extract CPU speed from the CPU column

UPDATE laptops1
SET cpu_speed=SUBSTRING_INDEX(Cpu,' ',-1);
