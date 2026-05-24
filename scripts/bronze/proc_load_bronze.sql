/*
Stored Procedure: Load Bronze Layer (Source -> Bronze)
Script Purpose : Stored procedure loads data into the 'Bronze' schema from external CSV files 
- Using 'BULK INSERT' command to load from csv files to bronze table.
Parameters: 
None.
Usage example:
EXEC bronze.load_bronze;
*/
Create or alter procedure Bronze.load_bronze as
	begin
		declare @start_time datetime, @end_time datetime, @batch_start_time datetime, @batch_end_time datetime;
		begin try
		set @batch_start_time = GETDATE();
			print'=================================================';
			print'Loading Bronze layer';
			print'=================================================';

			print'-------------------------------------------------';
			print'Loading CRM Tables'
			print'-------------------------------------------------';

			set @start_time = GETDATE();
			print '>> Trucating Table: Bronze.crm_cust_info';
				truncate table Bronze.crm_cust_info;
			print '>> Inserting Data In Table: Bronze.crm_cust_info';
				bulk insert Bronze.crm_cust_info
				from 'C:\Users\anhki\OneDrive\Desktop\NEU\DataWarehouse\source_crm\cust_info.csv'
				with (
					firstrow = 2,
					fieldterminator = ',',
					tablock
				);
			set @end_time = GETDATE();
			print '>> Load Duration: ' + cast(Datediff(second, @start_time, @end_time) as nvarchar) + ' seconds'
			print '------------------'

			set @start_time = GETDATE();
			print '>> Trucating Table: Bronze.crm_prd_info';
				truncate table bronze.crm_prd_info
	
			print '>> Inserting Data In Table: Bronze.crm_prd_info';
				bulk insert bronze.crm_prd_info
				from 'C:\Users\anhki\OneDrive\Desktop\NEU\DataWarehouse\source_crm\prd_info.csv'
				with (
					firstrow = 2,
					fieldterminator = ',',
					tablock
				);
				set @end_time = GETDATE()
				print'>>Load Duration: ' + cast(Datediff(second, @start_time, @end_time) as nvarchar) + ' seconds'
				print'-----------------'

				set @start_time = GETDATE()
			print '>> Trucating Table: Bronze.crm_sales_details';
				truncate table Bronze.crm_sales_details

			print '>> Inserting Data In Table: Bronze.crm_sales_details';
				bulk insert Bronze.crm_sales_details
				from 'C:\Users\anhki\OneDrive\Desktop\NEU\DataWarehouse\source_crm\sales_details.csv'
				with (
					firstrow = 2,
					fieldterminator = ',',
					tablock
				);
				set @end_time = GETDATE()
				print'>>Load Duration: ' + cast(Datediff(second, @start_time, @end_time) as nvarchar) + ' seconds'
				print'-----------------'

			set @start_time = GETDATE()
			print'-------------------------------------------------';
			print'Loading ERP Tables' 
			print'-------------------------------------------------';

			print '>> Trucating Table: Bronze.erp_cust_az12';
				truncate table Bronze.erp_cust_az12

			print '>> Inserting Data In Table: Bronze.erp_cust_az12';
				bulk insert Bronze.erp_cust_az12
				from 'C:\Users\anhki\OneDrive\Desktop\NEU\DataWarehouse\source_errp\cust_az12.csv'
				with (
					firstrow = 2,
					fieldterminator = ',',
					tablock
				);
				set @end_time = GETDATE()
				print'>>Load Duration: ' + cast(Datediff(second, @start_time, @end_time) as nvarchar) + ' seconds'
				print'-----------------'

			set @start_time = GETDATE()
			print '>> Trucating Table: Bronze.erp_Loc_a101';
				truncate table Bronze.erp_Loc_a101

			print '>> Inserting Data In Table: Bronze.erp_Loc_a101';
				bulk insert Bronze.erp_Loc_a101
				from 'C:\Users\anhki\OneDrive\Desktop\NEU\DataWarehouse\source_errp\Loc_a101.csv'
				with (
					firstrow = 2,
					fieldterminator = ',',
					tablock
				);
				set @end_time = GETDATE()
				print'>>Load Duration: ' + cast(Datediff(second, @start_time, @end_time) as nvarchar) + ' seconds'
				print'-----------------'

			set @start_time = GETDATE()
			print '>> Trucating Table: Bronze.erp_px_cat_g1v2';
				truncate table Bronze.erp_px_cat_g1v2

			print '>> Inserting Data In Table: Bronze.erp_px_cat_g1v2';
				bulk insert Bronze.erp_px_cat_g1v2
				from 'C:\Users\anhki\OneDrive\Desktop\NEU\DataWarehouse\source_errp\px_cat_g1v2.csv'
				with (
					firstrow = 2,
					fieldterminator = ',',
					tablock
				);
			set @end_time = GETDATE()
				print'>>Load Duration: ' + cast(Datediff(second, @start_time, @end_time) as nvarchar) + ' seconds'
				print'-----------------'
				
			set @batch_end_time = GETDATE()
				print'================='
				print'Loading Bronze Layer is completed'
				print'  - Total Load Duration: ' + cast(datediff(second, @batch_start_time, @batch_end_time) as nvarchar) + ' seconds'
				print'================='
			end try
		begin catch
			print'=================================================';
			print'Error occured during loading bronze layer'
			print'Error Message' + Error_Message();
			print'Error Message' + cast(Error_number() as nvarchar);
			print'Error Message' + cast(Error_state() as nvarchar);
			print'=================================================';
		end catch
end
