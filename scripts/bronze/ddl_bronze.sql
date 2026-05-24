/*

DDL Script: Create Bronze Table
Script Purpose : Creates tables in 'Bronze' schema

*/

if OBJECT_ID ('Bronze.crm_cust_info', 'U') is not null
drop table Bronze.crm_cust_info;
create table Bronze.crm_cust_info (
	cst_id int ,
	cst_key nvarchar(50),
	cst_firstname nvarchar(50),
	cst_lastname nvarchar(50),
	cs_martial_status nvarchar(3),
	cst_gndr nvarchar(3),
	cst_create_date date
);
GO
if OBJECT_ID ('Bronze.crm_prd_info', 'U') is not null
drop table Bronze.crm_prd_info;
create table Bronze.crm_prd_info (
	prd_id int,
	prd_key nvarchar(50),
	prd_nm nvarchar(50),
	prd_cost int,
	prd_line nvarchar(3),
	prd_start_dt datetime,
	prd_end_dt datetime
);
GO
if OBJECT_ID ('Bronze.crm_sales_details', 'U') is not null
drop table Bronze.crm_sales_details;
create table Bronze.crm_sales_details (
	sls_ord_num nvarchar(50),
	sls_prd_key nvarchar(50),
	sls_cust_id int,
	sls_order_dt int,
	sls_ship_dt int,
	sls_due_dt int,
	sls_sales int,
	sls_quantity int,
	sls_price int
);
GO
if OBJECT_ID ('Bronze.erp_cust_az12', 'U') is not null
drop table Bronze.erp_cust_az12;
create table Bronze.erp_cust_az12 (
	CID nvarchar(50),
	BDATE date,
	GEN nvarchar(10)
);
GO
if OBJECT_ID ('Bronze.erp_Loc_a101', 'U') is not null
drop table Bronze.erp_Loc_a101;
create table Bronze.erp_Loc_a101 (
	CID nvarchar(50),
	CNTRY nvarchar(30)
);
GO
if OBJECT_ID ('Bronze.erp_px_cat_g1v2', 'U') is not null
drop table Bronze.erp_px_cat_g1v2;
create table Bronze.erp_px_cat_g1v2 (
	ID nvarchar(10),
	CAT nvarchar(50),
	SUBCAT nvarchar(50),
	MAINTENANCE nvarchar(10)
);
GO
