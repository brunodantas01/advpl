#INCLUDE "fileio.ch"
#INCLUDE "protheus.ch"
#INCLUDE "folder.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "topconn.ch"

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Metodo    �RHIMP01     �Autor  �Rafael Luis da Silva� Data � 22/02/2010 ���
��������������������������������������������������������������������������͹��
���Desc.     �Funcao responsavel em inicializar variaveis utilizadas pelo  ���
���          |sistema e chamar a tela de importacao/exportacao.            ���
��������������������������������������������������������������������������͹��
���Uso       �Integracao do Modulo de RH dos Sistemas Logix X Protheus.    ���
��������������������������������������������������������������������������͹��
���Parametros�                                                             ���
��������������������������������������������������������������������������͹��
���Retorno   �                                                             ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
Main Function  RHIMP01()
Private cTargetDir := ""
Private cTargetExp := ""
Private cFile      := ""
Private aEmpres    := {}
Private aVerba     := {}
Private aInconsistencia := {}

//--ABERTURA DO SIGAMAT
OpenSm0()
DbGoTop()

U_RIM01Tela()

Return

/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������ͻ��
���Metodo    �RIM01RetData   �Autor  �Rafael Luis da Silva� Data � 22/02/2010 ���
�����������������������������������������������������������������������������͹��
���Desc.     �Responsavel em retornar a data atual formatada para renomear 	  ���
���          �o arquivo importado.			                               	  ���
�����������������������������������������������������������������������������͹��
���Uso       �Integracao do Modulo de RH dos Sistemas Logix X Protheus     	  ���
�����������������������������������������������������������������������������͹��
���Parametros�														       	  ���
�����������������������������������������������������������������������������͹��
���Retorno   �Data Formatada                                               	  ���
�����������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/
Function RIM01RetData()
Local dData
Local cDia := ""
Local cMes := ""
Local cAno := ""

dData := Date()
cDia  := StrZero(Day(dData), 2)
cMes  := StrZero(Month(dData), 2)
cAno  := LTrim(Str(Year(dData)))

Return cDia + "-" + cMes + "-" + cAno + "_"



/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Metodo    �RIM01Tela    �Autor  �Rafael F. B.        � Data � 27/08/2009 ���
���������������������������������������������������������������������������͹��
���Desc.     �Monta a Tela de Importacao/Exportacao                         ���
���������������������������������������������������������������������������͹��
���Uso       �Integracao do Modulo de RH dos Sistemas Logix X Protheus      ���
���������������������������������������������������������������������������͹��
���Parametros�               			                                   	���
���������������������������������������������������������������������������͹��
���Retorno   �                                                              ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
User Function RIM01Tela()
Local i := 0
Local oDepartamento
Local oFuncao
Local oVerba
Local oTurno
Local oSindicato

Local oFuncionario
Local oDependente
Local oAfastamento
Local oFolpag
Local o13Sal
Local oFerias

Local oFolhaFer
Local oRescisao
Local oFolhaRes
Local oHistSal
Local oTransf
LOCAL oCCusto

Local cSet

Private lDepartamento:= .F.
Private lFuncao      := .F.
Private lVerba       := .F.
Private lTurno       := .F.
Private lSindicato   := .F.

Private lFuncionario := .F.
Private lDependente  := .F.
Private lAfastamento := .F.
Private lFolpag	     := .F.
Private l13Sal	     := .F.

Private lFolhaFer    := .F.
Private lRescisao    := .F.
Private lHistSal     := .F.
Private lTransf      := .F.
Private lCCusto      := .F.

	Private lEvento      := .F.
	Private lRelogio     := .F.
	Private lCracha      := .F.
	PRIVATE lBcHoras     := .F.
Private oMainWnd


cSet := Set(_SET_DATEFORMAT)
Set(_SET_DATEFORMAT, "dd/mm/yyyy")


 aFolder := {'Cad. B�sico/Hist�ricos','Ponto Eletr�nico'}

	Define MSDialog oMainWnd Title "TESTE" From 000,000 To 900, 1200 Pixel
	Define MSDialog oDlg Title "Integra��o Logix X Protheus - Importa��oo dados Folha de Pagamento" From 000,000 To 400, 509 Pixel

	oFolder := TFolder():New(3, 3, aFolder, aFolder, oDlg,,,, .T., .F., 240, 130,)  //COLUNA X LINHA

	For i := 1 To Len(oFolder:aDialogs)
		oFolder:aDialogs[i]:Ofont := oDlg:Ofont
	Next


	*�����������������������������������Ŀ
	*� DEFINICAO DO FOLDER               �
	*�������������������������������������

 // Itens do folder Cad. B�sico/Hist�rico
	//GROUP BOX CENTRAL LINHAXCOLUNA
	@ 10, 10 To 107, 230 Of oFolder:aDialogs[1] Pixel


