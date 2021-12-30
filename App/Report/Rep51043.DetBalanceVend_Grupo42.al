report 51043 "Det.Balance Vend.(Grupo 42)"
{
    //LIBRO 3.12

    // Identify  Nro.  yyyy.MM.dd  Version   Description
    // -----------------------------------------------------
    // ULN::CCL  001   2018.01.31  v.001     LPE
    DefaultLayout = RDLC;
    RDLCLayout = './App/Report/RDLC/Det.Balance Vend.(Grupo 42).rdl';
    Caption = 'Det.Balance Vend.(Grupo 42)', Comment = 'ESM="Det.Saldo Prov.(Grupo 42)"';
    ProcessingOnly = false;
    UseSystemPrinter = false;

    dataset
    {
        dataitem(Integer; Integer)
        {
            column(PaginaInfo; PaginaInfo)
            {
            }
            column(InfoFecha; FechaInfo)
            {
            }
            column(UserInfo; UsuarioInfo)
            {
            }
            column(MesPeriodo; MesPeriodo)
            {
            }
            column(rucCompany; rucCompany)
            {
            }
            column(Ejercicio; Ejercicio)
            {
            }
            column(CompanyInfo_Name; CompanyInfo.Name)
            {
            }
            column(G_L_Account__No__; gMaestroDatosTemp."Codigo Generico")
            {
            }
            column(G_L_Account_Name; gMaestroDatosTemp."Descripcion Generico")
            {
            }
            column(SALDOTOTALFINAL_SaldoFinal; SALDOTOTALFINAL + SaldoFinal)
            {
            }
            column(FORMATO_3_12_LIBRO_DE_INVENTARIOS_Y_BALANCES___DETALLE_DEL_SALDO_DE_LA_CUENTA_42___PROVEEDORESCaption; FORMATO_3_12_LIBRO_DE_INVENTARIOS_Y_BALANCES___DETALLE_DEL_SALDO_DE_LA_CUENTA_42___PROVEEDORESCaptionLbl)
            {
            }
            column(DENOMINACION_O_RAZON_SOCIAL_Caption; DENOMINACION_O_RAZON_SOCIAL_CaptionLbl)
            {
            }
            column(EJERCICIO_Caption; EJERCICIO_CaptionLbl)
            {
            }
            column(RUC_Caption; RUC_CaptionLbl)
            {
            }
            column(PERIODO_Caption; PERIODO_CaptionLbl)
            {
            }
            column(MONTO_DE_LA_CUENTA_POR_PAGARCaption; MONTO_DE_LA_CUENTA_POR_PAGARCaptionLbl)
            {
            }
            column(APELLIDOS_Y_NOMBRESCaption; APELLIDOS_Y_NOMBRESCaptionLbl)
            {
            }
            column(INFORMACION_DEL_PROVEEDORCaption; INFORMACION_DEL_PROVEEDORCaptionLbl)
            {
            }
            column(DENOMINACION_O_RAZON_SOCIALCaption; DENOMINACION_O_RAZON_SOCIALCaptionLbl)
            {
            }
            column(DOCUMENTO_DE_IDENTIDADCaption; DOCUMENTO_DE_IDENTIDADCaptionLbl)
            {
            }
            column(NUMEROCaption; NUMEROCaptionLbl)
            {
            }
            column(TIPOCaption; TIPOCaptionLbl)
            {
            }
            column(N__DOCUMENTOCaption; N__DOCUMENTOCaptionLbl)
            {
            }
            column(FECHA_DE_LA_EMSIONCaption; FECHA_DE_LA_EMSIONCaptionLbl)
            {
            }
            column(SALDO_FINAL_TOTAL_Caption; SALDO_FINAL_TOTAL_CaptionLbl)
            {
            }
            column(gBool; GbOOL)
            {
            }
            column(G_L_Entry__G_L_Account_No__; gMaestroDatosTemp."Codigo Generico")
            {
            }
            column(SALDOTOTAL; SALDOTOTAL)
            {
            }
            column(TOTAL_Caption; TOTAL_CaptionLbl)
            {
            }
            column(G_L_Entry_Entry_No_; gMaestroDatosTemp.sequence)
            {
            }
            column(tipodocProv; gMaestroDatosTemp.Departamento)
            {
            }
            column(NombreProv; gMaestroDatosTemp.Description)
            {
            }
            column(RemainingAmtLCY; gMaestroDatosTemp."Importe Rel")
            {
            }
            column(FORMAT__Document_Date__; gMaestroDatosTemp."Fecha Envio")
            {
            }
            column(Vendor_Ledger_Entry__Vendor_No__; gMaestroDatosTemp."Codigo Nav")
            {
            }
            column(Vendor_Ledger_Entry__External_Document_No__; gMaestroDatosTemp."Gran Familia")
            {
            }
            column(Vendor_Ledger_Entry_Entry_No_; gMaestroDatosTemp.sequence)
            {
            }
            column(numDoc; gMaestroDatosTemp."No. Ruc EPS")
            {
            }
            column(RemainingAmt; gMaestroDatosTemp."Importe Base")
            {
            }
            column(DocumentoNo; gMaestroDatosTemp."Document No.")
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
                Ejercicio := FORMAT(FechaIni) + '..' + FORMAT(FechaFin);
                IF FechaIni = 0D THEN ERROR(text001);
                IF FechaFin = 0D THEN ERROR(text002);
                SALDOTOTALFINAL := 0;

                TBOOL := '1';

                gCounter := 1;
                gCustLedgerEntry.RESET;
                gCustLedgerEntry.SETFILTER("Date Filter", '%1..%2', 0D, FechaFin);
                gCustLedgerEntry.SETFILTER("Remaining Amt. (LCY)", '<>%1', 0);
                gCustLedgerEntry.SETFILTER("Receivables Account", '%1|%2', '42*', '43*');
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
                        IF gCustLedgerEntry."External Document No." <> '' THEN
                            gMaestroDatosTemp."Document No." := COPYSTR(gCustLedgerEntry."External Document No.", 1, 20)
                        ELSE
                            gMaestroDatosTemp."Document No." := gCustLedgerEntry."Document No.";
                        gMaestroDatosTemp."Fecha Envio" := gCustLedgerEntry."Document Date";
                        gMaestroDatosTemp."Global Dimension 1 Code" := gCustLedgerEntry."Global Dimension 1 Code";
                        gMaestroDatosTemp."Global Dimension 2 Code" := gCustLedgerEntry."Global Dimension 2 Code";
                        gMaestroDatosTemp.sequence := gCustLedgerEntry."Entry No.";
                        IF gCustLedgerEntry."Currency Code" <> '' THEN
                            gMaestroDatosTemp."Importe Base" := gCustLedgerEntry."Remaining Amount";
                        gMaestroDatosTemp."Importe Rel" := gCustLedgerEntry."Remaining Amt. (LCY)" * -1;
                        gMaestroDatosTemp."Gran Familia" := gCustLedgerEntry."External Document No.";
                        gMaestroDatosTemp.INSERT;
                    UNTIL gCustLedgerEntry.NEXT = 0;

                gVendorLedgerEntry.RESET;
                gVendorLedgerEntry.SETFILTER("Date Filter", '%1..%2', 0D, FechaFin);
                gVendorLedgerEntry.SETFILTER("Remaining Amt. (LCY)", '<>%1', 0);
                gVendorLedgerEntry.SETFILTER("Payables Account", '%1|%2', '42*', '43*');
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
                        IF gVendorLedgerEntry."External Document No." <> '' THEN
                            gMaestroDatosTemp."Document No." := COPYSTR(gVendorLedgerEntry."External Document No.", 1, 20)
                        ELSE
                            gMaestroDatosTemp."Document No." := gVendorLedgerEntry."Document No.";
                        gMaestroDatosTemp."Fecha Envio" := gVendorLedgerEntry."Document Date";
                        gMaestroDatosTemp.sequence := gVendorLedgerEntry."Entry No.";
                        IF gVendorLedgerEntry."Currency Code" <> '' THEN
                            gMaestroDatosTemp."Importe Base" := gVendorLedgerEntry."Remaining Amount";
                        gMaestroDatosTemp."Importe Rel" := gVendorLedgerEntry."Remaining Amt. (LCY)" * -1;
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
                field(mosfr; mosfr)
                {
                    Caption = 'Año Referencial', Comment = 'ESM="Año Referencial"';

                    trigger OnValidate()
                    begin

                        IF mosfr = TRUE THEN BEGIN
                            mescab := DATE2DMY(TODAY, 3)
                        END ELSE BEGIN
                            mescab := 0;
                        END;
                    end;
                }
                field(mescab; mescab)
                {
                    Caption = 'Aõo', Comment = 'ESM="Aõo"';
                }
                field(verperiodo; verperiodo)
                {
                    Caption = 'Fecha Referencial', Comment = 'ESM="Fecha Referencial"';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookUpPeriodo();
                    end;
                }
                field(FechaIni; FechaIni)
                {
                    Caption = 'Fecha Inicio', Comment = 'ESM="Fecha Inicio"';
                }
                field(FechaFin; FechaFin)
                {
                    Caption = 'Fecha Fin', Comment = 'ESM="Fecha Fin"';
                }
                field(MesPeriodo; MesPeriodo)
                {
                    Caption = 'Periodo', Comment = 'ESM="Periodo"';
                }
                field(GbOOL; GbOOL)
                {
                    Caption = 'Consolidado', Comment = 'ESM="Consolidado"';
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
        NombreCompany: Text[50];
        tipoDocCliente: Text[30];
        numDoc: Code[20];
        text002: Label '<Ingrese la Fecha Fin del Periodo>';
        MesPeriodo: Text[30];
        MostrarInfo: Boolean;
        FechaInfo: Text[30];
        PaginaInfo: Text[30];
        UsuarioInfo: Text[30];
        recConfigSunat: Record "Master Data";
        SALDOTOTALFINAL: Decimal;
        recGLAccount: Record "G/L Account";
        fechaantes: Date;
        SaldoFinal: Decimal;
        bolSection: Boolean;
        recVendor: Record Vendor;
        NombreProv: Text[50];
        tipodocProv: Text[30];
        recDetailLedgerEntry: Record "Detailed Vendor Ledg. Entry";
        RemainingAmtLCY: Decimal;
        RemainingAmtLCYCALC: Decimal;
        FechaImpresion: Date;
        verperiodo: Text[100];
        mescab: Integer;
        mosfr: Boolean;
        recGlEntry: Record "G/L Entry";
        Monto: Decimal;
        DocumentoAnterior: Text[30];
        DocumentoNuevo: Text[30];
        ExcelBuf: Record "Excel Buffer" temporary;
        PrintToExcel: Boolean;
        Text0001: Label 'Trial Balance';
        Text0002: Label 'Data';
        Text0003: Label 'Debit';
        Text004: Label 'Credit';
        Text005: Label 'Company Name';
        Text006: Label 'Report No.';
        Text007: Label 'Report Name';
        Text008: Label 'User ID';
        Text009: Label 'Date';
        Text010: Label 'G/L Filter';
        Text011: Label 'Period Filter';
        FORMATO_3_12_LIBRO_DE_INVENTARIOS_Y_BALANCES___DETALLE_DEL_SALDO_DE_LA_CUENTA_42___PROVEEDORESCaptionLbl: Label 'FORMATO 3.12.LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL SALDO DE LA CUENTA 42 - PROVEEDORES';
        DENOMINACION_O_RAZON_SOCIAL_CaptionLbl: Label 'DENOMINACION O RAZON SOCIAL:';
        EJERCICIO_CaptionLbl: Label 'EJERCICIO:';
        RUC_CaptionLbl: Label 'RUC:';
        PERIODO_CaptionLbl: Label 'PERIODO:';
        MONTO_DE_LA_CUENTA_POR_PAGARCaptionLbl: Label 'MONTO DE LA CUENTA POR PAGAR';
        APELLIDOS_Y_NOMBRESCaptionLbl: Label 'APELLIDOS Y NOMBRES';
        INFORMACION_DEL_PROVEEDORCaptionLbl: Label ' INFORMACION DEL PROVEEDOR';
        DENOMINACION_O_RAZON_SOCIALCaptionLbl: Label 'DENOMINACION O RAZON SOCIAL';
        DOCUMENTO_DE_IDENTIDADCaptionLbl: Label 'DOCUMENTO DE IDENTIDAD';
        NUMEROCaptionLbl: Label 'NUMERO';
        TIPOCaptionLbl: Label 'TIPO';
        N__DOCUMENTOCaptionLbl: Label 'N° DOCUMENTO';
        FECHA_DE_LA_EMSIONCaptionLbl: Label 'FECHA DE LA EMSION';
        SALDO_FINAL_TOTAL_CaptionLbl: Label 'SALDO FINAL TOTAL:';
        TOTAL_CaptionLbl: Label ' TOTAL MOV:';
        gGLEntry: Record "G/L Entry";
        gGLACCnoTry: Text;
        GbOOL: Boolean;
        TBOOL: Text;
        RemainingAmt: Decimal;
        gMaestroDatosTemp: Record "Master Data Buffer" temporary;
        gVendor: Record Vendor;
        gCustomer: Record Customer;
        gVendorLedgerEntry: Record "Vendor Ledger Entry";
        gCustLedgerEntry: Record "Cust. Ledger Entry";
        gCounter: Integer;
        gGLAccount: Record "G/L Account";

    procedure LookUpPeriodo()
    var
        recAccountingPeriod: Record "Accounting Period";
        fini: Date;
        ffin: Date;
    begin
        fini := DMY2DATE(1, 1, DATE2DMY(WORKDATE, 3));
        ffin := DMY2DATE(31, 12, DATE2DMY(WORKDATE, 3));
        IF mosfr = TRUE THEN BEGIN
            fini := DMY2DATE(1, 1, mescab);
            ffin := DMY2DATE(31, 12, mescab);
        END;
        recAccountingPeriod.SETFILTER(recAccountingPeriod."Starting Date", '>=%1&<=%2', fini, ffin);


        IF PAGE.RUNMODAL(100, recAccountingPeriod) = ACTION::LookupOK THEN BEGIN
            verperiodo := '';
            FechaIni := 0D;
            FechaFin := 0D;
            MesPeriodo := '';
            verperiodo := recAccountingPeriod.Name;
            FechaIni := recAccountingPeriod."Starting Date";
            FechaFin := CALCDATE('<+CM>', recAccountingPeriod."Starting Date");
            MesPeriodo := FORMAT(DATE2DMY(recAccountingPeriod."Starting Date", 3));
        END;
    end;

    procedure FunctionFechaFin(fechaing: Date): Text[30]
    var
        calmes: Integer;
        "calaño": Integer;
        refmes: Integer;
    begin
    end;
}

