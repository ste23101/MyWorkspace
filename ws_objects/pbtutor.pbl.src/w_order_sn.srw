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

event dw_detail::itemchanged;call super::itemchanged;String ls_articolo,ls_descrizione
long ll_count

if Dwo.name = "ord_art_sn" then
	SELECT tbart.art_cod_sn, tbart.art_des_sn, count(*)
	INTO :ls_articolo, :ls_descrizione, :ll_count
	FROM tbart_sn
	WHERE tbart.art_cod_sn = :data
	GROUP BY  tbart.art_cod_sn, tbart.art_des_sn;	
	
	if ll_count > 0 then
		this.Object.tbart_art_des[row] = ls_descrizione
	else
		MessageBox("Errore","L'articolo inserito è inesistente")
		RETURN 2
	end if
end if
end event

type dw_master from w_master_detail_ancestor`dw_master within w_order_sn
integer x = 37
integer y = 40
integer width = 4178
integer height = 868
string dataobject = "d_order_header_sn"
end type

