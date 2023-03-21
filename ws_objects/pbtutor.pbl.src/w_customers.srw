$PBExportHeader$w_customers.srw
$PBExportComments$Customer sheet window inheriting from w_master_detail_ancestor.
forward
global type w_customers from w_master_detail_ancestor
end type
end forward

global type w_customers from w_master_detail_ancestor
string tag = "Mantain Customers"
end type
global w_customers w_customers

on w_customers.create
call super::create
end on

on w_customers.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_detail from w_master_detail_ancestor`dw_detail within w_customers
integer width = 1152
integer height = 420
string dataobject = "d_customer"
end type

type dw_master from w_master_detail_ancestor`dw_master within w_customers
integer width = 1143
integer height = 344
string dataobject = "d_cutlist"
end type