@ 20, 20 Checkbox oFuncao 		Var lFuncao 		Prompt "Funcao" 			Size 60, 7 Of oFolder:aDialogs[1] Pixel
@ 30, 20 Checkbox oCCusto      	Var lCCusto   		Prompt "Centro de Custo" 	Size 60, 7 Of oFolder:aDialogs[1] Pixel
@ 40, 20 Checkbox oDepartamenTo Var lDepartamento 	Prompt "Departamento" 		Size 60, 7 Of oFolder:aDialogs[1] Pixel
@ 50, 20 Checkbox oFuncionario 	Var lFuncionario 	Prompt "Funcion�rio" 		Size 60, 7 Of oFolder:aDialogs[1] Pixel
@ 60, 20 Checkbox oAfastamento 	Var lAfastamento 	Prompt "Afastamentos" 		Size 60, 7 Of oFolder:aDialogs[1] Pixel
@ 70, 20 Checkbox oFolpag      	Var lFolpag      	Prompt "Folha de Pagamento" Size 60, 7 Of oFolder:aDialogs[1] Pixel
@ 80, 20 Checkbox oFolhaFer    	Var lFolhaFer 		Prompt "F�rias" 			Size 60, 7 Of oFolder:aDialogs[1] Pixel
@ 90, 20 Checkbox oTransf      	Var lTransf   		Prompt "Transfer�ncias" 	Size 60, 7 Of oFolder:aDialogs[1] Pixel

@ 20, 100 Checkbox oSindicato 	Var lSindicato 		Prompt "Sindicato" 			Size 60, 7 Of oFolder:aDialogs[1] Pixel
@ 30, 100 Checkbox oVerba 		Var lVerba 			Prompt "Verba" 				Size 60, 7 Of oFolder:aDialogs[1] Pixel
@ 40, 100 Checkbox oTurno 		Var lTurno 			Prompt "Turno" 				Size 60, 7 Of oFolder:aDialogs[1] Pixel
@ 50, 100 Checkbox oDependente  Var lDependente  	Prompt "Dependente" 		Size 60, 7 Of oFolder:aDialogs[1] Pixel
@ 60, 100 Checkbox oHistSal     Var lHistSal  		Prompt "Hist�rico Salarial" Size 60, 7 Of oFolder:aDialogs[1] Pixel
@ 70, 100 Checkbox oRescisao    Var lRescisao 		Prompt "Rescis�es" 			Size 60, 7 Of oFolder:aDialogs[1] Pixel
@ 80, 100 Checkbox O13Sal       Var l13sal    		Prompt "13� Sal�rio" 		Size 60, 7 Of oFolder:aDialogs[1] Pixel

 // Itens do folder Ponto Eletr�nico
 @ 10, 10 To 107, 230 Of oFolder:aDialogs[2] Pixel
 @ 20, 20 Checkbox oEvento Var lEvento Prompt "Evento" Size 60, 7 Of oFolder:aDialogs[2] Pixel
 @ 30, 20 Checkbox oRelogio Var lRelogio Prompt "Rel�gio" Size 60, 7 Of oFolder:aDialogs[2] Pixel
 @ 40, 20 Checkbox oCracha Var lCracha Prompt "Crach� Provis�rio" Size 60, 7 Of oFolder:aDialogs[2] Pixel
 @ 50, 20 Checkbox oBcHoras Var lBcHoras Prompt "Banco de Horas" Size 60, 7 Of oFolder:aDialogs[2] Pixel

 @ 145, 20 Say "Origem:" Size 25, 20 Of oDlg Pixel
	@ 145, 58 Msget cTargetDir Size 150, 09 Of oDlg Pixel
	Define SButton From 145, 208 Type 14 Enable Of oDlg Action (U_RIM01OpenImp())

	@ 160, 20 Button "Ok" Size 30, 10 Pixel Of oDlg Action (U_RIM01Importar())
	@ 160, 55 Button "Cancela" Size 30, 10 Pixel Of oDlg Action (oDlg:End())



	Activate MSDialog oDlg Centered


	Set(_SET_DATEFORMAT, cSet)
