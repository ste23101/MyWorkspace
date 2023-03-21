$PBExportHeader$w_order.srw
$PBExportComments$SN - 06/03/2023. Datawindow usata per la visualizzazione degli ordini
forward
global type w_order from w_master_detail_ancestor
end type
type cb_insert_header from commandbutton within w_order
end type
type cb_delete_header from commandbutton within w_order
end type
type cb_insert_detail from commandbutton within w_order
end type
type cb_delete_detail from commandbutton within w_order
end type
end forward

global type w_order from w_master_detail_ancestor
string tag = "Mantain Orders"
integer width = 3607
integer height = 2076
string is_modalita = "T"
cb_insert_header cb_insert_header
cb_delete_header cb_delete_header
cb_insert_detail cb_insert_detail
cb_delete_detail cb_delete_detail
end type
global w_order w_order

forward prototypes
public function boolean wf_cancella_detail (long al_riga)
end prototypes

public function boolean wf_cancella_detail (long al_riga);IF al_riga > 0 THEN
               dw_detail.DeleteRow(al_riga)
               return true
END IF

end function

on w_order.create
int iCurrent
call super::create
this.cb_insert_header=create cb_insert_header
this.cb_delete_header=create cb_delete_header
this.cb_insert_detail=create cb_insert_detail
this.cb_delete_detail=create cb_delete_detail
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_insert_header
this.Control[iCurrent+2]=this.cb_delete_header
this.Control[iCurrent+3]=this.cb_insert_detail
this.Control[iCurrent+4]=this.cb_delete_detail
end on

on w_order.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_insert_header)
destroy(this.cb_delete_header)
destroy(this.cb_insert_detail)
destroy(this.cb_delete_detail)
end on

event ue_insert;call super::ue_insert;
long ll_num_ord	//memorizzo il numero dell'ordine
long ll_row_count 	//memorizzo numero righe totali
long ll_max_index //indice più alto tra quelli presenti
long ll_index


if dw_master.RowCount() > 0 then
	//cerco il numero di righe inserito
	ll_row_count = dw_detail.RowCount()
	if ll_row_count > 0 then
		//ricerco il numero dell'ordine in testata
		ll_num_ord = dw_master.Object.ort_num[dw_master.GetRow()]
		//imposto il numero dell'ordine
		dw_detail.Object.ord_num[ll_row_count] = ll_num_ord
		
		ll_max_index = 0
		for ll_index = 1 to (ll_row_count - 1)
			ll_max_index = max(ll_max_index,dw_detail.Object.ord_pos[ll_index])
		next
		dw_detail.Object.ord_pos[ll_row_count]	= ll_max_index + 1
	end if
   	//  
end if



	

end event

type dw_detail from w_master_detail_ancestor`dw_detail within w_order
integer x = 41
integer y = 864
integer width = 3113
integer height = 416
string dataobject = "d_order_detail"
boolean vscrollbar = true
end type

event dw_detail::itemchanged;call super::itemchanged;String ls_articolo,ls_descrizione
long ll_count

if Dwo.name = "ord_art" then
	SELECT tbart.art_cod, tbart.art_des, count(*)
	INTO :ls_articolo, :ls_descrizione, :ll_count
	FROM tbart
	WHERE tbart.art_cod = :data
	GROUP BY  tbart.art_cod, tbart.art_des;	
	
	if ll_count > 0 then
		this.Object.tbart_art_des[row] = ls_descrizione
	else
		MessageBox("Errore","L'articolo inserito è inesistente")
		RETURN 2
	end if
end if
end event

type dw_master from w_master_detail_ancestor`dw_master within w_order
integer width = 2816
integer height = 596
string dataobject = "d_order_header"
end type

event dw_master::itemchanged;call super::itemchanged;String ls_fornitore,ls_ragione_sociale
long ll_count

if Dwo.name = "ort_for" then
	SELECT tbfor.for_cod, tbfor.for_ragsoc, count(*)
	INTO :ls_fornitore, :ls_ragione_sociale, :ll_count
	FROM tbfor
	WHERE tbfor.for_cod = :data
	GROUP BY  tbfor.for_cod, tbfor.for_ragsoc;	
	
	if ll_count > 0 then
		this.Object.tbfor_for_ragsoc[row] = ls_ragione_sociale
	else
		MessageBox("Errore","Il fornitore inserito è inesistente")
		RETURN 2
	end if
