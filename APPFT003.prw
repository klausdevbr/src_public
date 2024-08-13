#include 'totvs.ch'
#include 'fileio.ch'
#include "fwmvcdef.ch"

/*/
{Protheus.doc} APPFT003
Programa para operacao de rotinas de pesagem.
Novo programa para execucao das operacoes de pesagem em substituicao a rotina APPFT001
@type  User Function
@author Klaus Wolfgram
@since 26/09/2020
@version 1.0
/*/

User Function APPFT003

	Local oDlg      := Nil
	Local oSay      := Nil
	Local oLay      := Nil
	Local oP1       := Nil
	Local oP2       := Nil
	Local oP3       := Nil
	Local oW1       := Nil
	Local oW2       := Nil
	Local oW3       := Nil
	Local oF1       := tfont():new('Arial',,050,,.T.)
	Local oF2       := tfont():new('Arial',,020,,.T.)

	Local aCords    := fwGetDialogSize(oMainWnd)

	Private nTaraVei:= 0
	Private cArqSZ3 := getNextAlias()
	Private aArqSZ3 := array(0)
	Private oTmpSZ3 := Nil
	Private nRecAtu := 0
	Private oS1     := Nil
	Private cCodTab := space(tamSX3('DA0_CODTAB')[1])
	Private cDescTab:= space(tamSX3('DA0_DESCRI')[1])
	Private cCondPag:= space(tamSX3('E4_CODIGO' )[1])
	Private cDescPag:= space(tamSX3('E4_DESCRI' )[1])
	Private cTipoPer:= space(20)
	Private oGet1   := Nil
	Private oMarkBrw:= Nil
	Private cCSS1   := ""
	Private cCSS2   := ""
	Private cPedido := '000001'
	Private cVeiculo:= space(tamSX3('DA3_COD'   )[1])
	Private cDescVei:= space(tamSX3('DA3_DESC'  )[1])
	Private cCodPrd := space(tamSX3('B1_COD'    )[1])
	Private cDescPrd:= space(tamSX3('B1_DESC'   )[1])
	Private cCliente:= space(tamSX3('A1_COD'    )[1])
	Private cLojaCli:= space(tamSX3('A1_LOJA'   )[1])
	Private cNomeCli:= space(tamSX3('A1_NOME'   )[1])
	Private nPrcPes := 999.99//Transform(0,"@E 999,999.9999")
	Private nVlrPes := 999999.99//Transform(0,"@E 999,999.99")
	Private bPesar  := {|| fnGetPes(),oTimer:activate()}
	Private bDigitar:= {|| oTimer:deactivate(),fnDigPes()}
	Private bUpdVeic:= {|| fnUpdVeic()}
	Private bIncPed := {|| oTimer:deActivate(),msAguarde({||fnIncPed()},"Gerando pedido de vendas","Aguarde..."), oTimer:activate()}
	Private bProcNF := {|| fnProcNF()}
	Private bLimpar := {|| oTimer:deActivate(),fnLimpar(),fnFiltrar(),oTimer:activate()}
	Private bAlterar:= {|| fnAlterar()}
	Private bITicket:= {|| fnPrint(1) }
	Private bImpPed := {|| fnPrint(2) }
	Private bResumo := {|| fnPrint(3) }
	Private bFilBtn := {|| fnFilBtn() }
	Private aFilBrw := {}
	Private bImpPed2:= {|| speddanfe()}
	Private bUpdTara:= {|| fnUpdTara()}
	Private bAddTick:= {|| fnAddTicket()}
	Private bAddPeso:= {|| fnAddPeso()}
	Private bReceber:= {|| fnGetPg()  }
	Private bExcPes	:= {|| fnExcPes() }
	Private bDescont:= {|| fnDescont()}
	Private lNovaPes:= .T.
	Private nRecSZ3 := 0
	Private nRecArq := 0
	Private nPeso   := 1
	Private cPeso   := transform(nPeso	 ,"@E 999,999,999.9999")
	Private cTaraVei:= transform(nTaraVei,"@E 999,999,999.9999")
	Private cFiltro := Nil
	Private nHdlBal := 0

	Private oTimer  := Nil

	aArqSZ3 		:= fwSX3Util():getListFieldsStruct("SZ3",.F.)
	
	oTmpSZ3			:= fwTemporaryTable():new(cArqSZ3)
	oTmpSZ3:setFields(aArqSZ3)
	oTmpSZ3:addIndex("INDICE1",{"Z3_FILIAL","Z3_CODIGO"})
	oTmpSZ3:create()

	//-- Filtra os itens para exibicao na tela
	fnFiltrar()

	(cArqSZ3)->(dbSetOrder(1),ordDescend(1,,.T.),dbGoTop())

    dbSelectArea("SZ2")
    dbSetOrder(1)    

    dbSelectArea("SZ4")
    dbSetOrder(1)

    dbSelectArea("SZ3")
    dbSetOrder(1)

	cCSS1 := "QLineEdit{ border: 1px solid gray;"
	cCSS1 += "border-radius: 3px;"
	cCSS1 += "background-color: #ffffff;"
	cCSS1 += "font: bold 50px Arial;"
	cCSS1 += "color: red;"
	cCSS1 += "padding-left:1px;}"

	cCSST := "QLineEdit{ border: 1px solid gray;"
	cCSST += "border-radius: 3px;"
	cCSST += "background-color: #ffffff;"
	cCSST += "font: bold 40px Arial;"
	cCSST += "color: red;"
	cCSST += "padding-left:1px;}"	

	cCSS2 := "QLineEdit{ border: 1px solid gray;"
	cCSS2 += "border-radius: 3px;"
	cCSS2 += "background-color: #DCDCDC;"
	cCSS2 += "font: bold 15px Arial;"
	cCSS2 += "color: red;"
	cCSS2 += "padding-left:1px;}"

	cCSS3 := "QLineEdit{ border: 1px solid gray;"
	cCSS3 += "border-radius: 3px;"
	cCSS3 += "background-color: #ffffff;"
	cCSS3 += "font: bold 15px Arial;"
	cCSS3 += "color: black;"
	CCSS3 += "padding-left:1px;}"

	cCSS4 := "QLineEdit{ border: 1px solid gray;"
	cCSS4 += "border-radius: 3px;"
	cCSS4 += "background-color: #DCDCDC;"
	cCSS4 += "font: bold 15px Arial;"
	cCSS4 += "color: black;"
	cCSS4 += "padding-left:1px;}"

	cCSS5 := "QPushButton{ border: 1px solid gray;"
	cCSS5 += "border-radius: 3px;}"
	cCSS5 += "background-color: #DCDCDC;"
	cCSS5 += "font: bold 30px Arial;"
	cCSS5 += "color: black;"
	cCSS5 += "padding-left:1px;}"

	fnInitBal()

	oDlg            := tDialog():new(aCords[1],aCords[2],aCords[3],aCords[4],"Pesagem",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oLay            := fwLayer():new()
	oLay:init(oDlg,.F.,.T.)
	oLay:addLine('L1',050,.F.)
	oLay:addLine('L2',050,.F.)
	oLay:addCollumn('C1',035,.T.,'L1')
	oLay:addCollumn('C2',065,.T.,'L1')
	oLay:addCollumn('C3',100,.T.,'L2')
	oLay:addWindow('C1','PES','Peso'            ,100,.F.,.T.,{|| },'L1',{|| })
	oLay:addWindow('C2','MEN','Opções'          ,100,.F.,.T.,{|| },'L1',{|| })
	oLay:addWindow('C3','PED','Ultimas pesagens',100,.F.,.T.,{|| },'L2',{|| })

	oP1 := oLay:getWinPanel('C1','PES','L1')
	oP2 := oLay:getWinPanel('C2','MEN','L1')
	oP3 := oLay:getWinPanel('C3','PED','L2')

	oLay:getWindow('C1','PES',@oW1,'L1')
	oLay:getWindow('C2','MEN',@oW2,'L1')
	oLay:getWindow('C3','PED',@oW3,'L2')

	oW1:oTitleBar:oFont := TFont():new('Arial',,16,,.T.)
	oW2:oTitleBar:oFont := TFont():new('Arial',,16,,.T.)
	oW3:oTitleBar:oFont := TFont():new('Arial',,16,,.T.)

	oSay := tSay():new(005,010,{|| 'Peso'},oP1,,oF1,,,,.T.,,,100,,,,,,)
	oSay := tSay():new(090,010,{|| 'Tara'},oP1,,oF1,,,,.T.,,,100,,,,,,)

	oTimer := tTimer():new(10000,{||fnGetPes(.T.)},oDlg)
	oTimer:activate()

	oGet1:= tGet():new(035,010,{|u|if(pCount()>0, nPeso := u,nPeso 		)},oP1,175,050,"@E 999,999,999.9999",{||.T.},,,,,,.T.,,,{||.F.},,.T.,,,,,'nPeso'	,,,,.T.)
	oGet1:setCSS(cCSS1)
	oGet1:lHasButton := .F.

	oGetT:= tGet():new(120,010,{|u|if(pCount()>0, nTaraVei := u,nTaraVei)},oP1,150,035,"@E 999,999,999.9999",{||.T.},,,,,,.T.,,,{||.F.},,.T.,,,,,'nTaraVei'	,,,,.T.)
	oGetT:setCSS(cCSST)
	oGetT:lHasButton := .F.	

	oSay := tSay():new(005,010,{|| 'Veículo: '},oP2,,oF2,,,,.T.,,,050,,,,,,)
	oSay := tSay():new(025,010,{|| 'Cliente: '},oP2,,oF2,,,,.T.,,,050,,,,,,)
	oSay := tSay():new(045,010,{|| 'Tabela:  '},oP2,,oF2,,,,.T.,,,050,,,,,,)
	oSay := tSay():new(065,010,{|| 'Produto: '},oP2,,oF2,,,,.T.,,,050,,,,,,)
	oSay := tSay():new(105,010,{|| 'Valor:   '},oP2,,oF2,,,,.T.,,,050,,,,,,)

	oGet2:= tGet():new(005,050,{|u|if(pCount()>0, cVeiculo := u,cVeiculo 	)},oP2,080,015,,{||.T.},,,,,,.T.,,,{||.T.},,.T.,,,,,'cVeiculo',,,,.T.)
	oGet2:cF3 := 'DA3'
	oGet2:bChange := {|| cDescVei := posicione('DA3',1,xFilial('DA3')+cVeiculo,'DA3_DESC'),; 
						 nTaraVei := fnGetTara(),;
						 oGet3:ctrlRefresh(),; 					 
						 oGetT:ctrlRefresh()}

	oGet2:setCSS(cCSS3)

	oGet3:= tGet():new(005,140,{|u|if(pCount()>0, cDescVei := u,cDescVei 	)},oP2,140,015,,{||.T.},,,,,,.T.,,,{||.F.},,.T.,,,,,'cDescVei',,,,.T.)
	oGet3:setCSS(cCSS4)

	oGet4:= tGet():new(025,050,{|u|if(pCount()>0, cCliente := u,cCliente 	)},oP2,080,015,,{||.T.},,,,,,.T.,,,{||.T.},,.T.,,,,,'cCliente',,,,.T.)
	oGet4:cF3 := 'SA1'
	oGet4:bChange := {|| cLojaCli := posicione('SA1',1,xFilial('SA1')+cCliente,'A1_LOJA'),;
						 oGet5:ctrlRefresh(),;
						 cNomeCli := SA1->A1_NOME,;
						 oGet6:ctrlRefresh(),;
						 cCodTab  := SA1->A1_TABELA,;
						 oGet7:ctrlRefresh(),;
						 cDescTab := iif(.not. empty(cCodTab) .and. DA0->(dbSetOrder(1),dbSeek(xFilial('DA0')+cCodTab)),DA0->DA0_DESCRI,''),;
						 oGet8:ctrlRefresh()}
	oGet4:setCSS(cCSS3)

	oGet5:= tGet():new(025,140,{|u|if(pCount()>0, cLojaCli := u,cLojaCli 	)},oP2,025,015,,{||.T.},,,,,,.T.,,,{||.F.},,.T.,,,,,'cLojaCli',,,,.T.)
	oGet5:bChange := {|| SA1->(dbSetOrder(1),dbSeek(xFilial(alias())+cCliente+cLojaCli)),;
						 cNomeCli := SA1->A1_NOME,;
						 cCodTab  := SA1->A1_TABELA,;
						 cDescTab := iif(.not. empty(cCodTab) .and. DA0->(dbSetOrder(1),dbSeek(xFilial('DA0')+cCodTab)),DA0->DA0_DESCRI,''),;
						 oGet6:ctrlRefresh(),;
						 oGet7:ctrlRefresh(),;
						 oGet8:ctrlRefresh()}

	oGet5:setCSS(cCSS4)

	oGet6:= tGet():new(025,170,{|u|if(pCount()>0, cNomeCli := u,cNomeCli 	)},oP2,110,015,,{||.T.},,,,,,.T.,,,{||.F.},,.T.,,,,,'cNomeCli',,,,.T.)
	oGet6:setCSS(cCSS4)

	oGet7:= tGet():new(045,050,{|u|if(pCount()>0, cCodTab := u,cCodTab 	    )},oP2,080,015,,{||.T.},,,,,,.T.,,,{||.F.},,.T.,,,,,'cCodTab',,,,.T.)
	oGet7:cF3 := 'DA0'
	oGet7:setCSS(cCSS4)

	oGet8:= tGet():new(045,140,{|u|if(pCount()>0, cDescTab := u,cDescTab 	)},oP2,140,015,,{||.T.},,,,,,.T.,,,{||.F.},,.T.,,,,,'cDescTab',,,,.T.)
	oGet8:setCSS(cCSS4)

	oGet9:= tGet():new(065,050,{|u|if(pCount()>0, cCodPrd := u ,cCodPrd 	)},oP2,080,015,,{||.T.},,,,,,.T.,,,{||.T.},,.T.,,,,,'cCodPrd',,,,.T.)
	oGet9:cF3 := 'ZSB1BR'
	oGet9:bChange := {|| cDescPrd := posicione('SB1',1,xFilial('SB1')+cCodPrd,'B1_DESC'),fnGetPrc(),fnGetVlr(),oGetA:ctrlRefresh(),oGetB:ctrlRefresh(),oGetC:ctrlRefresh()}
	oGet9:setCSS(cCSS3)

	oGetA:= tGet():new(065,140,{|u|if(pCount()>0, cDescPrd := u,cDescPrd 	)},oP2,140,015,,{||.T.},,,,,,.T.,,,{||.F.},,.T.,,,,,'cDescPrd',,,,.T.)
	oGetA:setCSS(cCSS4)

	oGetB:= tGet():new(105,050,{|u|if(pCount()>0, nPrcPes := u,nPrcPes 	    )},oP2,100,015,"@E 999,999,999.9999",{||.T.},,,,,,.T.,,,{||.F.},,.T.,,,,,'nPrcPes',,,,.T.)
	oGetB:setCSS(cCSS2)

	oGetC:= tGet():new(105,160,{|u|if(pCount()>0, nVlrPes := u,nVlrPes 	    )},oP2,100,015,"@E 999,999,999.9999",{||.T.},,,,,,.T.,,,{||.F.},,.T.,,,,,'nVlrPes',,,,.T.)
	oGetC:setCSS(cCSS2)

	oBtn := tbutton():new(005,300,"Capturar Peso"       ,oP2,bPesar    ,050,015,,,.F.,.T.,.F.,,.F.,,,.F.)
	oBtn:setCSS(cCSS5)

	oBtn := tbutton():new(025,300,"Digitar Peso"        ,oP2,bDigitar  ,050,015,,,.F.,.T.,.F.,,.F.,,,.F.)
	oBtn:setCSS(cCSS5)

	oBtn := tbutton():new(045,300,"Gerar Pedido"        ,oP2,bIncPed   ,050,015,,,.F.,.T.,.F.,,.F.,,,.F.)
	oBtn:setCSS(cCSS5)	

	oBtn := tbutton():new(065,300,"Preparar Nota"       ,oP2,bProcNF   ,050,015,,,.F.,.T.,.F.,,.F.,,,.F.)
	oBtn:setCSS(cCSS5)

	oBtn := tbutton():new(085,300,"Danfe"               ,oP2,bImpPed2  ,050,015,,,.F.,.T.,.F.,,.F.,,,.F.)
	oBtn:setCSS(cCSS5)	

	oBtn := tbutton():new(105,300,"Limpar"              ,oP2,bLimpar   ,050,015,,,.F.,.T.,.F.,,.F.,,,.F.)
	oBtn:setCSS(cCSS5)

	oBtn := tbutton():new(125,300,"Fechamento"          ,oP2,bResumo   ,050,015,,,.F.,.T.,.F.,,.F.,,,.F.)
	oBtn:setCSS(cCSS5)	

	oBtn := tbutton():new(145,360,"Excluir Pes."        ,oP2,bExcPes   ,050,015,,,.F.,.T.,.F.,,.F.,,,.F.)
	oBtn:setCSS(cCSS5)	

	oBtn := tbutton():new(005,360,"Imp. Ticket"         ,oP2,bITicket  ,050,015,,,.F.,.T.,.F.,,.F.,,,.F.)
	oBtn:setCSS(cCSS5)	

	oBtn := tbutton():new(025,360,"Imp. Pedido"         ,oP2,bImpPed   ,050,015,,,.F.,.T.,.F.,,.F.,,,.F.)
	oBtn:setCSS(cCSS5)

	oBtn := tbutton():new(045,360,"Filtrar"      		,oP2,bFilBtn  	,050,015,,,.F.,.T.,.F.,,.F.,,,.F.)
	oBtn:setCSS(cCSS5)

//	oBtn := tbutton():new(065,360,"Novo Ticket"      	,oP2,bAddTick  ,050,015,,,.F.,.T.,.F.,,.F.,,,.F.)
//	oBtn:setCSS(cCSS5)

	oBtn := tbutton():new(065,360,"Add. Pesagem"        ,oP2,bAddPeso  ,050,015,,,.F.,.T.,.F.,,.F.,,,.F.)
	oBtn:setCSS(cCSS5)

	oBtn := tbutton():new(085,360,"Receber"             ,oP2,bReceber  ,050,015,,,.F.,.T.,.F.,,.F.,,,.F.)
	oBtn:setCSS(cCSS5)

	oBtn := tbutton():new(105,360,"Alterar"             ,oP2,bAlterar   ,050,015,,,.F.,.T.,.F.,,.F.,,,.F.)
	oBtn:setCSS(cCSS5)

	oBtn := tbutton():new(125,360,"Desconto"            ,oP2,bDescont   ,050,015,,,.F.,.T.,.F.,,.F.,,,.F.)
	oBtn:setCSS(cCSS5)				

	oBtn := tbutton():new(145,300,"Atualizar Tara"      ,oP2,bUpdTara   ,050,015,,,.F.,.T.,.F.,,.F.,,,.F.)
	oBtn:setCSS(cCSS5)		

	//-- Componente com a lista de itens dos ultimos pedidos gerados
	oMarkBrw					:= fwBrowse():new()
	oMarkBrw:disableReport()
	oMarkBrw:setOwner(oP3)
	oMarkBrw:setDataQuery(.F.)
	oMarkBrw:setDataTable(.T.)
	oMarkBrw:setDescription("Ultimas pesagens")
	oMarkBrw:setAlias(cArqSZ3)
	oMarkBrw:setColumns(fnColunas())
	oMarkBrw:activate()

	oDlg:activate()

	//-- Encerra a conexão com a balanca
	msClosePort(nHdlBal)
	
	oMarkBrw  := Nil
	oDlg      := Nil
	oSay      := Nil
	oLay      := Nil
	oP1       := Nil
	oP2       := Nil
	oP3       := Nil
	oW1       := Nil
	oW2       := Nil
	oW3       := Nil
	oBtn	  := Nil
	oGet1 	  := Nil
	oGet2	  := Nil
	oGet3	  := Nil
	oGet4	  := Nil
	oGet5     := Nil
	oGet6	  := Nil
	oGet7	  := Nil
	oGet8	  := Nil
	oGet9	  := Nil
	oGetA	  := Nil
	oGetB	  := Nil
	oGetC	  := Nil
	oGetT	  := Nil

Return

/*/{Protheus.doc} fnExcPes
	Exclui o registro de pesagem
	@type  Static Function
	@author Klaus Wolfgram
	@since 18/08/2022
	@version 1.0
	/*/
Static Function fnExcPes()

	IF .not. empty((cArqSZ3)->Z3_PEDIDO)
		IF .not. substr((cArqSZ3)->Z3_PEDIDO,1,1) == '#'
			return msgStop('ESSA PESAGEM JA POSSUI UM PEDIDO GERADO. EXCLUA O PEDIDO PARA DEPOIS EXCLUIR A PESAGEM','[EXCLUSAO DE PESAGEM]')
		EndIF
	EndIF

	IF .not. msgYesNo('CONFIRMA A EXCLUSAO DO REGISTRO DE PESAGEM','[EXCLUSAO DE PESAGEM]')
		return
	EndIF

	cSQL := "UPDATE " + retSqlName("SZ3") + " SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ WHERE Z3_FILIAL = '" + xFilial("SZ3") + "' AND Z3_CODIGO = '" + (cArqSZ3)->Z3_CODIGO + "' "

	IF TCSQLExec(cSQL) < 0
		msgStop(TCSQLError(),'[ERRO]')
		return
	EndIF

	cSQL := "UPDATE " + retSqlName("SZ4") + " SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ WHERE Z4_FILIAL = '" + xFilial("SZ4") + "' AND Z4_CODIGO = '" + (cArqSZ3)->Z3_CODIGO + "' "
	TCSQLExec(cSQL)

	(cArqSZ3)->(reclock(alias(),.F.), dbDelete(),msunlock())

	oMarkBrw:updateBrowse(.T.)
	oMarkBrw:refresh()

	msgInfo('OK','[EXCLUSAO DE PESAGEM]')

Return 

/*/{Protheus.doc} fnGetTara
	Recupera a tara do veiculo
	@type  Static Function
	@author Klaus Wolfgram
	@since 11/08/2022
	/*/
Static Function fnGetTara()

	Local nTara 	:= DA3->DA3_TARA
	Local nPesoSZ4  := 0
	
	Local cAliasSQL := ''
	Local cCodSZ3	:= ''

	lNovaPes		:= .T.

	cAliasSQL 		:= getNextAlias()

	BeginSQL alias cAliasSQL
		
		COLUMN Z3_DATA AS DATE
		
		SELECT * FROM %table:SZ3% SZ3
		WHERE SZ3.%notdel%
		AND Z3_FILIAL  = %exp:xFilial('SZ3')%
		AND Z3_VEICULO = %exp:cVeiculo%
		AND Z3_DATA    = %exp:ddatabase%
		AND Z3_PEDIDO  = ''

		ORDER BY Z3_CODIGO

	EndSQL

	While .not. (cAliasSQL)->(eof())
		cCodSZ3 := (cAliasSQL)->Z3_CODIGO
		(cAliasSQL)->(dbSkip())
	Enddo

	(cAliasSQL)->(dbCloseArea())

	IF empty(cCodSZ3)
		lNovaPes := .T.
		return nTara
	EndIF

	IF .not. msgYesNo('O VEICULO SELECIONADO POSSUI UM TICKET DE PESAGEM EM ABERTO. '   + CRLF + CRLF +;
					  'DESEJA ADICIONAR ESSA NOVA PESAGEM AO TICKET EM ABERTO?' 		+ CRLF + CRLF +;
					  'TICKET EM ABERTO: ' + cCodSZ3,'[TICKET EM ABERTO]')	
		
		lNovaPes := .T.

		return nTara

	EndIF

	lNovaPes := .F.

	SZ3->(dbSetOrder(1),dbSeek(xFilial(alias())+cCodSZ3))

	nRecSZ3 := SZ3->(recno())

	(cArqSZ3)->(dbGoTop())

	While .not. (cArqSZ3)->(eof())

		IF (cArqSZ3)->Z3_CODIGO == SZ3->Z3_CODIGO

			nRecArq := (cArqSZ3)->(recno())

			SA1->(dbSetOrder(1),dbSeek(xFilial(alias())+SZ3->(Z3_CLIENTE+Z3_LOJA)))

			cCliente := SA1->A1_COD
			cLojaCli := SA1->A1_LOJA
			cNomeCli := SA1->A1_NOME
			cCodTab  := SA1->A1_TABELA

			IF .not. empty(cCodTab)
				IF DA0->(dbSetOrder(1),dbSeek(xFilial('DA0')+cCodTab))
					cDescTab := DA0->DA0_DESCRI
				EndIF
			EndIF

			oGet4:ctrlRefresh()
			oGet5:ctrlRefresh()
			oGet6:ctrlRefresh()
			oGet7:ctrlRefresh()
			oGet8:ctrlRefresh()
			
			oMarkBrw:refresh()

			exit

		EndIF	

		(cArqSZ3)->(dbSkip())

	Enddo

	SZ4->(dbSetOrder(1),dbSeek(xFilial(alias())+cCodSZ3))

	While .not. SZ4->(eof()) .and. SZ4->(Z4_FILIAL+Z4_CODIGO) == xFilial('SZ4') + cCodSZ3

		IF SZ4->Z4_UM == 'KG'
			nPesoSZ4 += SZ4->Z4_PESO
		ElseIF SZ4->Z4_UM == 'TL'
			nPesoSZ4 += SZ4->Z4_PESO * 1000
		EndIF	

		SZ4->(dbSkip())

	Enddo

	IF nPesoSZ4 > 0
		return nPesoSZ4
	EndIF	

Return nTara

//-- Programa para atualizacao de veiculo
Static Function fnUpdVeic

    IF empty(cVeiculo)
        Return msgStop('Veículo não informado.','Erro')
    EndIF

    IF nPeso = 0
        Return msgStop('Peso não informado.','Erro')
    EndIF

    IF .not. DA3->(dbSetOrder(1),dbSeek(xFilial('DA3')+cVeiculo))
        Return msgStop('Veículo não encontrado.','Erro')
    EndIF

    IF .not. msgYesNo('Tara atual: ' + transform(DA3->DA3_TARA,"@E 999,999,999.9999") + CRLF + 'Nova tara: ' + transform(nPeso,"@E 999,999,999.9999") + CRLF + 'Confirma?','Atualização de TARA')      
        Return  
    EndIF

    DA3->(reclock("DA3",.F.),DA3_TARA := nPeso,msunlock())   

    msgInfo('Tara atualizada','Sucesso')     

Return

//-- Programa para processar NF
Static Function fnProcNF

    Local lOk       := .F.
    Local cRetNF    := ''
    Local nControle := 0

	IF empty((cArqSZ3)->Z3_PEDIDO) //.or. alltrim((cArqSZ3)->Z3_PEDIDO) == '######'
		return
	EndIF	

	IF .not. empty((cArqSZ3)->Z3_NF)
		
		IF SF2->(dbSetOrder(1),dbSeek(xFilial(alias())+(cArqSZ3)->(Z3_NF+Z3_SERIE)))
			return
		EndIF

		(cArqSZ3)->(reclock(alias(),.F.),Z3_NF := '', Z3_SERIE := '',msunlock())

		SZ3->(dbSetOrder(1),dbSeek((cArqSZ3)->(Z3_FILIAL+Z3_CODIGO)))  
		SZ3->(reclock(alias(),.F.),Z3_NF := '', Z3_SERIE := '',msunlock())

	EndIF

	IF .not. SC5->(dbSetOrder(1),dbSeek(xFilial(alias())+(cArqSZ3)->Z3_PEDIDO))

		SZ3->(dbSetOrder(1),dbSeek((cArqSZ3)->(Z3_FILIAL+Z3_CODIGO)))

		SZ3->(reclock(alias(),.F.),Z3_PEDIDO 		:= '',msunlock())
		(cArqSZ3)->(reclock(alias(),.F.), Z3_PEDIDO := '',msunlock())

		return msgStop('PEDIDO NAO ENCONTRADO','[ERRO]')

	EndIF	

	SC6->(dbSetOrder(1),dbSeek(SC5->(C5_FILIAL+C5_NUM)))	

	//-- Executa a liberacao de itens se ela nao houver sido feita anteriormente
	IF .not. SC9->(dbSetOrder(1),dbSeek(SC5->(C5_FILIAL+C5_NUM)))
		
		aPedidos := array(0)
		aBloques := array(0)
		
		SC5->(ma410LbNfs(2,@aPedidos,@aBloques))

	EndIF

	//-- Atualiza o preco dos itens de liberacao do pedido de vendas
	cSQL := "UPDATE " + retSqlName("SC9") + " SET C9_PRCVEN = C6_PRCVEN"
	cSQL += CRLF + "FROM " + retSqlName("SC9") + " SC9"
	cSQL += CRLF + "JOIN " + retSqlName("SC6") + " SC6 ON SC6.D_E_L_E_T_ = ' ' AND C6_FILIAL = C9_FILIAL AND C6_NUM = C9_PEDIDO AND C6_ITEM = C9_ITEM"
	cSQL += CRLF + "WHERE SC9.D_E_L_E_T_ = ' ' "
	cSQL += CRLF + "AND C9_FILIAL = '" + SC5->C5_FILIAL + "' "
	cSQL += CRLF + "AND C9_PEDIDO = '" + SC5->C5_NUM 	+ "' "

	//-- Executa a atualizacao de preco no item da liberacao do pedido de vendas
	tcSQLExec(cSQL)

	//-- Executa a geracao do documento de saida
    SC5->(ma410PvNfs(alias(),recno(),2))    

    IF .not. SF2->(dbSetOrder(1),dbSeek(SC6->(C6_FILIAL+C6_NOTA+C6_SERIE)))
        msgStop('NOTA FISCAL NAO ENCONTRADA','[ERRO]')
        oMarkBrw:refresh()
        return
    EndIF 

	SZ3->(dbSetOrder(1),dbSeek((cArqSZ3)->(Z3_FILIAL+Z3_CODIGO)))  
	SZ3->(reclock(alias(),.F.		),Z3_NF := SF2->F2_DOC, Z3_SERIE := SF2->F2_SERIE,msunlock())   
	(cArqSZ3)->(reclock(alias(),.F.	),Z3_NF := SF2->F2_DOC, Z3_SERIE := SF2->F2_SERIE,msunlock())

	SZ4->(dbSetOrder(1),dbSeek(SZ3->(Z3_FILIAL+Z3_CODIGO)))

	While .not. SZ4->(eof()) .and. SZ4->(Z4_FILIAL+Z4_CODIGO) == SZ3->(Z3_FILIAL+Z3_CODIGO)
		SZ4->(reclock(alias(),.F.),Z4_NF := SZ3->Z3_NF, Z4_SERIE := SZ3->Z3_SERIE,msunlock(),dbSkip())
	Enddo 

    IF alltrim(SC6->C6_SERIE) == 'UNI'
        oMarkBrw:refresh()
        Return
    EndIF	

    IF .not. empty(SF2->F2_CHVNFE)
        msgInfo('NF TRANSMITIDA.' + CRLF + 'CHAVE NFE: ' + SF2->F2_CHVNFE)
        oMarkBrw:refresh()
        Return
    EndIF    

    IF .not. msgYesNo('DESEJA TRANSMITIR A NF ' + alltrim(SC6->C6_NOTA) + ' / ' + alltrim(SC6->C6_SERIE) + '?','[TRANSMISSAO NFE]')
        oMarkBrw:refresh()
        Return
    EndIF   

    bFiltraBrw := {|| .T.}

    spedNFeRe2(SC6->C6_SERIE,SC6->C6_NOTA,SC6->C6_NOTA,.F.,.F.)

    do While .not. lOk

        dbSelectArea('SF2')
        dbSetOrder(1)

        IF dbSeek(SC6->(C6_FILIAL+C6_NOTA+C6_SERIE))

            IF alltrim(SF2->F2_FIMP) $ "T|S"

                cRetNF := fnChkNFE(SC6->C6_SERIE,SC6->C6_NOTA)
                
                IF cRetNF <> '001'

                    lOk := .F.

                Else

                    lOk := .T.

                EndIF    

            Else

                lOk := .F.

            EndIF

        Else    

            msgStop('NF NAO ENCONTRADA','[ERRO]')
            oMarkBrw:refresh()
            Return

        EndIF

        nControle++
        sleep(1000)

        IF nControle >= 5

            IF msgYesNo('NAO FOI POSSIVEL TRANSMITIR A NF. DESEJA CONTINUAR TENTANDO?','[TRANSMISSAO NFE]')

                nControle := 0

            Else

                msgStop('OPERACAO CANCELADA','[TRANSMISSAO NFE]')
                exit

            EndIF        

        EndIF

    Enddo

	oMarkBrw:refresh()

Return

/*/{Protheus.doc} fnAlterar
	Funcao auxiliar para alterar dados da pesagem ou do pedido
	@type  Static Function
	@author Klaus Wolfgram
	@since 21/07/2022
	@version 1.0
/*/
Static Function fnAlterar()
	
	Local aButtons := {}

	IF empty((cArqSZ3)->Z3_PEDIDO) //-- Se nao houver gerado pedido, abre a tela para edicao dos dados da pesagem
		
		SZ3->(dbSetOrder(1),dbSeek((cArqSZ3)->(Z3_FILIAL+Z3_CODIGO)))
		
		aadd(aButtons,{.F.,nil			}) //-- Copiar
		aadd(aButtons,{.F.,nil			}) //-- Recortar
		aadd(aButtons,{.F.,nil			}) //-- Colar
		aadd(aButtons,{.F.,nil			}) //-- Calculadora
		aadd(aButtons,{.F.,nil			}) //-- Spool
		aadd(aButtons,{.F.,nil			}) //-- fnPrint
		aadd(aButtons,{.T.,"Salvar"		}) //-- Salvar
		aadd(aButtons,{.T.,"Cancelar"	}) //-- Cancelar
		aadd(aButtons,{.F.,nil			}) //-- WalkTrhough
		aadd(aButtons,{.F.,nil			}) //-- Mashup
		aadd(aButtons,{.F.,nil			}) //-- Help
		aadd(aButtons,{.F.,nil			}) //-- Formulario HTML
		aadd(aButtons,{.F.,nil			}) //-- ECM
		aadd(aButtons,{.F.,nil			}) //-- Salvar e criar novo
		
		fwExecView("Alterar","APPFT003M",MODEL_OPERATION_UPDATE,,{|| .T.},,,aButtons)

		SZ3->(dbSetOrder(1),dbSeek((cArqSZ3)->(Z3_FILIAL+Z3_CODIGO)))

		(cArqSZ3)->(reclock(alias(),.F.))
			(cArqSZ3)->Z3_FILIAL			:= SZ3->Z3_FILIAL
			(cArqSZ3)->Z3_CODIGO			:= SZ3->Z3_CODIGO
			(cArqSZ3)->Z3_DATA				:= SZ3->Z3_DATA
			(cArqSZ3)->Z3_CLIENTE			:= SZ3->Z3_CLIENTE
			(cArqSZ3)->Z3_LOJA				:= SZ3->Z3_LOJA
			(cArqSZ3)->Z3_VEICULO			:= SZ3->Z3_VEICULO
			(cArqSZ3)->Z3_PEDIDO			:= SZ3->Z3_PEDIDO
			(cArqSZ3)->Z3_NF				:= SZ3->Z3_NF
			(cArqSZ3)->Z3_SERIE				:= SZ3->Z3_SERIE
			(cArqSZ3)->Z3_TOTAL				:= SZ3->Z3_TOTAL
			(cArqSZ3)->Z3_DTHRPES			:= SZ3->Z3_DTHRPES
		(cArqSZ3)->(msunlock())			
	
	Else //-- senao, abre a tela de edicao do pedido
		
		SZ3->(dbSetOrder(1),dbSeek((cArqSZ3)->(Z3_FILIAL+Z3_CODIGO)))

		mata410()

		(cArqSZ3)->(dbSetOrder(1),dbSeek(SZ3->(Z3_FILIAL+Z3_CODIGO)))

		IF .not. SC5->(dbSetOrder(1),dbSeek((cArqSZ3)->(Z3_FILIAL+Z3_PEDIDO)))

			SZ3->(reclock(alias(),.F.))
				SZ3->Z3_PEDIDO 			:= ' '
				SZ3->Z3_NF 				:= ' '
				SZ3->Z3_SERIE 			:= ' '
			SZ3->(msunlock())

			(cArqSZ3)->(reclock(alias(),.F.))
				(cArqSZ3)->Z3_PEDIDO 	:= ' '
				(cArqSZ3)->Z3_NF 	 	:= ''
				(cArqSZ3)->Z3_SERIE 	:= ''
			(cArqSZ3)->(msunlock())

		Else

			SZ3->(reclock(alias(),.F.))		
				SZ3->Z3_NF 				:= SC5->C5_NOTA
				SZ3->Z3_SERIE 			:= SC5->C5_SERIE
			SZ3->(msunlock())	
			
			(cArqSZ3)->(reclock(alias(),.F.))
				(cArqSZ3)->Z3_NF 		:= SC5->C5_NOTA
				(cArqSZ3)->Z3_SERIE 	:= SC5->C5_SERIE
			(cArqSZ3)->(msunlock())	

		EndIF	

	EndIF		

	oMarkBrw:refresh()
	
Return 

/*/{Protheus.doc} fnDescont
	Funcao auxiliar para aplicacao de desconto em pesagem
	@type  Static Function
	@author Klaus Wolfgram
	@since 01/11/2022
	@version 1.0
	/*/
Static Function fnDescont()

	Local cPerg 		:= 'APPFT03DES'
	Local cMsgInfo		:= ''
	Local nVlrAtual 	:= (cArqSZ3)->Z3_TOTAL
	Local nVlrNovo  	:= 0

	Private nPrcItem	:= 0
	Private nPrcTot		:= 0

	IF .not. &("SX1->(dbSetOrder(1),dbSeek('APPFT03DES' + '01'))")
		&("SX1->(reclock('SX1',.T.))"				  )
		&("SX1->X1_GRUPO	 	:= 'APPFT03DES'"	  )
		&("SX1->X1_ORDEM 		:= '01'"			  )
		&("SX1->X1_PERGUNT		:= 'Vlr Desconto?'"   )
		&("SX1->X1_PERSPA		:= 'Vlr Desconto?'"	  )
		&("SX1->X1_PERENG		:= 'Vlr Desconto?'"	  )
		&("SX1->X1_VARIAVL		:= 'MV_CH1'"		  )
		&("SX1->X1_TIPO			:= 'N'"				  )
		&("SX1->X1_TAMANHO		:= 12"				  )
		&("SX1->X1_DECIMAL		:= 2"				  )
		&("SX1->X1_PRESEL		:= 0"				  )
		&("SX1->X1_GSC			:= 'G'"				  )
		&("SX1->X1_VALID		:= ''"				  )
		&("SX1->X1_VAR01		:= 'MV_PAR01'"		  )
		&("SX1->X1_F3			:= ''"				  )
		&("SX1->X1_PICTURE     := '@E 999,999,999.99'")
		&("SX1->(msunlock())"						  )
	EndIF

	IF .not. empty((cArqSZ3)->Z3_NF)
		return fwAlertError('Essa pesagem ja gerou nota fiscal.','[ERRO]')
	EndIF		

	IF .not. pergunte(cPerg,.T.)
		return
	EndIF	

	nVlrNovo := nVlrAtual - MV_PAR01

	cMsgInfo := 'VALOR ATUAL: ' + transform(nVlrAtual,"@E 999,999,999.99") + CRLF
	cMsgInfo += 'NOVO VALOR: '  + transform(nVlrNovo ,"@E 999,999,999.99") + CRLF 
	cMsgInfo += 'Confirma a atualização de valores? '

	IF .not. fwAlertYesNo(cMsgInfo,'[ATENÇÃO]')
		return 	
	EndIF

	//-- Se o novo valor for menor ou igual a zero, encerra a operacao
	IF nVlrNovo <= 0
		return fwAlertError('O valor não pode estar zerado ou negativo.','[ERRO]')
	EndIF		

	//-- Atualiza o pedido de vendas
	IF .not. empty((cArqSZ3)->Z3_PEDIDO)

		IF .not. SC5->(dbSetOrder(1),dbSeek(xFilial(alias())+(cArqSZ3)->Z3_PEDIDO))
			return fwAlertError('Pedido não encontrado.','[ERRO]')
		EndIF

		IF .not. fnUpdPed(MV_PAR01)
			return fwAlertError('Não foi possível atualizar o pedido.','[ERRO]')
		EndIF	

	EndIF

	//-- Atualiza o arquivo temporario
	(cArqSZ3)->(reclock(alias(),.F.), Z3_TOTAL := nVlrNovo, msunlock())

	//-- Atualiza os arquivos no banco de dados
	IF SZ3->(dbSetOrder(1),dbSeek(xFilial(alias())+(cArqSZ3)->Z3_CODIGO))
		
		//-- Atualiza o total da tabela SZ3
		SZ3->(reclock(alias(),.F.), Z3_TOTAL := nVlrNovo, msunlock())

		SZ4->(dbSetOrder(1),dbSeek(SZ3->(Z3_FILIAL+Z3_CODIGO)))

		//-- Atualiza o item no arquivo da tabela SZ4
		While .not. SZ4->(eof()) .and. SZ4->(Z4_FILIAL+Z4_CODIGO) == SZ3->(Z3_FILIAL+Z3_CODIGO)

			//-- Ignora o primeiro item
			IF SZ4->Z4_TIPO == '1'
				
				SZ4->(dbSkip())
				Loop

			EndIF	

			//-- Atualiza o preco
			IF nPrcItem > 0 //-- Se a variavel de controle estiver preenchida, significa que encontrou pedido
				
				SZ4->(reclock(alias(),.F.), Z4_PRECO := nPrcItem, Z4_TOTAL := nPrcTot,msUnlock())
				
			Else //-- Senao, calcula os precos novos no arquivo SZ4
				
				nPrcTot 	:= SZ4->Z4_TOTAL - MV_PAR01
				nPrcItem 	:= round(nPrcTot / SZ4->Z4_PESO,4) 
				
				SZ4->(reclock(alias(),.F.), Z4_PRECO := nPrcItem, Z4_TOTAL := nPrcTot,msUnlock())

			EndIF

			Exit		

		Enddo

	EndIF

	oMarkBrw:refresh()

	fwAlertInfo('OK','[ATUALIZAÇÃO DE VALOR]')
	
Return 

/*/{Protheus.doc} fnUpdPed
	Funcao auxiliar para atualizacao do pedido de vendas
	@type  Static Function
	@author Klaus Wolfgram
	@since 01/11/2022
	@version 1.0
	/*/
Static Function fnUpdPed(nVlrDesc)

	Local aCab 			:= array(0)
	Local aItem 		:= array(0)
	Local aItens 		:= array(0)
	Local nTotal 		:= 0
	Local nPreco 		:= 0
	
	Private lMsErroAuto := .F.

	Default nVlrDesc 	:= 0

	//-- Encontra o item do pedido
	SC6->(dbSetOrder(1),dbSeek(SC5->(C5_FILIAL+C5_NUM)))

	//-- Calcula o novo valor
	nTotal				:= SC6->C6_VALOR - nVlrDesc

	//-- Calcula o novo preco
	nPreco				:= round(nTotal / SC6->C6_QTDVEN,4)

	aadd(aCab,{"C5_NUM"    ,SC5->C5_NUM     ,nil})
	aadd(aCab,{"C5_TIPO"   ,SC5->C5_TIPO    ,nil})
	aadd(aCab,{"C5_CLIENTE",SC5->C5_CLIENTE	,nil})
	aadd(aCab,{"C5_LOJACLI",SC5->C5_LOJACLI	,nil})
	aadd(aCab,{"C5_CLIENT" ,SC5->C5_CLIENT	,nil})
	aadd(aCab,{"C5_LOJAENT",SC5->C5_LOJAENT	,nil})
	aadd(aCab,{"C5_VEICULO",SC5->C5_VEICULO ,nil})
	aadd(aCab,{"C5_PLACA1" ,SC5->C5_PLACA1  ,nil})
	aadd(aCab,{"C5_YMSGNFE",SC5->C5_YMSGNFE ,nil})

	lUpdPreco := .T.

	While .not. SC6->(eof()) .and. SC6->(C6_FILIAL+C6_NUM) == SC5->(C5_FILIAL+C5_NUM)

		aItem := array(0)
		
		aadd(aItem,{"C6_ITEM"	,SC6->C6_ITEM   	,nil})
		aadd(aItem,{"C6_PRODUTO",SC6->C6_PRODUTO	,nil})
		aadd(aItem,{"C6_LOCAL"	,SC6->C6_LOCAL		,nil})

		IF lUpdPreco
			
			aadd(aItem,{"C6_QTDVEN"	,SC6->C6_QTDVEN	,nil})			
			aadd(aItem,{"C6_PRCVEN" ,nPreco 		,nil})
			aadd(aItem,{"C6_VALOR"	,nTotal  		,nil})
			
			lUpdPreco := .F.
			nPrcItem  := nPreco
			nPrcTot   := nTotal

		Else

			aadd(aItem,{"C6_QTDVEN"	,SC6->C6_QTDVEN	,nil})
			aadd(aItem,{"C6_PRCVEN" ,SC6->C6_PRCVEN ,nil})
			aadd(aItem,{"C6_VALOR"	,SC6->C6_VALOR  ,nil})

		EndIF

		nSldLib := ma440SaLib()                                                                                                                    
		nQtdLib := SC6->(C6_QTDVEN - C6_QTDENT) - nSldLib

		aadd(aItem,{"C6_QTDLIB" ,nQtdLib			,nil})
		aadd(aItem,{"C6_TES"	,SC6->C6_TES		,nil})
		aadd(aItem,{"C6_YPESBAL",SC6->C6_YPESBAL	,nil})

		aadd(aItens,aItem)	

		SC6->(dbSkip())

	Enddo

	msExecAuto({|a,b| mata410(a,b,4)},aCab,aItens)

	IF lMsErroAuto
		mostraErro()
		return .F.
	EndIF
	
Return .T.

/*/{Protheus.doc} fnInfnGrvPedcPed
	Gera o pedido de vendas quando a pesagem for finalizada.
	@type  Static Function
	@author Klaus Wolfgram
	@since 21/07/2022
	@version 1.0
	/*/
Static Function fnGrvPed()

	Local aCab 			:= array(0)
	Local aItem			:= array(0)
	Local aItens		:= array(0)
	Local cItem			:= '01'
	Local cTes			:= getNewPar('ZZ_TESPES','517')
	Local cFormPag		:= ''
	Local nPesoTot  	:= 0
	Local nPesoBal		:= 0

	Private lMsErroAuto := .F.

	IF .not. empty((cArqSZ3)->Z3_PEDIDO)
		return msgAlert('PESAGEM ENCERRADA ANTERIORMENTE','[ATENCAO]')
	EndIF	

	SZ3->(dbSetOrder(1),dbSeek((cArqSZ3)->(Z3_FILIAL+Z3_CODIGO)))
	SZ4->(dbSetOrder(1),dbSeek((cArqSZ3)->(Z3_FILIAL+Z3_CODIGO)))

	nPesoTot := 0

	While .not. SZ4->(eof()) .and. SZ4->(Z4_FILIAL+Z4_CODIGO) == SZ3->(Z3_FILIAL+Z3_CODIGO)

		IF SZ4->Z4_TIPO == '1'
			SZ4->(dbSkip())
			Loop
		EndIF

		SB1->(dbSetOrder(1),dbSeek(xFilial(alias())+SZ4->Z4_PRODUTO))
		SF4->(dbSetOrder(1),dbSeek(xFilial(alias())+cTes))

		IF .not. empty(SB1->B1_TS)
			IF SF4->(dbSetOrder(1),dbSeek(xFilial(alias())+SB1->B1_TS))
				cTes := SF4->F4_CODIGO
			EndIF		
		EndIF 

		IF .not. empty(SZ4->Z4_TES)
			IF SF4->(dbSetOrder(1),dbSeek(xFilial(alias())+SZ4->Z4_TES))
				cTes := SF4->F4_CODIGO
			EndIF		
		EndIF						

		nPesoBal := iif(alltrim(SB1->B1_UM) == 'TL',SZ4->Z4_PESO * 1000,SZ4->Z4_PESO)
		nPesoTot += nPesoBal

		aItem := array(0)
		aadd(aItem,{"C6_ITEM"	,cItem			,nil})
		aadd(aItem,{"C6_PRODUTO",SB1->B1_COD	,nil})
		aadd(aItem,{"C6_LOCAL"	,SB1->B1_LOCPAD	,nil})
		aadd(aItem,{"C6_PRCVEN" ,SZ4->Z4_PRECO  ,nil})
		aadd(aItem,{"C6_QTDVEN"	,SZ4->Z4_PESO	,nil})
		aadd(aItem,{"C6_VALOR"	,SZ4->Z4_TOTAL  ,nil})
		aadd(aItem,{"C6_TES"	,cTes			,nil})
		aadd(aItem,{"C6_YPESBAL",nPesoBal		,nil})

		aadd(aItens,aItem)

		cItem := soma1(cItem)

		SZ4->(dbSkip())

	Enddo

	IF empty(aItens)
		return msgStop('PEDIDO NAO GERADO. VERIFIQUE AS PESAGENS.','[ERRO]')
	EndIF	

	SA1->(dbSetOrder(1),dbSeek(xFilial(alias())+SZ3->(Z3_CLIENTE+Z3_LOJA)))

	cFormPag	:= iif(empty(SA1->A1_TIPPER),'','PERIODO')

	IF empty(SA1->A1_COND)
		
		SE4->(dbSetOrder(1),dbGoTop())

		While .not. SE4->(eof()) .and. SE4->E4_FILIAL == xFilial("SE4")
			
			IF .not. SE4->E4_MSBLQL == '1'
				exit
			EndIF

			SE4->(dbSkip())

		Enddo

	Else
		
		IF .not. SE4->(dbSetOrder(1),dbSeek(xFilial(alias())+SA1->A1_COND))
			
			SE4->(dbSetOrder(1),dbGoTop())

			While .not. SE4->(eof()) .and. SE4->E4_FILIAL == xFilial("SE4")
				
				IF .not. SE4->E4_MSBLQL == '1'
					exit
				EndIF

				SE4->(dbSkip())
				
			Enddo

		EndIF

	EndIF	

	IF empty(SA1->A1_NATUREZ)
		SED->(dbSetOrder(1),dbSeek(xFilial(alias())+'101'))
	Else	
		IF .not. SED->(dbSetOrder(1),dbSeek(xFilial(alias())+SA1->A1_NATUREZ))
			SED->(dbSetOrder(1),dbSeek(xFilial(alias())+'101'))
		EndIF
	EndIF

	aadd(aCab,{"C5_TIPO"   ,"N"				,nil})
	aadd(aCab,{"C5_CLIENTE",SZ3->Z3_CLIENTE	,nil})
	aadd(aCab,{"C5_LOJACLI",SZ3->Z3_LOJA	,nil})
	aadd(aCab,{"C5_CLIENT" ,SZ3->Z3_CLIENTE	,nil})
	aadd(aCab,{"C5_LOJAENT",SZ3->Z3_LOJA	,nil})
	aadd(aCab,{"C5_CONDPAG",SE4->E4_CODIGO	,nil})
	aadd(aCab,{"C5_YMSGNFE",SA1->A1_YMSGNFE ,nil})
	aadd(aCab,{"C5_TPFRETE","S"				,nil})
	aadd(aCab,{"C5_ESPECI1","GRANEL"		,nil})
	aadd(aCab,{"C5_VOLUME1",1				,nil})
	aadd(aCab,{"C5_PESOL"  ,nPesoTot		,nil})
	aadd(aCab,{"C5_PBRUTO" ,nPesoTot		,nil})
	aadd(aCab,{"C5_VEICULO",cVeiculo		,nil})
	aadd(aCab,{"C5_YFORMPG",cFormPag		,nil})
	aadd(aCab,{"C5_TABELA" ,"   "			,nil})

	lMsErroAuto := .F.

	msExecAuto({|a,b| mata410(a,b,3)},aCab,aItens)

	IF lMsErroAuto
		mostraErro()
		return .F.
	EndIF

	(cArqSZ3)->(reclock(alias(),.F.),Z3_PEDIDO := SC5->C5_NUM,msunlock())

	SZ3->(reclock(alias(),.F.),Z3_PEDIDO := SC5->C5_NUM,msunlock())
	
	SZ4->(dbSetOrder(1),dbSeek((cArqSZ3)->(Z3_FILIAL+Z3_CODIGO)))		

	While .not. SZ4->(eof()) .and. SZ4->(Z4_FILIAL+Z4_CODIGO) == SZ3->(Z3_FILIAL+Z3_CODIGO)
		SZ4->(reclock(alias(),.F.), Z4_PEDIDO := SC5->C5_NUM,msunlock(),dbSkip())
	Enddo	

	oMarkBrw:refresh()

	msgInfo('PEDIDO DE VENDAS NR: ' + SC5->C5_NUM,'[SUCESSO]')

Return 

/*/{Protheus.doc} fnFilBtn
	Funcao auxiliar para executar o filtro a partir de botao do menu
	@type  Static Function
	@author Klaus Wolfgram
	@since 30/07/2022
	/*/
Static Function fnFilBtn()

	Local cPergFil 	:= 'APPFT003F'

	Private cNumTic := ''
	Private cNumPed := ''
	Private cNumNFE := ''
	Private cCodCli := ''
	Private cLojCli := ''
	Private cVeiculo:= ''

	IF .not. pergunte(cPergFil)
		return
	EndIF	

	cNumTic			:= alltrim(MV_PAR01)	
	cNumPed			:= alltrim(MV_PAR02)
	cNumNFE			:= alltrim(MV_PAR03)
	cCodCli			:= alltrim(MV_PAR04)
	cLojCli			:= alltrim(MV_PAR05)
	cCodVei	    	:= alltrim(MV_PAR06)

	fnFiltrar()
	
Return 

/*/{Protheus.doc} fnFiltrar
	Filtra os registros da tabela SZ3 de acordo com cliente selecionado
	@type  Static Function
	@author Klaus Wolfgram
	@since 19/07/2022
	/*/
Static Function fnFiltrar()

	Local cAliasSQL := getNextAlias()
	Local cWhere    := ''
//	Local x

	(cArqSZ3)->(dbEval({|| reclock(alias(),.F.), dbDelete(), msUnlock()}))

	IF isInCallStack('fnFilBtn')

		IF .not. empty(cNumTic)
			cWhere += "Z3_CODIGO LIKE '%" + cNumTic + "' "
		EndIF

		IF .not. empty(cNumPed)
			IF empty(cWhere)
				cWhere += "Z3_PEDIDO LIKE '%" + cNumPed + "'"
			Else
				cWhere += "AND Z3_PEDIDO LIKE '%" + cNumPed + "' "
			EndIF
		EndIF

		IF .not. empty(cNumNFE)
			IF empty(cWhere)
				cWhere += "Z3_NF LIKE '%" + cNumNFE + "' " 
			Else
				cWhere += "AND Z3_NF LIKE '%" + cNumNFE + "' "
			EndIF
		EndIF

		IF .not. empty(cCodCli)
			IF empty(cWhere)
				cWhere += "Z3_CLIENTE LIKE '%" + cCodCli + "' "
			Else
				cWhere += "AND Z3_CLIENTE LIKE '%" + cCodCli + "' "	
			EndIF
		EndIF

		IF .not. empty(cLojCli)
			IF empty(cWhere)
				cWhere += "Z3_LOJA LIKE '%" + cLojCli + "' "
			Else
				cWhere += "AND Z3_LOJA LIKE '%" + cLojCli + "' "	
			EndIF
		EndIF

		IF .not. empty(cCodVei)
			IF empty(cWhere)
				cWhere += "Z3_VEICULO LIKE '%" + cCodVei + "' "
			Else
				cWhere += "AND Z3_VEICULO LIKE '%" + cCodVei + "' "	
			EndIF
		EndIF

		IF empty(cWhere)

			BeginSQL Alias cAliasSQL
				
				COLUMN Z3_DATA AS DATE
				
				SELECT TOP 100000 * FROM %table:SZ3% SZ3
				WHERE SZ3.%notdel%
				AND Z3_FILIAL = %exp:xFilial("SZ3")%
				ORDER BY Z3_CLIENTE, Z3_CODIGO DESC

			EndSQL

		Else

			cWhere := "%" + cWhere + "%"

			BeginSQL Alias cAliasSQL
				
				COLUMN Z3_DATA AS DATE
				
				SELECT TOP 100000 * FROM %table:SZ3% SZ3
				WHERE SZ3.%notdel%
				AND Z3_FILIAL = %exp:xFilial("SZ3")%
				AND %exp:cWhere%
				ORDER BY Z3_CLIENTE, Z3_CODIGO DESC

			EndSQL

		EndIF				

	Else																

		BeginSQL Alias cAliasSQL
				
			COLUMN Z3_DATA AS DATE
				
			SELECT TOP 1000000 * FROM %table:SZ3% SZ3
			WHERE SZ3.%notdel%
			AND Z3_FILIAL 	= %exp:xFilial("SZ3")%
			ORDER BY Z3_CODIGO DESC

		EndSQL

	EndIF

	While .not. (cAliasSQL)->(eof())

		SZ3->(dbSetOrder(1),dbGoto((cAliasSQL)->R_E_C_N_O_))

		IF empty(SZ3->Z3_NOME)
			SZ3->(reclock(alias(),.F.))
			SZ3->Z3_NOME := posicione('SA1',1,xFilial('SA1')+SZ3->(Z3_CLIENTE+Z3_LOJA),'alltrim(A1_NOME)')
			SZ3->(msunlock())
		EndIF		

		(cArqSZ3)->(reclock(alias(),.T.))

			(cArqSZ3)->Z3_FILIAL			:= SZ3->Z3_FILIAL
			(cArqSZ3)->Z3_CODIGO			:= SZ3->Z3_CODIGO
			(cArqSZ3)->Z3_DATA				:= SZ3->Z3_DATA
			(cArqSZ3)->Z3_CLIENTE			:= SZ3->Z3_CLIENTE
			(cArqSZ3)->Z3_LOJA				:= SZ3->Z3_LOJA
			(cArqSZ3)->Z3_NOME	 			:= SZ3->Z3_NOME
			(cArqSZ3)->Z3_VEICULO			:= SZ3->Z3_VEICULO
			(cArqSZ3)->Z3_PEDIDO			:= SZ3->Z3_PEDIDO
			(cArqSZ3)->Z3_NF				:= SZ3->Z3_NF
			(cArqSZ3)->Z3_SERIE				:= SZ3->Z3_SERIE
			(cArqSZ3)->Z3_TOTAL				:= SZ3->Z3_TOTAL
			(cArqSZ3)->Z3_DTHRPES			:= SZ3->Z3_DTHRPES

		(cArqSZ3)->(msunlock())

		(cAliasSQL)->(dbSkip())

	Enddo

	(cAliasSQL)->(dbCloseArea())

	(cArqSZ3)->(dbGoTop())

	IF type('oMarkBrw') == 'O'
		oMarkBrw:updateBrowse(.T.)
		oMarkBrw:refresh()
	EndIF	
	
Return 

/*/{Protheus.doc} fnUpdTara
	Atualiza tara no cadastro de veiculos
	@type  Static Function
	@author Klaus Wolfgram
	@since 19/07/2022
	/*/
Static Function fnUpdTara()

	IF empty(cVeiculo)
		return msgStop('SELECIONE UM VEICULO','[ERRO]')
	EndIF

	DA3->(reclock(alias(),.F.), DA3_TARA := nPeso, msunlock())	

	msgInfo('TARA ATUALIZADA',"[SUCESSO]")	
	
Return 

/*/{Protheus.doc} fnAddTicket
	Adiciona o registro de tara inicial da pesagem
	@type  Static Function
/*/
Static Function fnAddTicket()

	Local cAliasSQL := ''
	Local nRecSZ3	:= 0
	Local nTara		:= 0
	Local cTes		:= getNewPar('ZZ_TESPES','517')

	IF empty(cVeiculo)
		return msgStop('SELECIONE UM VEICULO','[ERRO]')
	EndIF

	IF .not. DA3->(dbSetOrder(1),dbSeek(xFilial("DA3")+cVeiculo))
		return msgStop('SELECIONE UM VEICULO VALIDO','[ERRO]')
	EndIF	

	IF nPeso == 0
		
		nTara 			:= iif(DA3->DA3_TARA <= 0,nPeso,DA3->DA3_TARA)

		IF nTara <= 0
			return msgStop('TARA INVALIDA','[ERRO]')
		EndIF

	Else

		nTara 			:= nPeso
		DA3->(reclock(alias(),.F.),DA3_TARA := nPeso,msunlock())

	EndIF			

	IF empty(cCliente) .or. empty(cLojaCli)
		return msgStop('SELECIONE UM CLIENTE','[ERRO]')	
	EndIF	

	IF .not. SA1->(dbSetOrder(1),dbSeek(xFilial("SA1")+cCliente+cLojaCli))
		return msgStop('SELECIONE UM CLIENTE VALIDO','[ERRO]')		
	EndIF	

	cAliasSQL		:= getNextAlias()

	BeginSQL Alias cAliasSQL

		COLUMN Z3_DATA AS DATE

		SELECT * FROM %table:SZ3% SZ3
		WHERE SZ3.%notdel%
		AND Z3_FILIAL = %exp:xFilial("SZ3")%
		AND Z3_VEICULO = %exp:cVeiculo%
		AND Z3_CLIENTE = %exp:cCliente%
		AND Z3_LOJA    = %exp:cLojaCli%
		AND Z3_DATA    = %exp:date()%
		AND Z3_PEDIDO  = ' '
		ORDER BY Z3_CODIGO

	EndSQL

	(cAliasSQL)->(dbEval({|| nRecSZ3 := R_E_C_N_O_}),dbCloseArea())

	SA1->(dbSetOrder(1),dbSeek(xFilial(alias())+cCliente+cLojaCli))

	//-- Inicia um novo registro de pesagem
	SZ3->(reclock(Alias(),.T.))
		SZ3->Z3_FILIAL := xFilial("SZ3")
		SZ3->Z3_CODIGO := getSxeNum("SZ3","Z3_CODIGO")
		SZ3->Z3_DATA   := date()
		SZ3->Z3_VEICULO:= cVeiculo
		SZ3->Z3_CLIENTE:= SA1->A1_COD
		SZ3->Z3_LOJA   := SA1->A1_LOJA
		SZ3->Z3_NOME   := SA1->A1_NOME
		SZ3->Z3_DTHRPES:= dtoc(date()) + ' ' + substr(time(),1,5)
	SZ3->(msunlock())	

	confirmSX8()

	//-- Adiciona o registro referente à tara
	SZ4->(reclock(alias(),.T.))
		SZ4->Z4_FILIAL := xFilial("SZ4")
		SZ4->Z4_CODIGO := SZ3->Z3_CODIGO
		SZ4->Z4_ITEM   := strzero(1,tamSX3("Z4_ITEM")[1])
		SZ4->Z4_TIPO   := '1'
		SZ4->Z4_PESO   := DA3->DA3_TARA
		SZ4->Z4_UM	   := "KG"
		SZ4->Z4_DTHRPES:= SZ3->Z3_DTHRPES
		SZ4->Z4_TES	   := cTes
	SZ4->(msunlock())

	(cArqSZ3)->(reclock(alias(),.T.))
		(cArqSZ3)->Z3_FILIAL := SZ3->Z3_FILIAL
		(cArqSZ3)->Z3_CODIGO := SZ3->Z3_CODIGO
		(cArqSZ3)->Z3_CLIENTE:= SZ3->Z3_CLIENTE
		(cArqSZ3)->Z3_NOME	 := SZ3->Z3_NOME
		(cArqSZ3)->Z3_LOJA	 := SZ3->Z3_LOJA
		(cArqSZ3)->Z3_VEICULO:= SZ3->Z3_VEICULO
		(cArqSZ3)->Z3_DATA	 := SZ3->Z3_DATA
		(cArqSZ3)->Z3_DTHRPES:= SZ3->Z3_DTHRPES
	(cArqSZ3)->(msunlock())

	oMarkBrw:refresh()

	msgInfo("REGISTRO DE PESAGEM INICIADO","[SUCESSO]")

Return

/*/{Protheus.doc} fnAddPeso
	Adiciona o registro de pesagem
	@type  Static Function
/*/
Static Function fnAddPeso()

	Local cTes		:= getNewPar('ZZ_TESPES','517')

	IF empty(cVeiculo)
		return msgStop('SELECIONE UM VEICULO','[ERRO]')	
	EndIF

	IF .not. DA3->(dbSetOrder(1),dbSeek(xFilial(alias())+cVeiculo))
		return mgStop('VEICULO INVALIDO','[ERRO]')
	EndIF

	IF empty(cCliente) .or. empty(cLojaCli)	
		return msgStop('SELECIONE UM CLIENTE','[ERRO]')
	EndIF

	IF .not. SA1->(dbSetOrder(1),dbSeek(xFilial(alias())+cCliente+cLojaCli))
		return msgStop('CLIENTE INVALIDO','[ERRO]')
	EndIF	

	IF empty(cCodPrd)		
		return msgStop('SELECIONE UM PRODUTO','[ERRO]')
	EndIF

	IF .not. SB1->(dbSetOrder(1),dbSeek(xFilial(alias())+cCodPrd))
		return msgStop('PRODUTO INVALIDO','[ERRO]')
	EndIF			

	IF lNovaPes

		SA1->(dbSetOrder(1),dbSeek(xFilial(alias())+cCliente+cLojaCli))

		//-- Inicia um novo registro de pesagem
		SZ3->(dbSetOrder(1),reclock(Alias(),.T.))
			SZ3->Z3_FILIAL := xFilial("SZ3")
			SZ3->Z3_CODIGO := getSxeNum("SZ3","Z3_CODIGO")
			SZ3->Z3_DATA   := date()
			SZ3->Z3_VEICULO:= cVeiculo
			SZ3->Z3_CLIENTE:= SA1->A1_COD
			SZ3->Z3_LOJA   := SA1->A1_LOJA
			SZ3->Z3_NOME   := SA1->A1_NOME
			SZ3->Z3_DTHRPES:= dtoc(date()) + ' ' + substr(time(),1,5)
		SZ3->(msunlock())	

		confirmSX8()

		nTara				:= DA3->DA3_TARA

		//-- Adiciona o registro referente à tara
		SZ4->(dbSetOrder(1),reclock(alias(),.T.))
			SZ4->Z4_FILIAL := SZ3->Z3_FILIAL
			SZ4->Z4_CODIGO := SZ3->Z3_CODIGO
			SZ4->Z4_ITEM   := strzero(1,tamSX3("Z4_ITEM")[1])
			SZ4->Z4_TIPO   := '1'
			SZ4->Z4_PESO   := nTara
			SZ4->Z4_UM	   := "KG"
			SZ4->Z4_DTHRPES:= SZ3->Z3_DTHRPES
			SZ4->Z4_TES	   := cTes
		SZ4->(msunlock())	

		(cArqSZ3)->(reclock(alias(),.T.))
			(cArqSZ3)->Z3_FILIAL := SZ3->Z3_FILIAL
			(cArqSZ3)->Z3_CODIGO := SZ3->Z3_CODIGO
			(cArqSZ3)->Z3_CLIENTE:= SZ3->Z3_CLIENTE
			(cArqSZ3)->Z3_NOME	 := SZ3->Z3_NOME
			(cArqSZ3)->Z3_LOJA	 := SZ3->Z3_LOJA
			(cArqSZ3)->Z3_VEICULO:= SZ3->Z3_VEICULO
			(cArqSZ3)->Z3_DATA	 := SZ3->Z3_DATA
			(cArqSZ3)->Z3_DTHRPES:= SZ3->Z3_DTHRPES
		(cArqSZ3)->(msunlock())

	EndIF

	SZ4->(dbSetOrder(1),dbSeek((cArqSZ3)->(Z3_FILIAL+Z3_CODIGO)))

	nPesoAnt := 0
	cItemSZ4 := strzero(0,tamSX3('Z4_ITEM')[1])
	nVlrTotal:= 0

	While .not. SZ4->(eof()) .and. SZ4->(Z4_FILIAL+Z4_CODIGO) == (cArqSZ3)->(Z3_FILIAL+Z3_CODIGO)

		IF SZ4->Z4_TIPO == '1'

			nPesoAnt += SZ4->Z4_PESO

		Else
			
			SB1->(dbSetOrder(1),dbSeek(xFilial(alias())+SZ4->Z4_PRODUTO))

			IF alltrim(SB1->B1_UM) == 'TL'
				nPesoAnt += (SZ4->Z4_PESO * 1000)
			Else
				nPesoAnt += SZ4->Z4_PESO
			EndIF

			SB1->(dbSetOrder(1),dbSeek(xFilial(alias())+cCodPrd))

		EndIF

		nVlrTotal+= SZ4->Z4_TOTAL
		cItemSZ4 := SZ4->Z4_ITEM

		SZ4->(dbSkip())

	Enddo

	nPesoItem 	:= nPeso - nTaraVei
	nVlrItem 	:= round(nVlrPes,2)

	IF nPesoItem <= 0

		cMsg := "PESO ATUAL INVALIDO EM RELACAO AO TICKET " + (cArqSZ3)->Z3_CODIGO + " ENCONTRADO"
		cMsg += CRLF + "PESO CAPTURADO: "      				+ cValToChar(nPeso)
		cMsg += CRLF + "PESO ATUAL DO TICKET " 				+ cValToChar(nPesoAnt)
		cMsg += CRLF + "DESEJA INICIAR UM NOVO TICKET?"
		
		IF .not. msgYesNo(cMsg,"[ERRO]")		
			return
		EndIF

		SA1->(dbSetOrder(1),dbSeek(xFilial(alias())+cCliente+cLojaCli))

		//-- Inicia um novo registro de pesagem
		SZ3->(dbSetOrder(1),reclock(Alias(),.T.))
			SZ3->Z3_FILIAL := xFilial("SZ3")
			SZ3->Z3_CODIGO := getSxeNum("SZ3","Z3_CODIGO")
			SZ3->Z3_DATA   := date()
			SZ3->Z3_VEICULO:= cVeiculo
			SZ3->Z3_CLIENTE:= SA1->A1_COD
			SZ3->Z3_LOJA   := SA1->A1_LOJA
			SZ3->Z3_NOME   := SA1->A1_NOME
			SZ3->Z3_DTHRPES:= dtoc(date()) + ' ' + substr(time(),1,5)
		SZ3->(msunlock())	

		confirmSX8()

		nTara				:= DA3->DA3_TARA
		nTaraVei			:= DA3->DA3_TARA
		nPesoItem 			:= nPeso - nTara

		//-- Adiciona o registro referente à tara
		SZ4->(dbSetOrder(1),reclock(alias(),.T.))
			SZ4->Z4_FILIAL := SZ3->Z3_FILIAL
			SZ4->Z4_CODIGO := SZ3->Z3_CODIGO
			SZ4->Z4_ITEM   := strzero(1,tamSX3("Z4_ITEM")[1])
			SZ4->Z4_TIPO   := '1'
			SZ4->Z4_PESO   := nTara
			SZ4->Z4_UM	   := "KG"
			SZ4->Z4_DTHRPES:= SZ3->Z3_DTHRPES
			SZ4->Z4_TES	   := cTes
		SZ4->(msunlock())			

		(cArqSZ3)->(reclock(alias(),.T.))
			(cArqSZ3)->Z3_FILIAL := SZ3->Z3_FILIAL
			(cArqSZ3)->Z3_CODIGO := SZ3->Z3_CODIGO
			(cArqSZ3)->Z3_CLIENTE:= SZ3->Z3_CLIENTE
			(cArqSZ3)->Z3_LOJA	 := SZ3->Z3_LOJA
			(cArqSZ3)->Z3_NOME	 := SZ3->Z3_NOME
			(cArqSZ3)->Z3_VEICULO:= SZ3->Z3_VEICULO
			(cArqSZ3)->Z3_DATA	 := SZ3->Z3_DATA
			(cArqSZ3)->Z3_DTHRPES:= SZ3->Z3_DTHRPES
		(cArqSZ3)->(msunlock())						

	EndIF

	IF alltrim(SB1->B1_UM) == 'TL'
		nPesoItem:= nPesoItem / 1000
		nVlrItem := round((nPesoItem * nPrcPes),2)
	EndIF

	IF .not. empty(SB1->B1_TS)
		IF SF4->(dbSetOrder(1),dbSeek(xFilial(alias())+SB1->B1_TS))
			cTes := SF4->F4_CODIGO
		EndIF
	EndIF

	cDataHr := dtoc(date()) + ' ' + substr(time(),1,5)

	//-- Adiciona o registro referente à pesagem
	SZ4->(dbSetOrder(1),reclock(alias(),.T.))
		SZ4->Z4_FILIAL := SZ3->Z3_FILIAL
		SZ4->Z4_CODIGO := SZ3->Z3_CODIGO
		SZ4->Z4_ITEM   := soma1(cItemSZ4)
		SZ4->Z4_TIPO   := '2'
		SZ4->Z4_PESO   := nPesoItem
		SZ4->Z4_TES	   := cTes
		SZ4->Z4_PRODUTO:= SB1->B1_COD
		SZ4->Z4_DESCRIC:= alltrim(substr(SB1->B1_DESC,tamSX3('Z4_DESCRIC')[1]))
		SZ4->Z4_UM	   := SB1->B1_UM
		SZ4->Z4_PRECO  := nPrcPes
		SZ4->Z4_TOTAL  := round(nPesoItem * nPrcPes,2)
		SZ4->Z4_DTHRPES:= cDataHr
	SZ4->(msunlock())	

	SZ4->(dbSetOrder(1),dbSeek((cArqSZ3)->(Z3_FILIAL+Z3_CODIGO)))

	nVlrTotal:= 0

	//-- Calculo do valor total
	While .not. SZ4->(eof()) .and. SZ4->(Z4_FILIAL+Z4_CODIGO) == (cArqSZ3)->(Z3_FILIAL+Z3_CODIGO)

		IF SZ4->Z4_TIPO == '1'
			SZ4->(dbSkip())
			Loop
		EndIF

		nVlrTotal += SZ4->Z4_TOTAL
		SZ4->(dbSkip())

	Enddo

	(cArqSZ3)->(reclock(alias(),.F.),Z3_TOTAL := nVlrTotal, Z3_DTHRPES := cDataHr,msunlock())
	SZ3->(dbSetOrder(1),dbSeek((cArqSZ3)->(Z3_FILIAL+Z3_CODIGO)),reclock(alias(),.F.),Z3_TOTAL := nVlrTotal, Z3_DTHRPES := cDataHr,msunlock())

	nVlrPes := 0
	nPrcPes := 0

	oGetB:ctrlRefresh()
	oGetC:ctrlRefresh()

	IF lNovaPes
		oMarkBrw:updateBrowse(.T.)
	Else	
		oMarkBrw:refresh()
	EndIF	

	msgInfo('PESAGEM ADICIONADA' + CRLF + 'TICKET: ' + SZ3->Z3_CODIGO,'[SUCESSO]')
	
Return

/*/{Protheus.doc} fnGetPrc
	Recupera o preco do produto
	@type  Static Function
	/*/
Static Function fnGetPrc()

    Local nPreco   := SB1->B1_PRV1

    Local aAreaDA0 := DA0->(getArea())
    Local aAreaDA1 := DA1->(getArea())  

    IF .not. empty(cCodTab)    

        IF DA0->(dbSetOrder(1),dbSeek(xFilial(alias())+cCodTab))

            IF DA1->(dbSetOrder(1),dbSeek(DA0->(DA0_FILIAL+DA0_CODTAB)+SB1->B1_COD))

                nPreco := DA1->DA1_PRCVEN

                While .not. DA1->(eof()) .and. DA1->(DA1_FILIAL+DA1_CODTAB+DA1_CODPRO) == DA0->(DA0_FILIAL+DA0_CODTAB) + SB1->B1_COD
                    
                    IF SA1->A1_TIPO == 'F' .and. DA1->DA1_TIPPRE == '2'

                        nPreco := DA1->DA1_PRCVEN

                    ElseIF SA1->A1_TIPO <> 'F' .and. DA1->DA1_TIPPRE == '1'  

                        nPreco := DA1->DA1_PRCVEN          

                    EndIF

                    DA1->(dbSkip())

                Enddo

            EndIF

        EndIF

    EndIF

    nPrcPes := nPreco
	nVlrPes := iif(alltrim(SB1->B1_UM) == 'TL',round(((nPeso - nTaraVei) / 1000) * nPreco,2),round((nPeso - nTaraVei) * nPreco,2))

	oGetA:ctrlRefresh()
	oGetB:ctrlRefresh()
	oGetC:ctrlRefresh()

    restArea(aAreaDA0)
    restArea(aAreaDA1)
	
Return nPreco

/*/{Protheus.doc} fnColunas
    Recupera os dados das colunas a serem exibidas
    @type  Static Function
    @author Klaus Wolfgram
    @since 16/07/2022
    @version 1.0
    /*/
Static Function fnColunas()

    Local aColunas   := array(0)
	Local oColuna	 := nil
	Local aListSX3   := array(0)
	Local cTitulo	 := ''
	Local cAliasSX3  := ''
    Local x

	cAliasSX3 		 := getNextAlias()

	BeginSQL alias cAliasSX3
		SELECT * FROM SX3010 SX3
		WHERE SX3.%notdel%
		AND X3_ARQUIVO = 'SZ3'
		AND X3_CAMPO <> 'Z3_FILIAL'
		ORDER BY X3_ORDEM
	EndSQL 

	While .not. (cAliasSX3)->(eof())
		
		aadd(aListSX3,{ (cAliasSX3)->X3_CAMPO	,;
						(cAliasSX3)->X3_TITULO	,;
						(cAliasSX3)->X3_TAMANHO	,;
						(cAliasSX3)->X3_DECIMAL ,;
						(cAliasSX3)->X3_PICTURE })

		(cAliasSX3)->(dbSkip())

	Enddo

	(cAliasSX3)->(dbCloseArea())

    For x := 1 To Len(aListSX3)

		cTitulo := aListSX3[x,2]
			
		IF alltrim(aListSX3[x,1]) == 'Z3_CODIGO'
			cTitulo := 'Ticket'
		EndIF		

        oColuna := fwBrwColumn():new()
        oColuna:setData(&('{||(cArqSZ3)->' + aListSX3[x,1] + '}'))
        oColuna:setTitle(cTitulo)

		IF alltrim(aListSX3[x,1]) == 'Z3_NOME'
        	oColuna:setSize(aListSX3[x,3] - 10)
		Else
			oColuna:setSize(aListSX3[x,3])	
		EndIF

        oColuna:setDecimal(aListSX3[x,4])
        oColuna:setPicture(pesqpict("SZ3",aListSX3[x,1]))

        aadd(aColunas,oColuna)

		IF alltrim(aListSX3[x,1]) == 'Z3_NOME'

			oColuna := fwBrwColumn():new()
			oColuna:setData(&('{||U_APPFT03P()}'))
			oColuna:setTitle('Produto')
			oColuna:setSize(15)
			oColuna:setDecimal(0)
			oColuna:setPicture('@!')

			aadd(aColunas,oColuna)
		EndIF				

    Next

	oColuna := nil
    
Return aColunas

/*/{Protheus.doc} APPFT03P
	Recupera os dados do produto
	@type  User Function
	@author Klaus Wolfgram
	@since 19/08/2022
	/*/
User Function APPFT03P()

	Local cProduto 	:= ''

	SZ4->(dbSetOrder(1),dbSeek(xFilial(alias())+(cArqSZ3)->Z3_CODIGO))

	While .not. SZ4->(eof()) .and. SZ4->(Z4_FILIAL+Z4_CODIGO) == xFilial('SZ4')+(cArqSZ3)->Z3_CODIGO
		
		IF empty(SZ4->Z4_PRODUTO)
			SZ4->(dbSkip())
			Loop
		EndIF

		SB1->(dbSetOrder(1),dbSeek(xFilial(alias())+SZ4->Z4_PRODUTO))	
		
		cProduto := alltrim(SB1->B1_DESC)

		SZ4->(dbSkip())

	Enddo
	
Return cProduto

//-- Botao para limpar os dados da tela
Static Function fnLimpar

	cCodTab := space(tamSX3('DA0_CODTAB')[1])
	cDescTab:= space(tamSX3('DA0_DESCRI')[1])
	cCondPag:= space(tamSX3('E4_CODIGO' )[1])
	cDescPag:= space(tamSX3('E4_DESCRI' )[1])
	cTipoPer:= space(20)
	cVeiculo:= space(tamSX3('DA3_COD'   )[1])
	cDescVei:= space(tamSX3('DA3_DESC'  )[1])
	cCodPrd := space(tamSX3('B1_COD'    )[1])
	cDescPrd:= space(tamSX3('B1_DESC'   )[1])
	cCliente:= space(tamSX3('A1_COD'    )[1])
	cLojaCli:= space(tamSX3('A1_LOJA'   )[1])
	cNomeCli:= space(tamSX3('A1_NOME'   )[1])
	nPrcPes := 999.99//Transform(0,"@E 999,999.9999")
	nVlrPes := 999999.99//Transform(0,"@E 999,999.99")

	oGet2:ctrlRefresh()
	oGet3:ctrlRefresh()
	oGet4:ctrlRefresh()
	oGet5:ctrlRefresh()
	oGet6:ctrlRefresh()
	oGet7:ctrlRefresh()
	oGet8:ctrlRefresh()
	oGet9:ctrlRefresh()
	oGetA:ctrlRefresh()
	oGetB:ctrlRefresh()
	oGetC:ctrlRefresh()

Return

//-- Funcao para recebimento de valores do cliente
Static Function fnGetPg

	Local nOpcao := 0

	nOpcao := aviso('Forma de pagamento','Selecione a forma de pagamento.',{'Dinheiro','Boleto','Outros'},2)

	IF nOpcao = 1

		IF empty((cArqSZ3)->Z3_PEDIDO)
			return msgStop('PEDIDO DE VENDAS NAO ENCONTRADO','[ERRO]')
		EndIF

		IF .not. SC6->(dbSetOrder(1),dbSeek(xFilial(alias())+(cArqSZ3)->Z3_PEDIDO))
			return msgStop('PEDIDO DE VENDAS NAO ENCONTRADO','[ERRO]')
		EndIF	

		SC5->(dbSetOrder(1),dbSeek(SC6->(C6_FILIAL+C6_NUM)))	

		//-- Pagamento em dinheiro
		lret := fnGetRS()

		//-- Grava forma de pagamento em dinheiro
		IF lret
			IF SC5->(fieldpos('C5_YFORMPG')) > 0
				SC5->(reclock('SC5',.F.),C5_YFORMPG := 'DINHEIRO',msunlock())
			EndIF
		EndIF

	ElseIF nOpcao = 2

		IF empty((cArqSZ3)->Z3_PEDIDO)
			return msgStop('PEDIDO DE VENDAS NAO ENCONTRADO','[ERRO]')
		EndIF

		IF .not. SC6->(dbSetOrder(1),dbSeek(xFilial(alias())+(cArqSZ3)->Z3_PEDIDO))
			return msgStop('PEDIDO DE VENDAS NAO ENCONTRADO','[ERRO]')
		EndIF	

		SC5->(dbSetOrder(1),dbSeek(SC6->(C6_FILIAL+C6_NUM)))				

		//-- Forma de pagamento por boleto
		U_BOLBRAD(SC6->C6_FILIAL,SC6->C6_SERIE,SC6->C6_NOTA)

		//-- Grava forma de pagamento por boleto
		IF SE1->(dbSetOrder(1),dbSeek(SC6->(C6_FILIAL+C6_SERIE+C6_NOTA)))
			IF .not. empty(SE1->E1_NUMBCO)
				IF SC5->(fieldpos('C5_YFORMPG')) > 0
					SC5->(reclock('SC5',.F.),C5_YFORMPG := 'BOLETO',msunlock())
				EndIF
			EndIF
		EndIF

	Else

		IF empty((cArqSZ3)->Z3_PEDIDO)
			return msgStop('PEDIDO DE VENDAS NAO ENCONTRADO','[ERRO]')
		EndIF

		IF .not. SC6->(dbSetOrder(1),dbSeek(xFilial(alias())+(cArqSZ3)->Z3_PEDIDO))
			return msgStop('PEDIDO DE VENDAS NAO ENCONTRADO','[ERRO]')
		EndIF	

		SC5->(dbSetOrder(1),dbSeek(SC6->(C6_FILIAL+C6_NUM)))

		//-- Forma de pagamento diversos
		fina087a()

		//-- Grava forma de pagamento pela opcao diversos
		IF SE1->(dbSetOrder(1),dbSeek(SC6->(C6_FILIAL+C6_SERIE+C6_NOTA)))
			IF SE1->E1_SALDO <> SE1->E1_VALOR
				IF SC5->(fieldpos('C5_YFORMPG')) > 0
					SC5->(reclock('SC5',.F.),C5_YFORMPG := 'DIVERSOS',msunlock())
				EndIF
			EndIF
		EndIF

	EndIF

	//-- Atualiza a tela
	oMarkBrw:refresh()

Return

//-- Funcao para recebimento em dinheiro
Static Function fnGetRS

	Local cAliasSQL := ''
	Local cSQL      := ''
	Local cBcoGav   := ''
	Local cAgeGav   := ''
	Local cCtaGav   := ''
	Local nSaldo    := 0
	Local nValor    := 0
	Local nTroco    := 0
	Local nVlrAux   := 0
	Local nOpcao    := 0
	Local oDlgTrc   := Nil
	Local oSayTrc   := Nil
	Local oGetSld   := Nil
	Local oGetVlr   := Nil
	Local oGetTrc   := Nil
	Local oGetGav   := Nil
	Local oBtnCon   := Nil
	Local oBtnCan   := Nil
	Local oFonte    := TFont():new('Arial',,015,,.T.)
	Local aBaixa    := {}

	Private lMsErroAuto := .F.

	cAliasSQL       := getNextAlias()

	BeginSQL Alias cAliasSQL
        SELECT IsNull(SUM(E1_SALDO),0) E1_SALDO 
        FROM %table:SE1% SE1
        WHERE SE1.%notdel%
        AND E1_FILIAL = %exp:xFilial("SE1")%
        AND E1_PREFIXO = %exp:SC6->C6_SERIE%
        AND E1_NUM  = %exp:SC6->C6_NOTA%
        AND E1_CLIENTE = %exp:SC6->C6_CLI%
        AND E1_LOJA = %exp:SC6->C6_LOJA%
        AND E1_TIPO = 'NF'
	EndSQL

	cSQL := getLastQuery()[2]

	(cAliasSQL)->(dbEval({|| nSaldo := E1_SALDO}),dbCloseArea())

	oDlgTrc := tDialog():new(0,0,300,600,"Recebimento",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oSayTrc := tSay():new(010,010,{|| 'Saldo'},oDlgTrc,,oFonte,,,,.T.,,,100,,,,,,)
	oGetSld := tGet():new(010,060,{|u|if(pCount()>0, nSaldo := u,nSaldo)},oDlgTrc,100,015,"@E 999,999,999.99",{||.T.},,,,,,.T.,,,{||.F.},,.T.,,,,,'nSaldo',,,,.T.)

	oSayTrc := tSay():new(030,010,{|| 'Valor'},oDlgTrc,,oFonte,,,,.T.,,,100,,,,,,)
	oGetVlr := tGet():new(030,060,{|u|if(pCount()>0, nValor := u,nValor)},oDlgTrc,100,015,"@E 999,999,999.99",{||.T.},,,,,,.T.,,,{||.T.},,.T.,,,,,'nValor',,,,.T.)
	oGetVlr:bChange := {|| nTroco := iif(nValor > nSaldo, nValor - nSaldo, 0), oGetTrc:ctrlRefresh()}

	oSayTrc := tSay():new(050,010,{|| 'Troco'},oDlgTrc,,oFonte,,,,.T.,,,100,,,,,,)
	oGetTrc := tGet():new(050,060,{|u|if(pCount()>0, nTroco := u,nTroco)},oDlgTrc,100,015,"@E 999,999,999.99",{||.T.},,,,,,.T.,,,{||.F.},,.T.,,,,,'nTroco',,,,.T.)

	SA6->(dbSetOrder(1),dbSeek(xFilial('SA6')+'GAV'))

	cBcoGav := SA6->A6_COD
	cAgeGav := SA6->A6_AGENCIA
	cCtaGav := SA6->A6_NUMCON

	oSayTrc := tSay():new(070,010,{|| 'Gaveta'   },oDlgTrc,,oFonte,,,,.T.,,,100,,,,,,)

	oGetGav := tGet():new(070,060,{|u|if(pCount()>0, cBcoGav := u,cBcoGav)},oDlgTrc,050,015,"@!",{||.T.},,,,,,.T.,,,{||.T.},,.T.,,,,,'cBcoGav',,,,.T.); oGetGav:cF3 := 'SA6'
	oGetGav := tGet():new(070,120,{|u|if(pCount()>0, cAgeGav := u,cAgeGav)},oDlgTrc,050,015,"@!",{||.T.},,,,,,.T.,,,{||.T.},,.T.,,,,,'cAgeGav',,,,.T.)
	oGetGav := tGet():new(070,180,{|u|if(pCount()>0, cCtaGav := u,cCtaGav)},oDlgTrc,050,015,"@!",{||.T.},,,,,,.T.,,,{||.T.},,.T.,,,,,'cCtaGav',,,,.T.)

	oBtnCon := tbutton():new(010,170,"Confirmar" ,oDlgTrc,{|| nOpcao := 1, oDlgTrc:end()},060,015,,,.F.,.T.,.F.,,.F.,,,.F.)
	oBtnCan := tbutton():new(030,170,"Cancelar"  ,oDlgTrc,{|| nOpcao := 0, oDlgTrc:end()},060,015,,,.F.,.T.,.F.,,.F.,,,.F.)

	oDlgTrc:lCentered := .T.
	oDlgTrc:activate()

	IF nOpcao <> 1
		Return .F.
	EndIF

	IF nValor <= 0
		msgStop('Valor Invalido')
		Return
	EndIF

	IF .not. SA6->(dbSetOrder(1),dbseek(xFilial('SA6')+cBcoGav+cAgeGav+cCtaGav))
		msgStop('Banco/Agencia/Conta invalidos')
		Return
	EndIF

	nVlrAux := nValor - nTroco

	cAliasSQL := getNextAlias()

	BeginSQL Alias cAliasSQL
        SELECT *
        FROM %table:SE1% SE1
        WHERE SE1.%notdel%
        AND E1_FILIAL   = %exp:xFilial("SE1")%
        AND E1_PREFIXO  = %exp:SC6->C6_SERIE%
        AND E1_NUM      = %exp:SC6->C6_NOTA%
        AND E1_CLIENTE  = %exp:SC6->C6_CLI%
        AND E1_LOJA     = %exp:SC6->C6_LOJA%
        AND E1_TIPO     = 'NF'
        ORDER BY E1_PARCELA
	EndSQL

	While .not. (cAliasSQL)->(eof())

		SE1->(dbSetOrder(1),dbGoTo((cAliasSQL)->R_E_C_N_O_))

		cHistBaixa := "BAL. - VlrR$: " + cValToChar(nValor) + ' TrocoR$: ' + cValToChar(nTroco)
		nVlrBaixa  := iif(SE1->E1_SALDO > nVlrAux,SE1->E1_SALDO,nVlrAux)
		nVlrAux    -= SE1->E1_SALDO

		aBaixa      := {}
		aadd(aBaixa,{"E1_PREFIXO"   ,SE1->E1_PREFIXO,Nil})
		aadd(aBaixa,{"E1_NUM"       ,SE1->E1_NUM    ,Nil})
		aadd(aBaixa,{"E1_TIPO"      ,SE1->E1_TIPO   ,Nil})
		aadd(aBaixa,{"E1_PARCELA"   ,SE1->E1_PARCELA,Nil})
		aadd(aBaixa,{"E1_CLIENTE"   ,SE1->E1_CLIENTE,Nil})
		aadd(aBaixa,{"E1_LOJA"      ,SE1->E1_LOJA   ,Nil})
		aadd(aBaixa,{"E1_NATUREZ"   ,SE1->E1_NATUREZ,Nil})
		aadd(aBaixa,{"AUTMOTBX"     ,"NOR"          ,Nil})
		aadd(aBaixa,{"AUTBANCO"     ,cBcoGav        ,Nil})
		aadd(aBaixa,{"AUTAGENCIA"   ,cAgeGav        ,Nil})
		aadd(aBaixa,{"AUTCONTA"     ,cCtaGav        ,Nil})
		aadd(aBaixa,{"AUTDTBAIXA"   ,ddatabase      ,Nil})
		aadd(aBaixa,{"AUTDTCREDITO" ,ddatabase      ,Nil})
		aadd(aBaixa,{"AUTHIST"      ,cHistBaixa     ,Nil})
		aadd(aBaixa,{"NVALREC"      ,nVlrBaixa      ,Nil})

		lMsErroAuto := .F.

		msExecAuto({|x,y| fina070(x,y)},aBaixa,3)

		IF lMsErroAuto
			mostraErro()
			Return
		EndIF

		IF nVlrAux <= 0
			exit
		EndIF

		(cAliasSQL)->(dbSkip())

	Enddo

	msgInfo('Recebimento confirmado')

	oDlgTrc   := Nil
	oSayTrc   := Nil
	oGetSld   := Nil
	oGetVlr   := Nil
	oGetTrc   := Nil
	oGetGav   := Nil
	oBtnCon   := Nil
	oBtnCan   := Nil

Return .T.

//-- Funcao auxiliar para impressao do pedido 
Static Function fnPrint(nOpc)

	Default nOpc := 1

	IF nOpc = 1

		U_IMPFT005()

	ElseIF nOpc = 2

		IF empty((cArqSZ3)->Z3_PEDIDO)
			return msgStop('PEDIDO REFERENTE A ESSA PESAGEM AINDA NAO FOI GERADO','[ERRO]')
		EndIF

		U_IMPFT006((cArqSZ3)->Z3_PEDIDO)

	ElseIF nOpc = 3

		U_IMPFT007()
		
	EndIF

Return

//-- Funcao para retorno do valor total
Static Function fnGetVlr

	Local nValor 	:= 0

	IF .not. DA3->(dbSetOrder(1),dbSeek(xFilial('DA3')+cVeiculo)) .Or. empty(cVeiculo)
        return
	EndIF

	IF empty((cArqSZ3)->Z3_PEDIDO) .and. (cArqSZ3)->Z3_DATA = date()
		
		SZ4->(dbSetOrder(1),dbSeek((cArqSZ3)->(Z3_FILIAL+Z3_CODIGO)))

		While .not. SZ4->(eof()) .and. SZ4->(Z4_FILIAL+Z4_CODIGO) == (cArqSZ3)->(Z3_FILIAL+Z3_CODIGO)
			nValor += SZ4->Z4_TOTAL
			SZ4->(dbSkip())
		Enddo

	EndIF

	nVlrPes    := round(nValor,2)

Return

//-- Programa para digitacao do peso
Static Function fnDigPes

	IF .not. &("SX1->(dbSetOrder(1),dbSeek('APPFT003A ' + '01'))")
		&("SX1->(reclock('SX1',.T.))"				)
		&("SX1->X1_GRUPO	 	:= 'APPFT003A '"	)
		&("SX1->X1_ORDEM 		:= '01'"			)
		&("SX1->X1_PERGUNT		:= 'Peso?'"			)
		&("SX1->X1_PERSPA		:= 'Peso?'"			)
		&("SX1->X1_PERENG		:= 'Peso?'"			)
		&("SX1->X1_VARIAVL		:= 'MV_CH1'"		)
		&("SX1->X1_TIPO			:= 'N'"				)
		&("SX1->X1_TAMANHO		:= 10"				)
		&("SX1->X1_DECIMAL		:= 4"				)
		&("SX1->X1_PRESEL		:= 0"				)
		&("SX1->X1_GSC			:= 'G'"				)
		&("SX1->X1_VALID		:= ''"				)
		&("SX1->X1_VAR01		:= 'MV_PAR01'"		)
		&("SX1->X1_F3			:= ''"				)
		&("SX1->X1_PICTURE     := '@E 999,999.9999'")
		&("SX1->(msunlock())"						)
	EndIF

	IF Pergunte('APPFT003A ',.T.)
		nPeso           := MV_PAR01
		cPeso           := transform(nPeso,"@E 999,999.9999")
		oGet1:ctrlRefresh()
	EndIF

	fnGetPrc()

	oGetA:ctrlRefresh()
	oGetB:ctrlRefresh()
	oGetC:ctrlRefresh()

Return

//-- Programa para captura do peso da balanca
/*/
	Abre a porta serial. Os parametros passados entre aspas sao (na ordem da direita para a esquerda):
	- Porta Serial
	- Velocida de transmissao em bps
	- Paridade s/n
	- Quantidade de bits de dados
	- Bits de parada

	======================
	Pedreira Lajinha
	======================
	Porta:      COM3
	Velocidade: 4800
	Paridade:   n
	Bits:       7
	StopBits:   1
	Essas informacoes dependem da configuracao do periferico, o padrao esta demonstrado no exempo acima.

	{Protheus.doc} fnInitBal
	Inicia a conexao com a balanca.
	@type  Static Function
	@author Klaus Wolfgram
	@since 07/10/2022
	/*/
Static Function fnInitBal()

	Local cPorta    := fnGetCfg('PORTA'        ,'COM4' )
	Local cVelocid  := fnGetCfg('VELOCIDADE'   ,'1200' )
	Local cParidad  := fnGetCfg('PARIDADE'     ,'N'    )
	Local cBits     := fnGetCfg('BITS'         ,'7'    )
	Local cStopBits := fnGetCfg('STOPBITS'     ,'1'    )
	Local cConfig   := cPorta + ":" + cVelocid + "," + cParidad + "," + cBits + "," + cStopBits //'COM1:4800,n,8,1'
	Local lRet      := msOpenPort(@nHdlBal, cConfig)

	IF nHdlBal < 0
		lRet      	:= msOpenPort(@nHdlBal, cConfig)
	Else
		lRet      	:= .T.
	EndIF

	IF .not. lRet
		
		msgStop('Falha ao conectar à balança','Erro')
		Return .F.
		
	EndIF
	
Return .T.

//-- Consulta os pesos na balanca
Static Function fnGetPes(lTimer)

	Local cPeso     := '9999999'
	Local cTexto    := '9999999'

	Default lTimer  := .F.

	IF lTimer
		conout('Executado a partir do timer')
	EndIF

	msWrite(nHdlBal,chr(5))

	/*/
	sleep(130)
	xx := msRead(nHdlBal, @cTexto)
	sleep(240)
	msRead(nHdlBal, @cTexto)
	/*/

	sleep(130)
	lRead := msRead(nHdlBal, @cTexto)

	IF .not. lRead
		sleep(240)
		lRead := msRead(nHdlBal, @cTexto)
	EndIF

	IF .not. lRead
		
		//-- Caso falhe as tentativas de leitura da balanca, encerra a conexao atual e tenta conectar de novo.
		msClosePort(nHdlBal)
		
		//-- Inicia a conexao com a balanca
		fnInitBal()
		
		//-- Tenta executar a leitura novamente
		msWrite(nHdlBal, chr(5))
		sleep(130)

		lRead := msRead(nHdlBal, @cTexto)	

		//-- Exibe mensagem de erro e encerra o programa caso nao consiga efetuar a leitura
		IF .not. lTimer
			msgStop('ERRO AO EFETUAR A LEITURA DO PESO DA BALANCA','[ERRO]')
		EndIF

		return 0		

	EndIF

	cAux := (substr(cTexto, at("0", cTexto) + 1, 7))

	IF isNumeric(cAux)
		cPeso := cAux
	Else
		cPeso := '0'
	EndIF

	IF empty(cPeso) .Or. val(cPeso) == 0
		cPeso := '0000000'
	EndIF

	nPeso := val(cPeso)

	cDescPrd := posicione('SB1',1,xFilial('SB1')+cCodPrd,'B1_DESC')

	fnGetPrc()

	oGetA:ctrlRefresh()
	oGetB:ctrlRefresh()
	oGetC:ctrlRefresh()

Return nPeso

Static Function fnGetCfg(cConf,cDef)

	Local cTxtConf := 'PORTA:COM4' + CRLF + 'VELOCIDADE:1200' + CRLF + 'PARIDADE:N' + CRLF + 'BITS:7' + CRLF + 'STOPBITS:1'
	Local cBuffer  := ''
	Local cRetorno := ''
	Local nHdl     := 0

	Default cConf  := ''
	Default cDef   := ''

	IF empty(cConf)
		Return cDef
	EndIF

	IF .not. File('C:\BALANCA\config_balanca.ini')

		IF .not. existDir('C:\BALANCA\')
			Makedir('C:\BALANCA\')
		EndIF

		MemoWrite('C:\BALANCA\config_balanca.ini',cTxtConf)

	EndIF

	nHdl := FT_FUSE('C:\BALANCA\config_balanca.ini')

	IF nHdl < 0
		Return cDef
	EndIF

	FT_FGOTOP()

	do case
	case cConf == 'PORTA'
		FT_FGOTOP()
	case cConf == 'VELOCIDADE'
		FT_FSKIP()
	case cConf == 'PARIDADE'
		FT_FSKIP(2)
	case cConf == 'BITS'
		FT_FSKIP(3)
	case cConf == 'STOPBITS'
		FT_FSKIP(4)
	End

	cBuffer  := FT_FREADLN()
	FT_FUSE()

	cRetorno := substr(cBuffer,AT(':',cBuffer) + 1)
	cRetorno := iif(empty(cRetorno),cDef,cRetorno)

Return cRetorno

Static function fnChkNFE(cSerie,cNota)

	Local cIdEnt        := ""
	Local cURL          := padr(getNewPar("MV_SPEDURL","http://"),250)
	Local cRetNF        := "000"
	Local aParam        := Array(3)
	Local lUsaColab     := .F.
	Local cModalidade   := ""
	Local lCte          := .F.

	Private cError      := ""

	cIdent              := fnGetEnt()
	aParam[01]          := cSerie
	aParam[02]          := cNota
	aParam[03]          := cNota

	oWS:= WSNFeSBRA():new()
	oWS:cUSERTOKEN      := "TOTVS"
	oWS:cID_ENT         := cIdEnt
	oWS:_URL            := alltrim(cURL)+"/NFeSBRA.apw"
	oWS:cIdInicial      := cSerie+cNota
	oWS:cIdFinal        := cSerie+cNota
	lOk                 := oWS:monitorFaixa()
	oRetorno            := oWS:oWsMonitorFaixaResult:oWSMonitorNfe

	fnGetListB(cIdEnt, cUrl, aParam, 1, "55", .F., .T., .F., .F.,lUsaColab)

	aNotas  := {}
	aXml2   := {}
	aadd(aNotas,{})
	aadd(Atail(aNotas),.F.)
	aadd(Atail(aNotas),"S")
	aadd(Atail(aNotas),SF2->F2_EMISSAO)
	aadd(Atail(aNotas),SF2->F2_SERIE)
	aadd(Atail(aNotas),SF2->F2_DOC)
	aadd(Atail(aNotas),SF2->F2_CLIENTE)
	aadd(Atail(aNotas),SF2->F2_LOJA)


	If lOk

		If Type("oRetorno[1]:OWSErro:OWSLoteNfe")<>"U"

			//cRetNF    := oRetorno[1]:OWSErro:OWSLoteNfe[1]:cMsgRetNFe
			//aviso("Atenção",oRetorno[1]:CRECOMENDACAO,{"OK"})

			cRetNF  := Subs((rtrim(oRetorno[1]:CRECOMENDACAO)) ,1,3)

			aXml2 := GetXMLNFE(cIdEnt,aNotas,@cModalidade,iif(lCTE,"57",""))

			RecLock("SF2")
			SF2->F2_CHVNFE  := substr(NfeIdSPED(aXml2[1][2],"Id"),4)
			MsUnlock()

			IF empty(SF2->F2_CHVNFE)
				msgStop('Nota não transmitida')
			EndIF

			//msgInfo(SF2->F2_CHVNFE,'Chave da Nota')

		Else

			aviso("Atenção",oRetorno[1]:CRECOMENDACAO,{"OK"})
			cRetNF  := "000"

		EndIf

	Else

		cRetNF := iif( empty(getWscError(3)),getWscError(1),getWscError(3) )
		aviso("Atenção",cRetNF,{"OK"})
		cRetNF := "000"

	EndIf

Return cRetNF


Static Function fnGetEnt

	Local aArea         := GetArea()
	Local cIdEnt        := ""
	Local cURL          := PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local oWs

	oWS := WsSPEDAdm():new()
	oWS:cUSERTOKEN := "TOTVS"
	oWS:oWSEMPRESA:cCNPJ       := iif(SM0->M0_TPINSC==2 .Or. empty(SM0->M0_TPINSC),SM0->M0_CGC,"")
	oWS:oWSEMPRESA:cCPF        := iif(SM0->M0_TPINSC==3,SM0->M0_CGC,"")
	oWS:oWSEMPRESA:cIE         := SM0->M0_INSC
	oWS:oWSEMPRESA:cIM         := SM0->M0_INSCM
	oWS:oWSEMPRESA:cNOME       := SM0->M0_NOMECOM
	oWS:oWSEMPRESA:cFANTASIA   := SM0->M0_NOME
	oWS:oWSEMPRESA:cENDERECO   := FisGetEnd(SM0->M0_ENDENT)[1]
	oWS:oWSEMPRESA:cNUM        := FisGetEnd(SM0->M0_ENDENT)[3]
	oWS:oWSEMPRESA:cCOMPL      := FisGetEnd(SM0->M0_ENDENT)[4]
	oWS:oWSEMPRESA:cUF         := SM0->M0_ESTENT
	oWS:oWSEMPRESA:cCEP        := SM0->M0_CEPENT
	oWS:oWSEMPRESA:cCOD_MUN    := SM0->M0_CODMUN
	oWS:oWSEMPRESA:cCOD_PAIS   := "1058"
	oWS:oWSEMPRESA:cBAIRRO     := SM0->M0_BAIRENT
	oWS:oWSEMPRESA:cMUN        := SM0->M0_CIDENT
	oWS:oWSEMPRESA:cCEP_CP     := Nil
	oWS:oWSEMPRESA:cCP         := Nil
	oWS:oWSEMPRESA:cDDD        := Str(FisGetTel(SM0->M0_TEL)[2],3)
	oWS:oWSEMPRESA:cFONE       := alltrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
	oWS:oWSEMPRESA:cFAX        := alltrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
	oWS:oWSEMPRESA:cEMAIL      := UsrRetMail(RetCodUsr())
	oWS:oWSEMPRESA:cNIRE       := SM0->M0_NIRE
	oWS:oWSEMPRESA:dDTRE       := SM0->M0_DTRE
	oWS:oWSEMPRESA:cNIT        := iif(SM0->M0_TPINSC==1,SM0->M0_CGC,"")
	oWS:oWSEMPRESA:cINDSITESP  := ""
	oWS:oWSEMPRESA:cID_MATRIZ  := ""
	oWS:oWSOUTRASINSCRICOES:oWSInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():new()
	oWS:_URL := alltrim(cURL)+"/SPEDADM.apw"

	If oWs:ADMEMPRESAS()
		cIdEnt  := oWs:cADMEMPRESASRESULT
	Else
		aviso("SPED",iif(empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"Ok"},3)
	EndIf

	RestArea(aArea)

Return(cIdEnt)

static function fnGetListB(cIdEnt, cUrl, aParam, nTpMonitor, cModelo, lCte, lMsg, lMDfe, lTMS,lUsaColab)

	local aLote			:= {}
	local aListBox			:= {}
	local aRetorno			:= {}
	local cId				:= ""
	local cProtocolo		:= ""
	local cRetCodNfe		:= ""
	local cAviso			:= ""
	local cSerie			:= ""
	local cNota			:= ""

	local nAmbiente		:= ""
	local nModalidade		:= ""
	local cRecomendacao	:= ""
	local cTempoDeEspera	:= ""
	local nTempomedioSef	:= ""
	local nX				:= 0


	local oOk				:= loadBitMap(GetResources(), "ENABLE")
	local oNo				:= loadBitMap(GetResources(), "DISABLE")

	local cTenConsInd		:= ""
	local cObsConsInd		:= ""

	default lUsaColab		:= .F.
	default lMsg			:= .T.
	default lCte			:= .F.
	default lMDfe		:= .F.
	default cModelo		:= iif(lCte,"57",iif(lMDfe,"58","55"))
	default lTMS			:= .F.

	if cModelo <> "65"
		lUsaColab := UsaColaboracao( iif(lCte,"2",iif(lMDFe,"5","1")) )
	endif

	if 	lUsaColab
		//processa monitoramento por tempo
		aRetorno := colNfeMonProc( aParam, nTpMonitor, cModelo, lCte, @cAviso, lMDfe, lTMS ,lUsaColab )
	else
		//processa monitoramento
		aRetorno := procMonitorDoc(cIdEnt, cUrl, aParam, nTpMonitor, cModelo, lCte, @cAviso)
	endif

	if empty(cAviso)

		for nX := 1 to len(aRetorno)

			cId				:= aRetorno[nX][01]
			cSerie			:= aRetorno[nX][02]
			cNota			:= aRetorno[nX][03]
			cProtocolo		:= aRetorno[nX][04]
			cRetCodNfe		:= aRetorno[nX][05]
			nAmbiente		:= aRetorno[nX][07]
			nModalidade		:= aRetorno[nX][08]
			cRecomendacao	:= aRetorno[nX][09]
			cTempoDeEspera	:= aRetorno[nX][01]
			nTempomedioSef	:= aRetorno[nX][11]
			aLote			:= aRetorno[nX][12]
			cTenConsInd		:= aRetorno[nX][15]

			if 	Len(aRetorno) >= 16
				cObsConsInd		:= aRetorno[nX][16]
			endif

			aadd(aListBox,{	iif(empty(cProtocolo) .Or.  cRetCodNfe $ RetCodDene(),oNo,oOk),;
				cId,;
				iif(nAmbiente == 1,'PRODUCAO','HOMOLOGACAO'),;
				iif(lUsaColab,iif(nModalidade==1,'STR0058','STR0059'),iif(nModalidade ==1 .Or. nModalidade == 4 .Or. nModalidade == 6,'STR0058','STR0059')),;
				cProtocolo,;
				cRecomendacao,;
				cTempoDeEspera,;
				nTempoMedioSef,;
				aLote,;
				cTenConsInd,;
				cObsConsInd;
				})
		next

		if empty(aListBox) .and. lMsg .and. !lCte
			aviso("SPED",'STR0106',{'STR0114'})
		endIf

	elseif !lCTe .and. lMsg
		aviso("SPED", cAviso,{'STR0114'},3)
	endif

return aListBox

//-- Programa para inclusao do pedido de vendas
Static Function fnIncPed()

    Local nRetorno      := 0   //SC5->(A410Inclui(Alias(),recno(),4,.F.))
    Local lRetorno      := .F. //nRetorno == 1
    Local cCampo        := ''
    Local x

    Default lSegPes     := .F.

    Private cCadastro   := 'Pesagem Mod. 2 - Pedreira Lajinha'
    Private INCLUI      := .T.
    Private ALTERA      := .F.
    Private aRotina     := &('staticCall(MATA410,MenuDef)')
    Private nOpc        := 3
    Private aCols[0]
    Private aHeader[0]
    Private aColsGrade[0]
    Private aHeadGrade[0]

    pergunte("MTA410",.F.)

	IF .not. empty((cArqSZ3)->Z3_PEDIDO)
		return msgAlert('PESAGEM ENCERRADA ANTERIORMENTE','[ATENCAO]')
	EndIF	

	SZ3->(dbSetOrder(1),dbSeek((cArqSZ3)->(Z3_FILIAL+Z3_CODIGO)))
	SZ4->(dbSetOrder(1),dbSeek((cArqSZ3)->(Z3_FILIAL+Z3_CODIGO)))   

    lSA1 := SA1->(dbSetOrder(1),dbSeek(xFilial('SA1')+(cArqSZ3)->(Z3_CLIENTE+Z3_LOJA)))
    lDA3 := DA3->(dbSetOrder(1),dbSeek(xFilial('DA3')+(cArqSZ3)->Z3_VEICULO))
    lDA4 := DA4->(dbSetOrder(1),dbSeek(xFilial('DA4')+DA3->DA3_MOTORI))

    &("SX3->(dbSetOrder(1),dbSeek('SC5'))")

    While .not. SX3->(eof()) .and. SX3->X3_ARQUIVO == 'SC5'
        cCampo                  := &("alltrim(SX3->X3_CAMPO)")
        IF alltrim(cCampo) == 'C5_NUMPR'
            M->C5_NUMPR         := ''
        Else    
            M->&(cCampo)        := criavar(cCampo,.T.)
        EndIF
        &("SX3->(dbSkip())")
    Enddo

	cFormPag	:= iif(empty(SA1->A1_TIPPER),'','PERIODO')

	IF empty(SA1->A1_COND)		
		SE4->(dbSetOrder(1),dbGoTop())
		While .not. SE4->(eof()) .and. SE4->E4_FILIAL == xFilial("SE4")			
			IF .not. SE4->E4_MSBLQL == '1'
				exit
			EndIF
			SE4->(dbSkip())
		Enddo
	Else		
		IF .not. SE4->(dbSetOrder(1),dbSeek(xFilial(alias())+SA1->A1_COND))			
			SE4->(dbSetOrder(1),dbGoTop())
			While .not. SE4->(eof()) .and. SE4->E4_FILIAL == xFilial("SE4")				
				IF .not. SE4->E4_MSBLQL == '1'
					exit
				EndIF
				SE4->(dbSkip())				
			Enddo
		EndIF
	EndIF

	IF empty(SA1->A1_NATUREZ)
		SED->(dbSetOrder(1),dbSeek(xFilial(alias())+'101'))
	Else	
		IF .not. SED->(dbSetOrder(1),dbSeek(xFilial(alias())+SA1->A1_NATUREZ))
			SED->(dbSetOrder(1),dbSeek(xFilial(alias())+'101'))
		EndIF
	EndIF		

    M->C5_TIPO          := 'N'
    M->C5_CLIENTE       := SA1->A1_COD
    M->C5_LOJACLI       := SA1->A1_LOJA
    M->C5_TIPOCLI       := SA1->A1_TIPO   
    M->C5_CLIENT        := SA1->A1_COD
    M->C5_LOJACLI       := SA1->A1_LOJA
    M->C5_CONDPAG       := SE4->E4_CODIGO
    M->C5_YMSGNFE       := SA1->A1_YMSGNFE
    M->C5_TPFRETE       := 'S'
    M->C5_PESOL         := 0
    M->C5_PBRUTO        := 0
    M->C5_VOLUME1       := 1
    M->C5_ESPECI1       := 'GRANEL'
    M->C5_NATUREZ       := SED->ED_CODIGO  
    M->C5_VEICULO       := DA3->DA3_COD     
	M->C5_PLACA1		:= DA3->DA3_PLACA
    M->C5_MOEDTIT       := 1
    M->C5_LIBEROK       := ''
    M->C5_REIMP         := 0  
    M->C5_YFORMPG       := iif(empty(SA1->A1_TIPPER),'','PERIODO')
	M->C5_INDPRES		:= '1'

    aHeader             := fnHeader()
    aCols          		:= fnCols()          

    For x := 1 To Len(aCols)
        matGrdMont(x)
    Next    

	_lLibQtd			:= .F.

    nRetorno            := SC5->(a410Inclui(alias(),recno(),4,.T.))
    lRetorno            := nRetorno == 1

	_lLibQtd			:= .T.

	fnUpdPed()

    //-- Gambiarra para atualizar nomes de clientes e fornecedores nos pedidos de vendas e descricao de produto na tabela de saldos
    U_APPG010()

    IF lRetorno

		SZ3->(reclock(alias(),.F.))
			SZ3->Z3_PEDIDO := SC5->C5_NUM
		SZ3->(msunlock())

		(cArqSZ3)->(dbSetOrder(1),dbSeek(SZ3->(Z3_FILIAL+Z3_CODIGO)))	
        
		(cArqSZ3)->(reclock(alias(),.F.))
			(cArqSZ3)->Z3_PEDIDO := SC5->C5_NUM
		(cArqSZ3)->(msunlock())

		oMarkBrw:refresh()
		msgInfo('PEDIDO DE VENDAS NR: ' + SC5->C5_NUM,'[SUCESSO]')	

		SC6->(dbSetOrder(1),dbSeek(SC5->(C5_FILIAL+C5_NUM)))

		While .not. SC6->(eof()) .and. SC6->(C6_FILIAL+C6_NUM) == SC5->(C5_FILIAL+C5_NUM)

			IF SC6->C6_VALDESC > 0

				SC6->(reclock(alias(),.F.))
					SC6->C6_VALOR  := round(SC6->(C6_PRUNIT * C6_QTDVEN),2) - SC6->C6_VALDESC
					SC6->C6_DESCONT:= round(SC6->((C6_VALDESC / C6_VALOR) * 100),2)
					SC6->C6_PRCVEN := round(SC6->(C6_VALOR / C6_QTDVEN),2)
				SC6->(msunlock())

			EndIF

			SC5->(dbSkip())
		Enddo

		IF empty(SA1->A1_TIPPER)
			IF msgYesNo('Deseja preparar a nota de saída?','NF Saída')
				fnProcNF()
			EndIF
		EndIF

		//-- grava o nome do cliente ou fornecedor nas notas de saida
    	fnUpdSF2()		

    EndIF     

Return lRetorno

//-- Grava o nome do cliente nas notas de saida
Static Function fnUpdSF2

    Local cSQL := ''

    cSQL := "UPDATE " + RetSQLName("SF2")
    cSQL += CRLF + "SET F2_YNOME = A1_NOME "
    cSQL += CRLF + "FROM " + RetSQLName("SF2") + " SF2 "
    cSQL += CRLF + "JOIN " + RetSQLName("SA1") + " SA1 ON SA1.D_E_L_E_T_ = '' AND A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA"
    cSQL += CRLF + "WHERE SF2.D_E_L_E_T_ = '' "
    cSQL += CRLF + "AND F2_YNOME = '' "
    cSQL += CRLF + "AND F2_TIPO NOT IN ('B','D') "

    TCSQLExec(cSQL)

    cSQL := "UPDATE " + RetSQLName("SF2")
    cSQL += CRLF + "SET F2_YNOME = A2_NOME "
    cSQL += CRLF + "FROM " + RetSQLName("SF2") + " SF2 "
    cSQL += CRLF + "JOIN " + RetSQLName("SA2") + " SA2 ON SA2.D_E_L_E_T_ = '' AND A2_COD = F2_CLIENTE AND A2_LOJA = F2_LOJA"
    cSQL += CRLF + "WHERE SF2.D_E_L_E_T_ = '' "
    cSQL += CRLF + "AND F2_YNOME = '' "
    cSQL += CRLF + "AND F2_TIPO IN ('B','D') "

    TCSQLExec(cSQL)    

Return

//-- Gera o Header do grid de itens do pedido de vendas
Static Function fnHeader

    Local aHeader[0]

	&("SX3->(dbSetOrder(1),dbGoTop(),dbSeek('SC6'))")

	While &("!SX3->(eof())") .and. &("SX3->X3_ARQUIVO == 'SC6'")

		aTam 		:= tamSX3(&("SX3->X3_CAMPO"))

		IF &("x3uso(SX3->X3_USADO)")
			&("aadd(aHeader,{alltrim(SX3->(X3Titulo())),SX3->X3_CAMPO,SX3->X3_PICTURE,aTam[1],aTam[2],'',.T.,SX3->X3_TIPO,'',''})")
		EndIF

		&("SX3->(dbSkip())")

	Enddo  

Return aHeader

//-- Gera o aCols do pedido de vendas
Static Function fnCols()

    Local aCols[0]
    Local aAux      := array(Len(aHeader) + 1)
    Local cCampo    := ''
    Local x 		:= 0
    Local cItem     := '00'
	Local nPesoL	:= 0
	Local nPesoB	:= 0
	Local nTotal	:= 0

	SZ4->(dbSetOrder(1),dbSeek(SZ3->(Z3_FILIAL+Z3_CODIGO)))

	While .not. SZ4->(eof()) .and. SZ4->(Z4_FILIAL+Z4_CODIGO) == SZ3->(Z3_FILIAL+Z3_CODIGO)

		aAux      	:= array(Len(aHeader) + 1)

		nPesoB		+= round(iif(SZ4->Z4_UM == 'KG',SZ4->Z4_PESO,(SZ4->Z4_PESO * 1000)),2)

		IF SZ4->Z4_TIPO == '1'
			SZ4->(dbSkip())
			Loop
		EndIF	

		cItem 		:= soma1(cItem)	

		nPesoL		+= round(iif(SZ4->Z4_UM == 'KG',SZ4->Z4_PESO,(SZ4->Z4_PESO * 1000)),2)
 
        For x := 1 To Len(aHeader)

            cCampo      := alltrim(aHeader[x,2]		)
            aAux[x]     := criavar(aHeader[x,2],.T.	)

			SB1->(dbSetOrder(1),dbSeek(xFilial(alias(),SZ4->Z4_FILIAL)+SZ4->Z4_PRODUTO			))
			SF4->(dbSetOrder(1),dbSeek(xFilial(alias(),SZ4->Z4_FILIAL)+SZ4->Z4_TES				))
			SA1->(dbSetOrder(1),dbSeek(xFilial(alias(),SZ3->Z3_FILIAL)+SZ3->(Z3_CLIENTE+Z3_LOJA)))

            do case
                case cCampo == 'C6_ITEM'
                    aAux[x] 	:= cItem
                case cCampo == 'C6_PRODUTO'
                    aAux[x] 	:= SB1->B1_COD
                case cCampo == 'C6_UM'    
                    aAux[x] 	:= SB1->B1_UM
                case cCampo == 'C6_SEGUM'
                    aAux[x] 	:= SB1->B1_SEGUM    
                case cCampo == 'C6_DESCRI'
                    aAux[x] 	:= SB1->B1_DESC 
                case cCampo == 'C6_CLI'
                    aAux[x] 	:= SA1->A1_COD
                case cCampo == 'C6_LOJA'
                    aAux[x] 	:= SA1->A1_LOJA    
                case cCampo == 'C6_ENTREG'
                    aAux[x] 	:= ddatabase
                case cCampo == 'C6_YPESBAL'
                    aAux[x]     := iif(alltrim(SB1->B1_UM) == 'TL',SZ4->Z4_PESO * 1000,SZ4->Z4_PESO)             
                case cCampo == 'C6_QTDVEN'
                    aAux[x]     := SZ4->Z4_PESO
                case cCampo == 'C6_PRCVEN'
                    aAux[x] 	:= SZ4->Z4_PRECO
                case cCampo == 'C6_VALOR'
					SZ4->(reclock(alias(),.F.), Z4_TOTAL := round(SZ4->(Z4_PESO * Z4_PRECO),2),msunlock())
					aAux[x] 	:= SZ4->Z4_TOTAL
					nTotal		+= SZ4->Z4_TOTAL
                case cCampo == 'C6_TES'
                    aAux[x] 	:= SF4->F4_CODIGO     
                case cCampo == 'C6_LOCAL'
                    aAux[x] 	:= SB1->B1_LOCPAD
                case cCampo == 'C6_CF'
                    aAux[x] 	:= SF4->F4_CF
                case cCampo == 'C6_PRUNIT'
                    aAux[x] 	:= SZ4->Z4_PRECO 
                case cCampo == 'C6_OPER'
                    aAux[x] 	:= '01'                               
            End          

        Next

    	aAux[Len(aHeader) + 1] := .F.
    	aadd(aCols,aAux)

		SZ4->(dbSkip())

	Enddo

    M->C5_PESOL     := nPesoL
    M->C5_PBRUTO    := nPesoB

	SZ3->(		reclock(alias(),.F.), Z3_TOTAL := nTotal,msunlock())
	
	(cArqSZ3)->(dbSetOrder(1),dbSeek(SZ3->(Z3_FILIAL+Z3_CODIGO)))	
	(cArqSZ3)->(reclock(alias(),.F.), Z3_TOTAL := nTotal,msunlock())

Return aCols