Return

/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������ͻ��
���Metodo    �RIM01OpenFile  �Autor  �Rafael Luis da Silva� Data � 22/02/2010 ���
�����������������������������������������������������������������������������͹��
���Desc.     �Responsavel por definir o tipo de arquivo a ser selecionado 	  ���
���          �e por abrir uma caixa de selecao para procurar o arquivo.    	  ���
�����������������������������������������������������������������������������͹��
���Uso       �Integracao do Modulo de RH dos Sistemas Logix X Protheus     	  ���
�����������������������������������������������������������������������������͹��
���Parametros�               			                                   	  ���
�����������������������������������������������������������������������������͹��
���Retorno   �                                                           	  ���
�����������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/
User Function RIM01OpenImp()
Local cType := ""

cType      := '*.unl'
cTargetDir := cGetFile(cType, "Selecione a pasta contendo os arquivos", , cTargetDir, .T., GETF_NETWORKDRIVE + GETF_LOCALHARD + GETF_LOCALFLOPPY + 128, .F.)

Return

/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������ͻ��
���Metodo    �RIM01Importar  �Autor  �Rafael Luis da Silva� Data � 27/08/2009 ���
�����������������������������������������������������������������������������͹��
���Desc.     �Faz as Devidas Validacoes e Importa os Dados dos Arquivos.   	  ���
�����������������������������������������������������������������������������͹��
���Uso       �Integracao do Modulo de RH dos Sistemas Logix X Protheus     	  ���
�����������������������������������������������������������������������������͹��
���Parametros�               			                                   	  ���
�����������������������������������������������������������������������������͹��
���Retorno   �                                                        		  ���
�����������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/
User Function RIM01Importar()
Local cDesc  := ""
Local nI := 0
Local bMakeLog		:= { || NIL }

Private aLogTitle := {}
//Inicializa o Array de Inconsistencias a ser apresentada no final do processo
aInconsistencia = {}


