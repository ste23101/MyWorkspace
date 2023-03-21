$PBExportHeader$w_order_sn.srw
forward
global type w_order_sn from w_master_detail_ancestor
end type
end forward

global type w_order_sn from w_master_detail_ancestor
integer width = 4283
integer height = 1736
end type
global w_order_sn w_order_sn

on w_order_sn.create
call super::create
end on

on w_order_sn.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_detail from w_master_detail_ancestor`dw_detail within w_order_sn
integer x = 0
integer y = 924
integer width = 4233
integer height = 572
string dataobject = "d_order_detail_sn"
end type

type dw_master from w_master_detail_ancestor`dw_master within w_order_sn
integer x = 37
integer y = 40
integer width = 4178
integer height = 868
string dataobject = "d_order_header_sn"
end type