end if

end event

type cb_insert_header from commandbutton within w_order
integer x = 3031
integer y = 60
integer width = 443
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Insert Header"
end type

event clicked;dw_master.InsertRow(0)

long ll_row_count //numero ultima riga inserita
long ll_max_index  //indice massimo delle righe testata
long ll_index  //indice iniziale da cui ciclare il for
ll_row_count = dw_master.RowCount()

IF  ll_row_count > 0 THEN
                              
                              //Ciclo for per ciclare tutte le righe della tabella testata
              ll_max_index = 0
              
			 FOR ll_index = 1 TO ll_row_count
              IF  dw_master.Object.ort_num[ll_index] > ll_max_index THEN
                                                           ll_max_index =dw_master.Object.ort_num[ll_index]
                                            END IF
               NEXT
                              
                              dw_master.Object.ort_num[ll_row_count] = ll_max_index +1
                              dw_master.ScrollToRow(ll_row_count)
                              //MessageBox("Massimo: " + String(ll_max_index))
               
END IF

cb_insert_detail.POST triggerEvent(clicked!)
dw_master.POST SetFocus()

end event

type cb_delete_header from commandbutton within w_order
integer x = 3045
integer y = 192
integer width = 425
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Delete Header"
end type

event clicked;long ll_index  //indice per il for
long ll_num_ord //numero riga selezionato
long ll_confirm_button // 1= ok, 2= annulla se -1= errore
ll_num_ord = dw_master.GetRow()

IF ll_num_ord > 0 THEN
               ll_confirm_button = messageBox("Conferma eliminazione", "Sei sicuro di voler eliminare il campo?", Exclamation! ,OkCancel!)
               
               //accedo all'if solo se premo ok
               IF ll_confirm_button = 1 THEN
                              //ciclo tutte le righe
                              FOR ll_index = dw_detail.RowCount() to 1 step -1
                                            wf_cancella_detail(ll_index)
                              NEXT
                              dw_detail.update()
                              dw_master.DeleteRow(ll_num_ord)
                              dw_master.update()
               END IF
               
END IF

end event

type cb_insert_detail from commandbutton within w_order
integer x = 3145
integer y = 884
integer width = 402
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "InsertDetail"
end type

event clicked;IF  is_modalita = 'E' THEN 
               dw_detail.Reset()
END IF 
dw_detail.InsertRow(0)
dw_detail.SetFocus()

long ll_num_ord  //memorizzo il numero dell'ordine
long ll_row_count  //numero ultima riga inserita
long ll_max_index  //indice massimo delle righe dettaglio
long ll_index  //indice iniziale da cui ciclare il for


IF  dw_master.RowCount() > 0 THEN
               //Cerco numero di righe inserito
               ll_row_count = dw_detail.RowCount()
               
               IF  ll_row_count > 0 THEN
                              
                              //Ricerco il numero dell'ordine in testata
                              ll_num_ord = dw_master.Object.ort_num[dw_master.GetRow()]
                              //MessageBox("Verifica numero", "Numero inserito: " + String(ll_num_ord))
                              //Imposto il numero dell'ordine
                              dw_detail.Object.ord_num[ll_row_count] = ll_num_ord
                              
                              //Ciclo for per ciclare tutte le righe della tabella dettaglio
                              ll_max_index = 0
                              FOR ll_index = 1 TO ll_row_count
              IF  dw_detail.Object.ord_pos[ll_index] > ll_max_index THEN
                                                           ll_max_index =dw_detail.Object.ord_pos[ll_index]
                                            END IF
               NEXT
                              
                              dw_detail.Object.ord_pos[ll_row_count] = ll_max_index +1
                              //MessageBox("Massimo: " + String(ll_max_index))
               END IF
               
END IF

end event

type cb_delete_detail from commandbutton within w_order
integer x = 3195
integer y = 1108
integer width = 402
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Delete Detail"
end type

event clicked;IF dw_detail.GetRow() > 0 THEN
               wf_cancella_detail(dw_detail.GetRow())
END IF

end event