If MsgYesNo("Confirma a importa��o?")
    If  !lDepartamento  .AND. !lFuncao      .AND. !lVerba       .AND.;
        !lTurno         .AND. !lSindicato   .AND. !lFuncionario	.AND.;
        !lDependente    .AND. !lAfastamento .AND. !lFolpag	    .AND.;
        !l13Sal	        .AND. !lFolhaFer    .AND. !lRescisao    .AND.;
        !lHistSal       .AND. !lTransf      .AND. !lCCusto      .AND.;
        !lEvento        .AND. !lRelogio     .AND. !lCracha      .AND.;
        !lBcHoras
		MsgAlert("Informe a tabela a ser Importada!", "Aviso")
		Return
	EndIf

	If Empty(cTargetDir)
		MsgAlert("Informe a pasta dos arquivo a serem importados!", "Aviso")
		Return
	EndIf

	cFile :=  cTargetDir + "valida_empresas_protheus.unl"

	If U_RIM01ProcImp(cFile, 1)
		If U_RIM01EMP(cFile)
			If lFuncao
				cFile := cTargetDir + "cargo_logix.unl"
				U_RIM01ProcImp(cFile, 2)
			EndIf

			If lCCusto
				cFile := cTargetDir + "ccusto_logix.unl"
				U_RIM01ProcImp(cFile, 3)
			EndIf

			If lDepartamento
				cFile := cTargetDir + "unidade_funcional_logix.unl"
				U_RIM01ProcImp(cFile, 4)
			EndIf

			If lSindicato
				cFile := cTargetDir + "sindicato_logix.unl"
				U_RIM01ProcImp(cFile, 5)
			EndIf

			If lVerba
				cFile := cTargetDir + "evento_logix.unl"
				U_RIM01ProcImp(cFile, 6)
			EndIf

			If lTurno
				cFile := cTargetDir + "escala_logix.unl"
				U_RIM01ProcImp(cFile, 7)
			EndIf

			If lFuncionario
				cFile := cTargetDir + "funcionario_logix.unl"
				U_RIM01ProcImp(cFile, 8)
			EndIf

			If lDependente
				cFile := cTargetDir + "dependente_logix.unl"
				U_RIM01ProcImp(cFile, 9)
			EndIf

			If lAfastamento
				cFile := cTargetDir + "afastamento_logix.unl"
				U_RIM01ProcImp(cFile, 10)
			EndIf

			If lHistSal
				cFile := cTargetDir + "historico_salarial_logix.unl"
				U_RIM01ProcImp(cFile, 11)
			EndIf

			If lFolpag
				cFile := cTargetDir + "folha_pagto_logix.unl"
				U_RIM01ProcImp(cFile, 12)
			EndIf

			If lTransf
				cFile := cTargetDir + "transferencias_logix.unl"
				U_RIM01ProcImp(cFile, 13)
			EndIf

			If lRescisao
				cFile := cTargetDir + "rescisao_logix.unl"
				U_RIM01ProcImp(cFile, 14)
			EndIf

			If lFolhaFer
				cFile := cTargetDir + "ferias_logix.unl"
				U_RIM01ProcImp(cFile, 15)
			EndIf

			If l13Sal
				cFile := cTargetDir + "13_salario_logix.unl"
				U_RIM01ProcImp(cFile, 16)
			EndIf

		      IF lEvento
		      	cFile := cTargetDir + "ocorrencias_logix.unl"
		      	U_RIM01ProcImp(cFile, 17)
		      ENDIF

		      IF lRelogio
		      	cFile := cTargetDir + "relogio_logix.unl"
		      	U_RIM01ProcImp(cFile, 18)
		      ENDIF

		      IF lCracha
		      	cFile := cTargetDir + "cracha_provisorio_logix.unl"
		      	U_RIM01ProcImp(cFile, 19)
		      ENDIF

		      IF lBcHoras
		      	cFile := cTargetDir + "banco_horas_logix.unl"
		      	U_RIM01ProcImp(cFile, 20)
		      ENDIF



			//IMPRIME O RELATORIO DE INCONSISTENCIAS PARA IMPRIMIR O RELATORIO
			If Len(aInconsistencia) > 0
				If !Empty( aInconsistencia )
					__cInternet := NIL
					//Aten��o
					If ( MsgNoYes('Ocorreram Inconsist�ncias durante o Processo de Importa��o. Deseja consultar o LOG ?'   , 'Inconsist�ncias'  ) )
						//"Log de Ocorrencias"
						bMakeLog := { || fMakeLog(  {aInconsistencia} , {'Inconsist�ncias'} , NIL , .T. , "RHIMP01", NIL,"G","L",NIL,.F.) }
						MsAguarde( bMakeLog , 'Inconsist�ncias da Importa��o.' )
					EndIf
				EndIf
			EndIf
		Else
			cDesc := 'As seguintes empresas n�o existem no Protheus!'+Chr(13)
			For nI := 1 To Len(aInconsistencia)
				cDesc := cDesc + aInconsistencia[nI]+Chr(13)
			Next
			Alert(cDesc, "Erro")
		EndIf
	EndIf
EndIf

Return

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Metodo    �U_RIM01Line �Autor  �Rafael F. B.        � Data � 27/08/2009 ���
��������������������������������������������������������������������������͹��
���Desc.     �Faz a contagem de linhas do Arquivo a ser processado         ���
��������������������������������������������������������������������������͹��
���Uso       �Integracao do Modulo de RH dos Sistemas Logix X Protheus     ���
��������������������������������������������������������������������������͹��
���Parametros�cNomeFile - Nome do Arquivo               			       ���
��������������������������������������������������������������������������͹��
���Retorno   �nLines - Quantidade de Linhas do Arquivo                     ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
User Function RIM01Line(cNomeFile)
Local nLines := 0

If File(cNomeFile)
	FT_FUSE(cNomeFile)
	FT_FGOTOP()
	While !FT_FEOF()
		nLines++
		FT_FSKIP()
	EndDo
	FT_FUSE()
EndIf

Return(nLines)

/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������ͻ��
���Metodo    �RIM01ProcImp   �Autor  �Rafael Luis da Silva� Data � 22/02/2010 ���
�����������������������������������������������������������������������������͹��
���Desc.     �Responsavel em Importar os Arquivos.                  		  ���
�����������������������������������������������������������������������������͹��
���Uso       �Integracao do Modulo de RH dos Sistemas Logix X Protheus.  	  ���
�����������������������������������������������������������������������������͹��
���Parametros�fName  - Nome do Arquivo			                   	          ���
���          �nOpcao - IdentIficacao do Aquivo a ser Importado.            	  ���
�����������������������������������������������������������������������������͹��
���Retorno   �                                                             	  ���
�����������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/
User Function RIM01ProcImp(fName, nOpcao)
Local cNovoNome := ""
Local cDescErro := ""

