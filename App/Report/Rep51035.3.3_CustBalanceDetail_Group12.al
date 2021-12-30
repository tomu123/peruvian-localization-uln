report 51035 "Cust Balance Detail (Group 12)"
{
    //LIBRO 3.3
    // Identify  Nro.  yyyy.MM.dd  Version   Description
    // -----------------------------------------------------
    // ULN::PC   001   2021.07.05    V.1     Peruvian Books (Copy From MT )
    DefaultLayout = RDLC;
    UsageCategory = Administration;
    ApplicationArea = All;
    RDLCLayout = './App/Report/RDLC/Cust Balance Detail (Group 12).rdl';
    Caption = 'Cust. Balance Detail (Group 12)', Comment = 'ESM="Det. Saldo Cliente (Grupo 12)"';
    ProcessingOnly = false;
    UseSystemPrinter = false;

    dataset
    {
        dataitem(Integer; Integer)
        {
            PrintOnlyIfDetail = false;
            column(CompanyInfo__Nombre_de_Empresa_; CompanyInfo.Name)
            {
            }
            column(rucCompany; CompanyInfo."VAT Registration No.")
            {
            }
            column(Ejercicio; Ejercicio)
            {
            }
            column(TextoPeriodo; MesPeriodo)
            {
            }
            column(UserInfo; UsuarioInfo)
            {
            }
            column(PaginaInfo; PaginaInfo)
            {
            }
            column(InfoFecha; FechaInfo)
            {
            }
            column(G_L_Account_Name; gMaestroDatosTemp."Descripcion Generico")
            {
            }
            column(G_L_Account__No__; gMaestroDatosTemp."Codigo Generico")
            {
            }
            column(SaldoFinal; SaldoFinal)
            {
            }
            column(DENOMINACION_O_RAZON_SOCIAL_Caption; DENOMINACION_O_RAZON_SOCIAL_CaptionLbl)
            {
            }
            column(EJERCICIO_Caption; EJERCICIO_CaptionLbl)
            {
            }
            column(RUCCaption; RUCCaptionLbl)
            {
            }
            column(PERIODO_Caption; PERIODO_CaptionLbl)
            {
            }
            column(LIBRO_DE_INVENTARIOS_Y_BALANCES__DETALLE_DEL_SALDO_DE_LA_CUENTA_12_CUENTAS_POR_COBRAR_COMERCIALES_TERCEROSCaption; LIBRO_DE_INVENTARIOS_Y_BALANCES__DETALLE_DEL_SALDO_DE_LA_CUENTA_12_CUENTAS_POR_COBRAR_COMERCIALES_TERCEROSCaptionLbl)
            {
            }
            column(NUMEROCaption; NUMEROCaptionLbl)
            {
            }
            column(TIPOCaption; TIPOCaptionLbl)
            {
            }
            column(APELLIDOS_Y_NOMBRESCaption; APELLIDOS_Y_NOMBRESCaptionLbl)
            {
            }
            column(DENOMINACION_O_RAZON_SOCIALCaption; DENOMINACION_O_RAZON_SOCIALCaptionLbl)
            {
            }
            column(DOCUMENTO_DE_IDENTIDADCaption; DOCUMENTO_DE_IDENTIDADCaptionLbl)
            {
            }
            column(MONTO_DE_LA_CUENTA_POR_COBRARCaption; MONTO_DE_LA_CUENTA_POR_COBRARCaptionLbl)
            {
            }
            column(FECHA_DE_LA_EMSION_DEL_COMPROBANTE_DE_PAGOCaption; FECHA_DE_LA_EMSION_DEL_COMPROBANTE_DE_PAGOCaptionLbl)
            {
            }
            column(INFORMACION_DEL_CLIENTECaption; INFORMACION_DEL_CLIENTECaptionLbl)
            {
            }
            column(TOTAL_Caption; TOTAL_CaptionLbl)
            {
            }
            column(PrintDate; gPrintDate)
            {
            }
            column(SALDO_FINAL_TOTAL_Caption; SALDO_FINAL_TOTAL_CaptionLbl)
            {
            }
            column(gBoolAgr; tBoolAgr)
            {
            }
            column(FORMAT__Document_Date__; gMaestroDatosTemp."Fecha Envio")
            {
            }
            column(RemainingAmtLCY; gMaestroDatosTemp."Importe Rel")
            {
            }
            column(RemainingAmt; gMaestroDatosTemp."Importe Base")
            {
            }
            column(recGLEntry3__External_Document_No__; recGLEntry3."External Document No.")
            {
            }
            column(Cust__Ledger_Entry__Global_Dimension_1_Code_; gMaestroDatosTemp."Global Dimension 1 Code")
            {
            }
            column(Cust__Ledger_Entry__Global_Dimension_2_Code_; gMaestroDatosTemp."Global Dimension 2 Code")
            {
            }
            column(Cust__Ledger_Entry__Amount__LCY__; gMaestroDatosTemp."Importe Rel")
            {
            }
            column(numDoc; gMaestroDatosTemp."No. Ruc EPS")
            {
            }
            column(tipoDocCliente; gMaestroDatosTemp.Departamento)
            {
            }
            column(NombreCliente; gMaestroDatosTemp.Description)
            {
            }
            column(Cust__Ledger_Entry_Entry_No_; gMaestroDatosTemp.sequence)
            {
            }
            column(Cust__Ledger_Entry_Customer_No_; recGLEntry3."External Document No.")
            {
            }
            column(SALDOTOTAL; SALDOTOTAL)
            {
            }
            column(G_L_Entry__G_L_Account_No__; gMaestroDatosTemp."Codigo Generico")
            {
            }
            column(TOTAL_Caption_Control1000000014; TOTAL_Caption_Control1000000014Lbl)
            {
            }
            column(G_L_Entry_Entry_No_; gMaestroDatosTemp.sequence)
            {
            }
            column(SALDOTOTALFINAL; SALDOTOTALFINAL)
            {
            }
            column(DocumentNo; gMaestroDatosTemp."Document No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                IF Number = 1 THEN
                    gMaestroDatosTemp.FINDFIRST
                ELSE
                    gMaestroDatosTemp.NEXT;
            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.GET;
                rucCompany := CompanyInfo."VAT Registration No.";
                IF FechaIni = 0D THEN ERROR(text001);
                IF FechaFin = 0D THEN ERROR(text002);
                Ejercicio := FORMAT(FechaIni) + '..' + FORMAT(FechaFin);
                gCounter := 1;

                gCustLedgerEntry.RESET;
                gCustLedgerEntry.SETFILTER("Date Filter", '%1..%2', 0D, FechaFin);
                gCustLedgerEntry.SETFILTER("Remaining Amt. (LCY)", '<>%1', 0);
                gCustLedgerEntry.SETFILTER("Receivables Account", '%1|%2', '12*', '13*');
                IF gCustLedgerEntry.FINDSET THEN
                    REPEAT
                        gCustLedgerEntry.CALCFIELDS("Remaining Amt. (LCY)", "Remaining Amount");
                        gGLAccount.GET(gCustLedgerEntry."Receivables Account");
                        gCounter += 1;

                        gMaestroDatosTemp.INIT;
                        gMaestroDatosTemp."No. Mov." := gCounter;
                        gMaestroDatosTemp."Codigo Nav" := gCustLedgerEntry."Customer No.";
                        gMaestroDatosTemp."Descripcion Generico" := gGLAccount.Name;
                        gMaestroDatosTemp."Codigo Generico" := gCustLedgerEntry."Receivables Account";
                        ;
                        IF gCustLedgerEntry."Currency Code" = '' THEN
                            gMaestroDatosTemp."Cod. Pais" := 'S/'
                        ELSE
                            gMaestroDatosTemp."Cod. Pais" := 'USD';

                        gCustomer.RESET;
                        gCustomer.SETRANGE("No.", gCustLedgerEntry."Customer No.");
                        IF gCustomer.FINDSET THEN BEGIN
                            gMaestroDatosTemp.Description := gCustomer.Name;
                            gMaestroDatosTemp.Departamento := gCustomer."VAT Registration Type";
                            gMaestroDatosTemp."No. Ruc EPS" := gCustomer."VAT Registration No.";
                        END;

                        IF COPYSTR(gCustLedgerEntry."Document No.", 1, 3) = 'MIG' THEN
                            gMaestroDatosTemp."Document No." := COPYSTR(gCustLedgerEntry."External Document No.", 1, 20)
                        ELSE
                            gMaestroDatosTemp."Document No." := gCustLedgerEntry."Document No.";

                        gMaestroDatosTemp."Fecha Envio" := gCustLedgerEntry."Document Date";
                        gMaestroDatosTemp."Global Dimension 1 Code" := gCustLedgerEntry."Global Dimension 1 Code";
                        gMaestroDatosTemp."Global Dimension 2 Code" := gCustLedgerEntry."Global Dimension 2 Code";
                        gMaestroDatosTemp.sequence := gCustLedgerEntry."Entry No.";
                        IF gCustLedgerEntry."Currency Code" <> '' THEN
                            gMaestroDatosTemp."Importe Base" := gCustLedgerEntry."Remaining Amount";

                        gMaestroDatosTemp."Importe Rel" := gCustLedgerEntry."Remaining Amt. (LCY)";//

                        gMaestroDatosTemp."Gran Familia" := gCustLedgerEntry."External Document No.";
                        gMaestroDatosTemp.INSERT;
                    UNTIL gCustLedgerEntry.NEXT = 0;


                gVendorLedgerEntry.RESET;
                gVendorLedgerEntry.SETFILTER("Date Filter", '%1..%2', 0D, FechaFin);
                gVendorLedgerEntry.SETFILTER("Remaining Amt. (LCY)", '<>%1', 0);
                gVendorLedgerEntry.SETFILTER("Payables Account", '%1|%2', '12*', '13*');
                IF gVendorLedgerEntry.FINDSET THEN
                    REPEAT
                        gVendorLedgerEntry.CALCFIELDS("Remaining Amt. (LCY)", "Remaining Amount");
                        gGLAccount.GET(gVendorLedgerEntry."Payables Account");
                        gCounter += 1;
                        gMaestroDatosTemp.INIT;
                        gMaestroDatosTemp."No. Mov." := gCounter;
                        gMaestroDatosTemp."Codigo Nav" := gVendorLedgerEntry."Vendor No.";
                        gMaestroDatosTemp."Descripcion Generico" := gGLAccount.Name;
                        gMaestroDatosTemp."Codigo Generico" := gVendorLedgerEntry."Payables Account";
                        IF gVendorLedgerEntry."Currency Code" = '' THEN
                            gMaestroDatosTemp."Cod. Pais" := 'S/'
                        ELSE
                            gMaestroDatosTemp."Cod. Pais" := 'USD';

                        gVendor.RESET;
                        gVendor.SETRANGE("No.", gVendorLedgerEntry."Vendor No.");
                        IF gVendor.FINDSET THEN BEGIN
                            gMaestroDatosTemp.Description := gVendor.Name;
                            gMaestroDatosTemp.Departamento := gVendor."VAT Registration Type";
                            gMaestroDatosTemp."No. Ruc EPS" := gVendor."VAT Registration No.";
                        END;

                        gMaestroDatosTemp."Global Dimension 1 Code" := gVendorLedgerEntry."Global Dimension 1 Code";
                        gMaestroDatosTemp."Global Dimension 2 Code" := gVendorLedgerEntry."Global Dimension 2 Code";

                        IF COPYSTR(gVendorLedgerEntry."Document No.", 1, 3) = 'MIG' THEN
                            gMaestroDatosTemp."Document No." := COPYSTR(gVendorLedgerEntry."External Document No.", 1, 20)
                        ELSE
                            gMaestroDatosTemp."Document No." := gVendorLedgerEntry."Document No.";

                        gMaestroDatosTemp."Fecha Envio" := gVendorLedgerEntry."Document Date";
                        gMaestroDatosTemp.sequence := gVendorLedgerEntry."Entry No.";

                        IF gVendorLedgerEntry."Currency Code" <> '' THEN
                            gMaestroDatosTemp."Importe Base" := gVendorLedgerEntry."Remaining Amount";

                        gMaestroDatosTemp."Importe Rel" := gVendorLedgerEntry."Remaining Amt. (LCY)"; //
                        gMaestroDatosTemp."Gran Familia" := gVendorLedgerEntry."External Document No.";
                        gMaestroDatosTemp.INSERT;
                    UNTIL gVendorLedgerEntry.NEXT = 0;

                Integer.SETRANGE(Number, 1, gMaestroDatosTemp.COUNT);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(chkanio; mosfr)
                {
                    Caption = 'Año Referencia', Comment = 'ESM="Año Referencia"';

                    trigger OnValidate()
                    begin

                        IF mosfr = TRUE THEN BEGIN
                            mescab := DATE2DMY(TODAY, 3);
                        END
                        ELSE BEGIN
                            mescab := 0;
                        END;
                    end;
                }
                field(ARef; mescab)
                {
                }
                field(TxtPeriodo; verperiodo)
                {
                    Caption = 'Rango de Fecha', Comment = 'ESM="Rango de Fecha"';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookUpPeriodo();
                    end;
                }
                field(TxtFecIni; FechaIni)
                {
                    Caption = 'Fecha Inicio', Comment = 'ESM="Fecha Inicio"';
                }
                field(TxtFecFin; FechaFin)
                {
                    Caption = 'Fecha Fin', Comment = 'ESM="Fecha Fin"';
                }
                field(TxtMesPer; MesPeriodo)
                {
                    Caption = 'Periodo', Comment = 'ESM="Periodo"';
                }
                field(TxtFecImp; FechaImpresion)
                {
                    Caption = 'Fecha Impresión', Comment = 'ESM="Fecha Impresión"';
                }
                field(gPrintDate; gPrintDate)
                {
                    Caption = 'Fecha Impresión', Comment = 'ESM="Fecha Impresión"';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
    end;

    var
        SALDOTOTAL: Decimal;
        Ejercicio: Text[30];
        FechaIni: Date;
        FechaFin: Date;
        NombreCliente: Text[100];
        recCustomer: Record Customer;
        text001: Label 'Ingrese la Fecha de Inicio del Periodo';
        CompanyInfo: Record "Company Information";
        rucCompany: Text[30];
        FechaPeriodo: Date;
        mes: Integer;
        tipodocEmp: Option;
        NombreCompany: Text[500];
        tipoDocCliente: Text[30];
        numDoc: Code[20];
        text002: Label '<Ingrese la Fecha Fin del Periodo>';
        MesPeriodo: Text[30];
        MostrarInfo: Boolean;
        FechaInfo: Text[30];
        PaginaInfo: Text[30];
        UsuarioInfo: Text[30];
        recConfigSunat: Record "Legal Document";
        SALDOTOTALFINAL: Decimal;
        recGLAccount: Record "G/L Account";
        fechaantes: Date;
        SaldoFinal: Decimal;
        bolSection: Boolean;
        recDetailLedgerEntry: Record "Detailed Cust. Ledg. Entry";
        RemainingAmtLCY: Decimal;
        RemainingAmtLCYCALC: Decimal;
        FechaImpresion: Date;
        longitud: Integer;
        recGLEntry2: Record "G/L Entry";
        recCustLedgerEntry2: Record "Cust. Ledger Entry";
        recDetailedCustLedgEntry2: Record "Detailed Cust. Ledg. Entry";
        monto2: Decimal;
        RemainingAmtLCY2: Decimal;
        recGLEntry3: Record "G/L Entry";
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        verperiodo: Text[100];
        mescab: Integer;
        mosfr: Boolean;
        fini: Date;
        ffin: Date;
        ExcelBuf: Record "Excel Buffer" temporary;
        PrintToExcel: Boolean;
        Text005: Label 'Company Name';
        Text006: Label 'Report No.';
        Text007: Label 'Report Name';
        Text008: Label 'User ID';
        Text009: Label 'Date';
        Text010: Label 'G/L Filter';
        Text011: Label 'Period Filter';
        Text012: Label 'Det. Saldo Cliente';
        Text013: Label 'Data';
        ChkTipo: Boolean;
        TextoPeriodo: Text[80];
        bExportarTxt: Boolean;
        intfila: Integer;
        Periodo: Text[12];
        LIBRO_DE_INVENTARIOS_Y_BALANCES__DETALLE_DEL_SALDO_DE_LA_CUENTA_12_CUENTAS_POR_COBRAR_COMERCIALES_TERCEROSCaptionLbl: Label 'LIBRO DE INVENTARIOS Y BALANCES -DETALLE DEL SALDO DE LA CUENTA 12-CUENTAS POR COBRAR COMERCIALES-TERCEROS';
        DENOMINACION_O_RAZON_SOCIAL_CaptionLbl: Label 'DENOMINACION O RAZON SOCIAL:';
        EJERCICIO_CaptionLbl: Label 'EJERCICIO:';
        RUCCaptionLbl: Label 'RUC';
        PERIODO_CaptionLbl: Label 'PERIODO:';
        NUMEROCaptionLbl: Label 'NUMERO';
        TIPOCaptionLbl: Label 'TIPO';
        APELLIDOS_Y_NOMBRESCaptionLbl: Label 'APELLIDOS Y NOMBRES';
        DENOMINACION_O_RAZON_SOCIALCaptionLbl: Label 'DENOMINACION O RAZON SOCIAL';
        DOCUMENTO_DE_IDENTIDADCaptionLbl: Label 'DOCUMENTO DE IDENTIDAD';
        MONTO_DE_LA_CUENTA_POR_COBRARCaptionLbl: Label 'MONTO DE LA CUENTA POR COBRAR';
        FECHA_DE_LA_EMSION_DEL_COMPROBANTE_DE_PAGOCaptionLbl: Label 'FECHA DE LA EMSION DEL COMPROBANTE DE PAGO';
        INFORMACION_DEL_CLIENTECaptionLbl: Label 'INFORMACION DEL CLIENTE';
        TOTAL_CaptionLbl: Label ' TOTAL:';
        SALDO_FINAL_TOTAL_CaptionLbl: Label 'SALDO FINAL TOTAL:';
        TOTAL_Caption_Control1000000014Lbl: Label ' TOTAL MOV:';
        gBoolAgr: Boolean;
        tBoolAgr: Text;
        RemainingAmt: Decimal;
        gPrintDate: Date;
        gVendorLedgerEntry: Record "Vendor Ledger Entry";
        gCustLedgerEntry: Record "Cust. Ledger Entry";
        gMaestroDatosTemp: Record "Master Data Buffer" temporary;
        gCounter: Integer;
        gGLAccount: Record "G/L Account";
        gCustomer: Record Customer;
        gVendor: Record Vendor;

    procedure LookUpPeriodo()
    var
        recAccountingPeriod: Record "Accounting Period";
    begin
        fini := DMY2DATE(1, 1, DATE2DMY(WORKDATE, 3));
        ffin := DMY2DATE(31, 12, DATE2DMY(WORKDATE, 3));
        IF mosfr = TRUE THEN BEGIN
            fini := DMY2DATE(1, 1, mescab);
            ffin := DMY2DATE(31, 12, mescab);
        END;
        recAccountingPeriod.SETFILTER(recAccountingPeriod."Starting Date", '>=%1&<=%2', fini, ffin);
        IF PAGE.RUNMODAL(PAGE::"Accounting Periods", recAccountingPeriod) = ACTION::LookupOK THEN
            verperiodo := '';
        FechaIni := 0D;
        FechaFin := 0D;
        MesPeriodo := '';
        verperiodo := recAccountingPeriod.Name;
        FechaIni := recAccountingPeriod."Starting Date";
        FechaFin := CALCDATE('<+CM>', recAccountingPeriod."Starting Date");
        MesPeriodo := FORMAT(DATE2DMY(recAccountingPeriod."Starting Date", 3));
    end;

    procedure Fn_CambiarEstado()
    begin
        IF ChkTipo = TRUE THEN BEGIN
            mescab := 0;
            verperiodo := '';
            MesPeriodo := '';
            mosfr := FALSE;
        END
        ELSE BEGIN
            FechaIni := 0D;
            FechaFin := 0D;
        END;
    end;
}

