$PBExportHeader$w_master_detail_ancestor.srw
forward
global type w_master_detail_ancestor from w_pbtutor_basesheet
end type
type dw_detail from u_dwstandard within w_master_detail_ancestor
end type
type dw_master from u_dwstandard within w_master_detail_ancestor
end type
end forward

global type w_master_detail_ancestor from w_pbtutor_basesheet
string menuname = "m_my_sheet"
event ue_retrive ( )
event ue_insert ( )
event ue_update ( )
event ue_delete ( )
dw_detail dw_detail
dw_master dw_master
end type
global w_master_detail_ancestor w_master_detail_ancestor

type variables
String is_modalita = "E"	//E=elenco, T=testata righe
end variables

event ue_retrive();IF dw_master.Retrieve() <> -1 THEN
    dw_master.SetFocus()
    dw_master.SetRowFocusIndicator(Hand!)
END IF
end event

event ue_insert();if  is_modalita = "E" then 
	dw_detail.Reset()
end if 
dw_detail.InsertRow(0)
dw_detail.SetFocus()
end event

event ue_update();	
boolean lb_esito                            //true se l'esito dell'aggiornamento è ok

lb_esito = true                                //per defaul l'lb esito viene posto a true

IF is_modalita <> 'E' THEN                          //se modalità è diverso da e (elenco) viene aggiornata anche la testata
               //salvataggio dw_master inserito solo in w_order perchè non è un evento che devono ereditare tutte le dw
               IF dw_master.Update() <> 1 THEN
                              
                              //Aggiornamento fallito
                              lb_esito = false
               
               END IF
END IF   
//se l'aggiornamento della testata è andato a buon fine o se sieamo in modalitè elenco. viene fatto il salvataggio
IF lb_esito = true  THEN
               
               IF dw_detail.Update() <> 1 THEN
                              
                              lb_esito = false
               END IF
               
END IF

IF lb_esito = true  THEN

                              COMMIT using SQLCA;
                              MessageBox("Save","Save succeeded")
ELSE
                              ROLLBACK using SQLCA;
END IF

end event

event ue_delete();dw_detail.DeleteRow(0)
end event

on w_master_detail_ancestor.create
int iCurrent
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_my_sheet" then this.MenuID = create m_my_sheet
this.dw_detail=create dw_detail
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detail
this.Control[iCurrent+2]=this.dw_master
end on

on w_master_detail_ancestor.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_detail)
destroy(this.dw_master)
end on

event open;call super::open;dw_master.settransobject ( sqlca )
dw_detail.settransobject ( sqlca )
this.EVENT ue_retrive()
end event

type dw_detail from u_dwstandard within w_master_detail_ancestor
integer x = 37
integer y = 420
integer width = 617
integer height = 368
integer taborder = 20
end type

type dw_master from u_dwstandard within w_master_detail_ancestor
integer x = 27
integer y = 32
integer width = 635
integer height = 348
integer taborder = 10
boolean vscrollbar = true
end type

event rowfocuschanged;call super::rowfocuschanged;long ll_itemnum

ll_itemnum = this.object.data[currentrow, 1]

IF dw_detail.Retrieve(ll_itemnum) = -1 THEN
 MessageBox("Retrieve","Retrieve error-detail")
END IF
end event