Local nHandle

nHandle := FOpen(fName, 68)

If nHandle == -1
	cDescErro := "Arquivo " + fName + " n�o Localizado na pasta para importa��o "
	//Aadd(aInconsistencia, cDescErro)
	Alert(cDescErro)
	Return .F.
EndIf

//���������������������������������������������������������������������Ŀ
//� Inicializa a regua de processamento                                 �
//�����������������������������������������������������������������������
If nOpcao <> 1
	cNovoNome := cTargetDir + RIM01RetData()
EndIf

Do Case
	Case nOpcao == 2
		Processa({|| U_RHIMP02Funcao(fName)}, "Processando Fun��es...")
		cNovoNome += "cargo_logix.unl"

	Case nOpcao == 3
		Processa({|| U_RHIMP03CCusto(fName)}, "Processando Centro de Custo...")
		cNovoNome += "ccusto_logix.unl"

	Case nOpcao == 4
		Processa({|| U_RHIMP04Depto(fName)}, "Processando Departamentos...")
		cNovoNome += "unidade_funcional_logix.unl"

	Case nOpcao == 5
		Processa({|| U_RHIMP05Sindicato(fName)}, "Processando Sindicatos...")
		cNovoNome += "sindicato_logix.unl"

	Case nOpcao == 6
		Processa({|| U_RHIMP06Verba(fName)}, "Processando Verbas...")
		cNovoNome += "evento_logix.unl"

	Case nOpcao == 7
		Processa({|| U_RHIMP07Turno(fName)}, "Processando Turnos...")
		cNovoNome += "escala_logix.unl"

	Case nOpcao == 8       //necessario colocar o nome da funcao desta forma, pois o protheus identIfica soh as 10 primeiras posicoes
		Processa({|| U_RHIMP08Mat(fName)}, "Processando Funcion�rios...")
		cNovoNome += "funcionario_logix.unl"

	Case nOpcao == 9       //necessario colocar o nome da funcao desta forma, pois o protheus identIfica soh as 10 primeiras posicoes
		Processa({|| U_RHIMP09Dependente(fName)}, "Processando Dependentes...")
		cNovoNome += "dependente_logix.unl"

	Case nOpcao == 10
		Processa({|| U_RHIMP10Afast(fName)}, "Processando Afastamentos...")
		cNovoNome += "afastamento_logix.unl"

	Case nOpcao == 11
		Processa({|| U_RHIMP11(fName)}, "Processando Hist�rico Salarial...")
		cNovoNome += "historico_salarial_logix.unl"

	Case nOpcao == 12
		Processa({|| U_RHIMP12(fName)}, "Processando Folha de Pagamento...")
		cNovoNome += "folha_pagto_logix.unl"

	Case nOpcao == 13
		Processa({|| U_RHIMP13(fName)}, "Processando Transfer�ncias...")
		cNovoNome += "transferencias_logix.unl

	Case nOpcao == 14
		Processa({|| U_RHIMP14(fName)}, "Processando Rescis�es...")
		cNovoNome += "rescisao_logix.unl"

	Case nOpcao == 15
		Processa({|| U_RHIMP15(fName)}, "Processando Folha F�rias...")
		cNovoNome += "ferias_logix.unl"

	Case nOpcao == 16
		Processa({|| U_RHIMP16(fName)}, "Processando 13� Sal�rio...")
		cNovoNome += "13_salario_logix.unl"

     Case nOpcao == 17
   			Processa({|| U_RHIMP17Ocorren(fName)}, "Processando Evento...")
   			cNovoNome += "ocorrencias_logix.unl

   		Case nOpcao == 18
   			Processa({|| U_RHIMP18Relogio(fName)}, "Processando  Rel�gio...")
   			cNovoNome += "relogio_logix.unl

     Case nOpcao == 19
   			Processa({|| U_RHIMP19Cracha(fName)}, "Processando  Crach� Provis�rio...")
   			cNovoNome += "cracha_provisorio_logix.unl

   		Case nOpcao == 20
   			Processa({|| U_RHIMP20BCHoras(fName)}, "Processando  Banco de Horas...")
   			cNovoNome += "banco_horas_logix.unl

   	End Case

	FClose(nHandle)
	FRename(fName, cNovoNome)
