$PBExportHeader$w_products.srw
$PBExportComments$Product sheet window inheriting from w_master_detail_ancestor.
forward
global type w_products from w_master_detail_ancestor
end type
end forward

global type w_products from w_master_detail_ancestor
string tag = "Mantain Products"
integer width = 2523
integer height = 1436
end type
global w_products w_products

on w_products.create
call super::create
end on

on w_products.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_detail from w_master_detail_ancestor`dw_detail within w_products
integer width = 1550
integer height = 756
string dataobject = "d_product"
end type

type dw_master from w_master_detail_ancestor`dw_master within w_products
integer width = 2327
integer height = 384
string dataobject = "d_prodlist"
end type

