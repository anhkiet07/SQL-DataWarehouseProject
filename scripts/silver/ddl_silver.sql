/*
======================================================
DDL Scripts : Create Silver Table 
======================================================
Script Purpose :
- This script will create table in the 'silver' schema if not already exits
======================================================
*/



if OBJECT_ID ('Silver.crm_cust_info', 'U') is not null
drop table Silver.crm_cust_info;
GO
create table Silver.crm_cust_info (
	cst_id int ,
	cst_key nvarchar(50),
	cst_firstname nvarchar(50),
	cst_lastname nvarchar(50),
	cs_martial_status nvarchar(50),
	cst_gndr nvarchar(50),
	cst_create_date date,
	dwh_create_date datetime2 default getdate()
);
GO
if OBJECT_ID ('Silver.crm_prd_info', 'U') is not null
drop table Silver.crm_prd_info;
GO
create table Silver.crm_prd_info (
	prd_id int,
	cat_id nvarchar(50),
	prd_key nvarchar(50),
	prd_nm nvarchar(50),
	prd_cost int,
	prd_line nvarchar(50),
	prd_start_dt date,
	prd_end_dt date,
	dwh_create_date datetime2 default getdate()
);
GO
if OBJECT_ID ('Silver.crm_sales_details', 'U') is not null
drop table Silver.crm_sales_details;
GO
create table Silver.crm_sales_details (
	sls_ord_num nvarchar(50),
	sls_prd_key nvarchar(50),
	sls_cust_id int,
	sls_order_dt date,
	sls_ship_dt date,
	sls_due_dt date,
	sls_sales int,
	sls_quantity int,
	sls_price int,
	dwh_create_date datetime2 default getdate()
);
GO
if OBJECT_ID ('Silver.erp_cust_az12', 'U') is not null
drop table Silver.erp_cust_az12;
GO
create table Silver.erp_cust_az12 (
	CID nvarchar(50),
	BDATE date,
	GEN nvarchar(10),
	dwh_create_date datetime2 default getdate()
);
GO
if OBJECT_ID ('Silver.erp_Loc_a101', 'U') is not null
drop table Silver.erp_Loc_a101;
GO
create table Silver.erp_Loc_a101 (
	CID nvarchar(50),
	CNTRY nvarchar(30),
	dwh_create_date datetime2 default getdate()
);
GO
if OBJECT_ID ('Silver.erp_px_cat_g1v2', 'U') is not null
drop table Silver.erp_px_cat_g1v2;
GO
create table Silver.erp_px_cat_g1v2 (
	ID nvarchar(10),
	CAT nvarchar(50),
	SUBCAT nvarchar(50),
	MAINTENANCE nvarchar(10),
	dwh_create_date datetime2 default getdate()
);
GO