RETURN .T.

/*
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������ͻ��
���Metodo    RIM01ERR        �Autor  �Edna Dalfovo        � Data � 06/09/2012  ���
������������������������������������������������������������������������������͹��
���Desc.     �Adiciona mensagens de inconsist�ncias na vari�vel aInconsistencia���
���                                                                            ���
������������������������������������������������������������������������������͹��
���Uso       �Integracao do Modulo de RH dos Sistemas Logix X Protheus.        ���
������������������������������������������������������������������������������͹��
���Parametros�fName  - Nome do Arquivo 						                   ���
������������������������������������������������������������������������������͹��
���Retorno   �                                                                 ���
������������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
*/
User Function RIM01ERR(cDescErro)

 aAdd(aInconsistencia, cDescErro)

RETURN

/*
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������ͻ��
���Metodo    RIM01ERA        �Autor  �Edna Dalfovo        � Data � 01/04/2013  ���
������������������������������������������������������������������������������͹��
���Desc.     �Adiciona mensagens de inconsist�ncias na vari�vel aInconsistencia���
���                                                                            ���
������������������������������������������������������������������������������͹��
���Uso       �Integracao do Modulo de RH dos Sistemas Logix X Protheus.        ���
������������������������������������������������������������������������������͹��
���Parametros�fName  - Nome do Arquivo 						                   ���
������������������������������������������������������������������������������͹��
���Retorno   �                                                                 ���
������������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
*/
User Function RIM01ERA(aDescErro)

Aeval(aDescErro, { |x| Aadd(aInconsistencia, x)  } )

RETURN



/*
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������ͻ��
���Metodo    RIM01EMP        �Autor  �Edna Dalfovo        � Data � 06/09/2012  ���
������������������������������������������������������������������������������͹��
���Desc.     �Valida as empresas do arquivo de valida��o                       ���
���                                                                            ���
������������������������������������������������������������������������������͹��
���Uso       �Integracao do Modulo de RH dos Sistemas Logix X Protheus.        ���
������������������������������������������������������������������������������͹��
���Parametros�fName  - Nome do Arquivo 						                   ���
������������������������������������������������������������������������������͹��
���Retorno   �                                                                 ���
������������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
*/
User Function RIM01EMP(fName)
Local cBuffer       := ""
Local lEmpresaLog   := ""
Local lEmpresaArq   := ""
Local lFilialArq    := ""
Local lEmpOrigem    := "00"
Local lFilialOrigem := "00"
Local lValid        := .T.
PRIVATE aErro       := {}

nCount := U_RIM01Line(fName)

//���������������������������������������������������������������������Ŀ
//� Numero de registros a importar                                      �
//�����������������������������������������������������������������������
ProcRegua(nCount)

FT_FUSE(fName)
FT_FGOTOP()

While !FT_FEOF()
	cBuffer := FT_FREADLN()

	nPosFimFilial := At("|", cBuffer)
	lEmpresaLog      := Substr(cBuffer, 1, nPosFimFilial - 1)


	nPosIni := nPosFimFilial
	cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	nPosFim := At("|", cBuffer)

	lEmpresaArq := Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))

	nPosIni := At("|", cBuffer)
	cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	nPosFim := At("|", cBuffer)

	lFilialArq := Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))

	If lEmpresaArq <> lEmpOrigem .OR. lFilialArq <> lFilialOrigem
		lExiste:= .F.
		dbSelectArea("SM0")
		dbGoTop()

		RpcClearEnv()
		OpenSm0Excl()
		While ! Eof()
			lEmpresa:= SM0->M0_CODIGO
			lFilial := SM0->M0_CODFIL

			If lEmpresa =  lEmpresaArq .AND.  lFilialArq = lFilial
				lExiste = .T.
				SM0->(dbSkip())
				Exit
			EndIf
			SM0->(dbSkip())
		EndDo
		If lExiste == .F.
			lValid := .F.
			cDescErro := " Logix Empresa: "+ AllTrim(lEmpresaLog)+" Protheus Empresa/Filial: " + AllTrim(lEmpresaArq)+"/"+ AllTrim(lFilialArq)
			//U_RIM01ERR(cDescErro)
			aAdd(aErro,cDescErro)
		EndIf
	EndIf
	lEmpOrigem := lEmpresaArq
	lFilialOrigem := lFilialArq

	FT_FSKIP()
	IncProc()
