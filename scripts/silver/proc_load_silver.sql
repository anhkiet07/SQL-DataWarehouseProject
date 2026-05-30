/*
==============================================================================
Stored Procedure : Load silver layer   
==============================================================================
Script Purpose:
  This store procedure perfoems the ETL process to populate the 'Silver' Schema tables from the 'bronze' schema.
Actions Performed:
  - Truncates Silver tabled.
  - Insert transformed and cleansed data from Bronze into Silver tables

Parameters:
    None
    This stored procedure does not accept any parameters or return ant vales

Usage Example:
      EXEC Silver.load_silver
===============================================================================
*/


exec Silver.load_silver

Create or Alter procedure Silver.load_silver as 
begin
Declare @start_time datetime, @end_time datetime, @batch_start_time datetime, @batch_end_time datetime;
Begin try
	Set @batch_start_time = getdate();
	Print '=========================================='
	Print ' Loading Silver Layer';
	Print '=========================================='

	Print '------------------------------------------'
	Print 'Loading CRM Tables';
	Print '------------------------------------------'

	Set @start_time = Getdate();
	Print '>> Truncating Table: Silver.crm_cust_info';
	Truncate Table Silver.crm_cust_info
	Print '>>Inserting Data Into: Silver.crm_cust_info';
	insert into Silver.crm_cust_info(
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cs_martial_status,
	cst_gndr,
	cst_create_date) 
	select
		cst_id,
		cst_key,
		trim(cst_firstname) as cst_firstname,
		trim(cst_lastname) as cst_lastname,
		case when upper(trim(cs_martial_status)) = 'M' then 'Married'
			 when upper(trim(cs_martial_status)) = 'S' then 'Single'
			 else 'n/a'
		end cs_martial_status,
		case when upper(trim(cst_gndr)) = 'F' then 'Female' 
			 when upper(trim(cst_gndr)) = 'M' then 'Male'
			 else 'n/a'
		end cst_gndr,
		cst_create_date
	from (
	select * ,
	row_number() over (partition by cst_id order by cst_create_date desc) as flag_last
	from Bronze.crm_cust_info
	where cst_id is not null)t
	where flag_last = 1 
	set @end_time = GETDATE();
	Print '>> Load Duration: ' + Cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';
	print '>> -------------';

	Set @start_time = GETDATE();
	Print'>>Truncating Table : Silver.crm_prd_info';
	Truncate table Silver.crm_prd_info;
	Print'>> Inserting Data into : Silver.crm_prd_info';
	insert into Silver.crm_prd_info(
		prd_id,
		cat_id ,
		prd_key ,
		prd_nm ,
		prd_cost ,
		prd_line ,
		prd_start_dt,
		prd_end_dt
	)
	select 
		prd_id,
		replace(substring(prd_key, 1, 5), '-','_') as cat_id,
		substring(prd_key, 7, len(prd_key)) as prd_key,
		prd_nm,
		isnull(prd_cost,0) as prd_cost,
		case when upper(trim(prd_line)) = 'R' then 'Road'
			 when upper(trim(prd_line)) = 'M' then 'Mountain'
			 when upper(trim(prd_line)) = 'S' then 'Other Sales'
			 when upper(trim(prd_line)) = 'T' then 'Touring'
			 else 'n/a'
		end prd_line,
		cast(prd_start_dt as date) as prd_start_dt,
		cast(lead(prd_start_dt) over(partition by prd_key order by prd_start_dt) - 1 as date) as prd_end_dt
	from Bronze.crm_prd_info
	set @end_time = GETDATE();
	Print '>> Load Duration: ' + Cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';
	print '>> -------------';

	Set @start_time = getdate();
	Print '>>Trucating Table: Silver.crm_sales_details';
	Truncate table Silver.crm_sales_details
	Print '>> Inserting Data into: Silver.crm_sales_details';
	insert into Silver.crm_sales_details(
		 sls_ord_num, 
		 sls_prd_key,
		 sls_cust_id,
		 sls_order_dt,
		 sls_ship_dt,
		 sls_due_dt,
		 sls_sales,
		 sls_quantity,
		 sls_price
	)
	select
		 sls_ord_num,
		 sls_prd_key,
		 sls_cust_id,
		 case when sls_order_dt = 0 or len(sls_order_dt) != 8 then NULL
		 else cast(cast(sls_order_dt as varchar) as date)
		 end sls_order_dt,
		 case when sls_ship_dt = 0 or len(sls_ship_dt) != 8 then NULL
		 else cast(cast(sls_ship_dt as varchar) as date)
		 end sls_ship_dt,
		 case when sls_due_dt = 0 or len(sls_due_dt) != 8 then NULL
		 else cast(cast(sls_due_dt as varchar) as date)
		 end sls_due_dt,
		 case when sls_sales <= 0 or sls_sales is null or sls_sales != sls_quantity * ABS(sls_price)
		 then sls_quantity * ABS(sls_price)
		 else sls_sales
		 end sls_sales,
		 sls_quantity,
		 case when sls_price <= 0 or sls_price is null
		 then sls_sales/ nullif(sls_quantity, 0)
		 else sls_price
		 end sls_price
	from Bronze.crm_sales_details
	set @end_time = GETDATE();
	Print '>> Load Duration: ' + Cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';
	print '>> -------------';

	set @start_time = getdate()
	Print '>>Truncating Table : Silver.erp_cust_az12';
	Truncate table Silver.erp_cust_az12;
	Print '>> Inserting Data into table : Silver.erp_cust_az12'
	insert into Silver.erp_cust_az12(
	CID,
	BDATE,
	GEN
	)
	select 
	case when CID like 'NAS%' then substring(CID, 4, len(CID))
	else CID
	end CID, 
	case when BDATE > Getdate() then Null
	else BDATE
	end BDATE,
	case when upper(trim(GEN)) In ('F' ,'FEMALE') then 'Female'
		 when upper(trim(GEN)) In ('M' ,'MALE') then 'Male'
	else 'n/a'
	end GEN
	from Bronze.erp_cust_az12
	set @end_time = GETDATE();
	Print '>> Load Duration: ' + Cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';
	print '>> -------------';


	Set @start_time = GETDATE();
	Print '>> Truncating Table :Silver.erp_Loc_a101';
	Truncate table Silver.erp_Loc_a101;
	Print '>> Inserting Data into : Silver.erp_Loc_a101';
	insert into Silver.erp_Loc_a101 (
		 CID,
		 CNTRY
	)
	select
		 Replace(CID,'-','') CID,
		 case when trim(cntry) = 'DE' then 'Germany'
			  when trim(cntry) in ('USA', 'US') then 'United States'
			  when trim(cntry) = '' or CNTRY is null then 'n/a'
			  else CNTRY
		 end CNTRY
	from Bronze.erp_Loc_a101
	set @end_time = GETDATE();
	Print '>> Load Duration: ' + Cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';
	print '>> -------------';

	Set @start_time =getdate()
	Print '>> Truncating table : Silver.erp_px_cat_g1v2';
	Truncate table Silver.erp_px_cat_g1v2;
	Print '>> Inserting Data into : Silver.erp_px_cat_g1v2';
	insert into Silver.erp_px_cat_g1v2(
		 ID,
		 CAT, 
		 SUBCAT,
		 MAINTENANCE
	)
	select 
		 ID,
		 CAT,
		 SUBCAT,
		 MAINTENANCE
	from Bronze.erp_px_cat_g1v2
	set @end_time = GETDATE();
	Print '>> Load Duration: ' + Cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';
	print '>> -------------';

	Set @batch_end_time = getdate();
	Print '========================================='
	Print 'Loading Silver Layer is completed';
	Print '	  - Total Load Duration: ' +cast(datediff(second, @batch_start_time, @batch_end_time) as nvarchar) + ' seconds'

	End TRY
	Begin catch
		Print '================================'
		Print 'Error occured during loading Bronze Layer';
		Print 'Error message' + Error_message();
		Print 'Error message' + cast(error_number() as nvarchar);
		Print 'Error message' + cast(error_state() as nvarchar);
		Print '================================='
	End catch
End