ENDDO
U_RIM01ERA(aErro)

Return lValid



/*
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������ͻ��
���Metodo    |RIM01MVC        �Autor  �Edna Dalfovo        � Data � 06/09/2012 ���
������������������������������������������������������������������������������͹��
���Desc.     �Importacao dos dados						                       ���
������������������������������������������������������������������������������͹��
���Uso       �Integracao do Modulo de RH dos Sistemas Logix X Protheus.        ���
������������������������������������������������������������������������������͹��
���Parametros�						 						                   ���
������������������������������������������������������������������������������͹��
���Retorno   �                                                                 ���
������������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
*/
User Function RIM01MVC( cAlias, aCampos,cModel,cDesc,cChave,cGetModel)

Local oModel, oAux, oStruct
Local nI 		:= 0
Local nPos 		:= 0
Local lRet 		:= .T.
Local aAux 		:= {}
Local cDescErro := ""
Local nTamP 	:= 0
Local nTamE 	:= 0
PRIVATE aErro := {}
dbSelectArea(cAlias)
dbSetOrder(1)

// Aqui ocorre o inst�nciamento do modelo de dados (Model)
// Neste exemplo instanciamos o modelo de dados do fonte COMP011_MVC
// que � a rotina de manuten��o de compositores/interpretes
oModel := FWLoadModel( cModel )
// Temos que definir qual a opera��o deseja: 3 � Inclus�o / 4 � Altera��o / 5 - Exclus�o

If !DbSeek(xFilial(cAlias) + aCampos[2,2])
	oModel:SetOperation( 3 )
Else
   	oModel:SetOperation( 4 )
EndIf

// Antes de atribuirmos os valores dos campos temos que ativar o modelo
oModel:Activate()
// Instanciamos apenas referentes �s dados
oAux := oModel:GetModel(cGetModel)//'GPEA340_RCE')
// Obtemos a estrutura de dados
oStruct := oAux:GetStruct()
aAux := oStruct:GetFields()

For nI := 1 To Len( aCampos )
	If oModel:GetOperation() == 4
 		If aCampos[nI,1] $ IndexKey()
   			Loop
       	EndIf
    EndIf
    // Verifica se os campos passados existem na estrutura do modelo
    If ( nPos := aScan(aAux,{|x| AllTrim( x[3] )== AllTrim(aCampos[nI][1]) } ) ) > 0
    // � feita a atribui��o do dado ao campo do Model
    	If !( lAux := oModel:SetValue (cGetModel, aCampos[nI][1], aCampos[nI][2]) )
     		// Caso a atribui��o n�o possa ser feita, por algum motivo (valida��o, por exemplo)
    		// o m�todo SetValue retorna .F.
            aErro1 := oModel:GetErrorMessage()
            cDescErro := cDesc + '. Erro '+AllToChar( aErro1[6] ) +' campo "'+AllToChar( aErro1[4] )+'" valor "'+AllToChar(aCampos[nI][2])+'".'
            If AllToChar(aErro1[5]) = 'FWNOWIDTH'
               nTamP := TAMSX3(aCampos[nI,1])
               nTamE := LEN(aCampos[nI,2])
               cDescErro := cDescErro + ' Tam. Protheus:' + ALLTRIM(AllToChar(nTamP[1])) + ' Tam. Sist. Ext:'+ ALLTRIM(AllToChar(nTamE)) + '.'
            EndIf
            aAdd(aErro, cDescErro)
            lRet := .F.
            Exit
      	Else
            lRet := .T.
        EndIf
	EndIf
Next nI

//     // A estrutura do vetor com erro �:
//     // [1] identificador (ID) do formul�rio de origem
//     // [2] identificador (ID) do campo de origem
//     // [3] identificador (ID) do formul�rio de erro
//     // [4] identificador (ID) do campo de erro
//     // [5] identificador (ID) do erro
//     // [6] mensagem do erro
//     // [7] mensagem da solu��o
//     // [8] Valor atribu�do
//     // [9] Valor anterior
//     //AutoGrLog( "Id do formul�rio de origem:" + ' [' + AllToChar( aErro[1] ) + ']' )
//     //AutoGrLog( "Id do campo de origem: " + ' [' + AllToChar( aErro[2] ) + ']' )
//     //AutoGrLog( "Id do formul�rio de erro: " + ' [' + AllToChar( aErro[3] ) + ']' )
//     //AutoGrLog( "Id do campo de erro: " + ' [' + AllToChar( aErro[4] ) + ']' )
//     //AutoGrLog( "Id do erro: " + ' [' + AllToChar( aErro[5] ) + ']' )
//     //AutoGrLog( "Mensagem do erro: " + ' [' + AllToChar( aErro[6] ) + ']' )
//     //AutoGrLog( "Mensagem da solu��o: " + ' [' + AllToChar( aErro[7] ) + ']' )
//     //AutoGrLog( "Valor atribu�do: " + ' [' + AllToChar( aErro[9] ) + ']' )
//     //AutoGrLog( "Valor anterior: " + ' [' + AllToChar( aErro[9] ) + ']' )
//     //MostraErro()
If lRet
	If (lRet := oModel:VldData() )
		oModel:CommitData()
	EndIf
EndIf

// Desativamos o Model
oModel:DeActivate()

U_RIM01ERA(aErro)

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MostraErro�Autor  �Valdir/Sandro       � Data �  12/07/00   ���
�������������������������������������������������������������������������͹��
���Desc.     �Mostra erros do processo automatico ********.log na Tela    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function RHMostraErro(cPath,cNome)
Local oDlg
Local cMemo
Local cFile    :=""
Local cMask    := "Arquivos Texto (*.TXT) |*.txt|"
Local oFont
Local cStartPath := GetSrvProfString("Startpath","")
Local nLin := 0
Local nX   := 0

cPath := If(cPath = Nil, "", cPath)
cNome := If(cNome = Nil, __cFileLog, cNome)
cMemo :=MemoRead(cNome)

//If Empty(cPath)


	DEFINE FONT oFont NAME "Courier New" SIZE 5,0   //6,15

	//DEFINE MSDIALOG oDlg TITLE cNome From 3,0 to 550,617 PIXEL//340,417 PIXEL

	//@ 5,5 GET oMemo  VAR cMemo MEMO SIZE 300,245 OF oDlg PIXEL //200,145 OF oDlg PIXEL
	oMemo:bRClicked := {||AllwaysTrue()}
	oMemo:oFont:=oFont

	//DEFINE SBUTTON  FROM 255,275 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
	//DEFINE SBUTTON  FROM 255,245 TYPE 13 ACTION (cFile:=cGetFile(cMask,OemToAnsi("Salvar")),If(cFile="",.t.,MemoWrite(cFile,cMemo)),oDlg:End()) ENABLE OF oDlg PIXEL //Salva e Apaga //"Salvar Como..."
//	DE//FINE SBUTTON  FROM 255,215 TYPE 6 ACTION (PrintAErr(cNome,cMemo),oDlg:End()) ENABLE OF oDlg PIXEL //Imprime e Apaga

//	ACTIVATE MSDIALOG oDlg CENTER
//Else
	//ConOut("STR0046" + cNome)  //"Processo nao concluido. Verificar arquivo "
	//Copy File (cStartPath + "\" + cNome) To (cPath + "\" + cNome)
//EndIf
//Ferase(__cFileLog)
//__cFileLog := Nil
//Return(cMemo)

//Static Function PrintAErr(cFileErro,cConteudo)//Imprime o autoerro.log

//Default cConteudo := ""

	//CursorWait()
	//If IsTelnet() .Or. IsBlind()
	//	While !IsPrinter()
		//	If !MsgRetryCancel(OemToAnsi("Impressora nao esta pronta."),OemToAnsi("Atencao"))
			 //	 Return .T.
			 //Endif
		//ENDDO
		//RptStatus({|lEnd| __CopyFile(cFileErro,"Lpt1")} )
	//Else
		Private aReturn:= {"STR0059", 1,"STR0060", 1, 2, 1, "",1 }

		SetPrint(,cNome,nil ,"STR0061",cNome,'','',.F.,"",.F.,"M")
		If nLastKey <> 27
	   		SetDefault(aReturn,"")
	   		nLinha:= MLCount(oMemo,132)
	        For nX:= 1 To nLinha
				nLin++
				If nLin > 80
					nLin := 1
					@ 00,00 PSAY AvalImp(132)
				Endif
				@ nLin,000 PSAY Memoline(oMemo,132,nX)
	        Next nX
			Set device to Screen
			MS_FLUSH()
		EndIf
//EndIf

Return        