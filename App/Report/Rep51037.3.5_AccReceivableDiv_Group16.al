report 51037 "Acc Receivable. Div (Group 16)"
{
    //LIBRO 3.5
    // Identify  Nro.  yyyy.MM.dd  Version   Description
    // -----------------------------------------------------
    // ULN::PC   001   2021.07.05    V.1     Peruvian Books (Copy From MT )
    DefaultLayout = RDLC;
    RDLCLayout = './App/Report/RDLC/Acc Receivable. Div (Group 16).rdl';
    Caption = 'Acct. Receivable. Div (Group 16)', Comment = 'ESM="Ctas. Por Cobrar .Div.(Grupo 16)"';
    ProcessingOnly = false;
    UseSystemPrinter = false;

    dataset
    {
        dataitem(Integer; Integer)
        {
            column(CompanyInfo_Name; CompanyInfo.Name)
            {
            }
            column(CompanyInfo__VAT_Registration_No__; CompanyInfo."VAT Registration No.")
            {
            }
            column(Ejercicio; Ejercicio)
            {
            }
            column(MesPeriodo; MesPeriodo)
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
            column(G_L_Account__No__; gMaestroDatosTemp."Codigo Generico")
            {
            }
            column(G_L_Account_Name; gMaestroDatosTemp."Descripcion Generico")
            {
            }
            column(SaldoFinalTotal; SaldoFinalTotal)
            {
            }
            column(RUC_Caption; RUC_CaptionLbl)
            {
            }
            column(EJERCICIO_Caption; EJERCICIO_CaptionLbl)
            {
            }
            column(PERIODO_Caption; PERIODO_CaptionLbl)
            {
            }
            column(FORMATO_3_5__LIBRO_DE_INVENTARIOS_Y_BALANCES___DETALLE_DEL_SALDO_DE_LA_CUENTA_16___CUENTAS_POR_COBRAR_DIVERSASCaption; FORMATO_3_5__LIBRO_DE_INVENTARIOS_Y_BALANCES___DETALLE_DEL_SALDO_DE_LA_CUENTA_16___CUENTAS_POR_COBRAR_DIVERSASCaptionLbl)
            {
            }
            column(DENOMINACION_O_RAZON_SOCIAL_Caption; DENOMINACION_O_RAZON_SOCIAL_CaptionLbl)
            {
            }
            column(MONTO_DE_LA_CUENTA_POR_COBRARCaption; MONTO_DE_LA_CUENTA_POR_COBRARCaptionLbl)
            {
            }
            column(FECHA_DE_LA_EMSION_DEL_COMPROBANTE_DE_PAGOCaption; FECHA_DE_LA_EMSION_DEL_COMPROBANTE_DE_PAGOCaptionLbl)
            {
            }
            column(MONTO_DE_LA_CUENTA_POR_COBRARCaption_Control1000000026; MONTO_DE_LA_CUENTA_POR_COBRARCaption_Control1000000026Lbl)
            {
            }
            column(DENOMINACION_O_RAZON_SOCIALCaption; DENOMINACION_O_RAZON_SOCIALCaptionLbl)
            {
            }
            column(NUMEROCaption; NUMEROCaptionLbl)
            {
            }
            column(TIPOCaption; TIPOCaptionLbl)
            {
            }
            column(DOCUMENTO_DE_IDENTIDADCaption; DOCUMENTO_DE_IDENTIDADCaptionLbl)
            {
            }
            column(APELLIDOS_Y_NOMBRESCaption; APELLIDOS_Y_NOMBRESCaptionLbl)
            {
            }
            column(INFORMACION_DE_TERCEROSCaption; INFORMACION_DE_TERCEROSCaptionLbl)
            {
            }
            column(N__DOCUMENTOCaption; N__DOCUMENTOCaptionLbl)
            {
            }
            column(SALDO_FINAL_TOTAL_Caption; SALDO_FINAL_TOTAL_CaptionLbl)
            {
            }
            column(TipoDoc; gMaestroDatosTemp.Departamento)
            {
            }
            column(NombrePersona; gMaestroDatosTemp.Description)
            {
            }
            column(G_L_Entry__G_L_Entry___Posting_Date_; gMaestroDatosTemp."Fecha Envio")
            {
            }
            column(G_L_Entry_Amount; gMaestroDatosTemp."Importe Rel")
            {
            }
            column(G_L_Entry__Source_No__; gMaestroDatosTemp."Codigo Generico")
            {
            }
            column(G_L_Entry__External_Document_No__; gMaestroDatosTemp."Codigo Generico")
            {
            }
            column(SaldoFinal; SaldoFinal)
            {
            }
            column(G_L_Entry__G_L_Account_No__; gMaestroDatosTemp."Codigo Generico")
            {
            }
            column(TOTAL_Caption; TOTAL_CaptionLbl)
            {
            }
            column(G_L_Entry_Entry_No_; gMaestroDatosTemp.sequence)
            {
            }
            column(numdoc; gMaestroDatosTemp."No. Ruc EPS")
            {
            }
            column(MontoPendiente; gMaestroDatosTemp."Importe Rel")
            {
            }
            column(GbOOL; GbOOL)
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
                Ejercicio := FORMAT(FechaIni) + '..' + FORMAT(FechaFin);
                CompanyInfo.GET;
                rucCompany := CompanyInfo."VAT Registration No.";
                IF FechaIni = 0D THEN ERROR(text001);
                IF FechaFin = 0D THEN ERROR(text002);
                Ejercicio := FORMAT(FechaIni) + '..' + FORMAT(FechaFin);
                gCounter := 1;

                gCustLedgerEntry.RESET;
                gCustLedgerEntry.SETFILTER("Date Filter", '%1..%2', 0D, FechaFin);
                gCustLedgerEntry.SETFILTER("Remaining Amt. (LCY)", '<>%1', 0);
                gCustLedgerEntry.SETFILTER("Receivables Account", '%1|%2', '16*', '17*');
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
                        gMaestroDatosTemp."Document No." := gCustLedgerEntry."Document No.";
                        gMaestroDatosTemp."Fecha Envio" := gCustLedgerEntry."Document Date";
                        gMaestroDatosTemp."Global Dimension 1 Code" := gCustLedgerEntry."Global Dimension 1 Code";
                        gMaestroDatosTemp."Global Dimension 2 Code" := gCustLedgerEntry."Global Dimension 2 Code";
                        gMaestroDatosTemp.sequence := gCustLedgerEntry."Entry No.";
                        IF gCustLedgerEntry."Currency Code" <> '' THEN
                            gMaestroDatosTemp."Importe Base" := gCustLedgerEntry."Remaining Amount";
                        gMaestroDatosTemp."Importe Rel" := gCustLedgerEntry."Remaining Amt. (LCY)";
                        gMaestroDatosTemp."Gran Familia" := gCustLedgerEntry."External Document No.";
                        gMaestroDatosTemp.INSERT;
                    UNTIL gCustLedgerEntry.NEXT = 0;

                gVendorLedgerEntry.RESET;
                gVendorLedgerEntry.SETFILTER("Date Filter", '%1..%2', 0D, FechaFin);
                gVendorLedgerEntry.SETFILTER("Remaining Amt. (LCY)", '<>%1', 0);
                gVendorLedgerEntry.SETFILTER("Payables Account", '%1|%2', '16*', '17*');
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
                        gMaestroDatosTemp."Document No." := gVendorLedgerEntry."Document No.";
                        gMaestroDatosTemp."Fecha Envio" := gVendorLedgerEntry."Document Date";
                        gMaestroDatosTemp.sequence := gVendorLedgerEntry."Entry No.";
                        IF gVendorLedgerEntry."Currency Code" <> '' THEN
                            gMaestroDatosTemp."Importe Base" := gVendorLedgerEntry."Remaining Amount";
                        gMaestroDatosTemp."Importe Rel" := gVendorLedgerEntry."Remaining Amt. (LCY)";
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
                    Caption = 'Año Referencial', Comment = 'ESM="Año Referencial"';

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
                field(FechaPeriodo; FechaPeriodo)
                {
                    Caption = 'Fecha de Inicio del Periodo', Comment = 'ESM="Fecha de Inicio del Periodo"';
                    Visible = false;
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
        NombreCompany: Text[30];
        tipoDocCliente: Text[30];
        numDoc: Code[20];
        text002: Label '<Ingrese la Fecha Fin del Periodo>';
        MesPeriodo: Text[30];
        MostrarInfo: Boolean;
        FechaInfo: Text[30];
        PaginaInfo: Text[30];
        UsuarioInfo: Text[30];
        recConfigSunat: Record "Master Data";
        TipoDoc: Text[30];
        NombrePersona: Text[200];
        recCuenta: Record "G/L Account";
        CodPersona: Text[30];
        recMovCliente: Record "Cust. Ledger Entry";
        FechaImpresion: Date;
        verperiodo: Text[100];
        mescab: Integer;
        mosfr: Boolean;
        SaldoFinal: Decimal;
        gResource: Record Resource;
        SaldoFinalTotal: Decimal;
        recDetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry";
        recDetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        recVendor: Record Vendor;
        Monto: Decimal;
        gREC: Integer;
        SaldoIniDeudor: Decimal;
        SaldoIniAcreedor: Decimal;
        SaldoFinAcreedor: Decimal;
        SaldoInicial: Decimal;
        SaldoFinDeudor: Decimal;
        recGlEntry: Record "G/L Entry";
        Saldo: Decimal;
        RUC_CaptionLbl: Label 'RUC:';
        EJERCICIO_CaptionLbl: Label 'EJERCICIO:';
        PERIODO_CaptionLbl: Label 'PERIODO:';
        FORMATO_3_5__LIBRO_DE_INVENTARIOS_Y_BALANCES___DETALLE_DEL_SALDO_DE_LA_CUENTA_16___CUENTAS_POR_COBRAR_DIVERSASCaptionLbl: Label 'FORMATO 3.5. LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL SALDO DE LA CUENTA 16 - CUENTAS POR COBRAR DIVERSAS';
        DENOMINACION_O_RAZON_SOCIAL_CaptionLbl: Label 'DENOMINACION O RAZON SOCIAL:';
        MONTO_DE_LA_CUENTA_POR_COBRARCaptionLbl: Label 'MONTO DE LA CUENTA POR COBRAR';
        FECHA_DE_LA_EMSION_DEL_COMPROBANTE_DE_PAGOCaptionLbl: Label 'FECHA DE LA EMSION DEL COMPROBANTE DE PAGO';
        MONTO_DE_LA_CUENTA_POR_COBRARCaption_Control1000000026Lbl: Label 'MONTO DE LA CUENTA POR COBRAR';
        DENOMINACION_O_RAZON_SOCIALCaptionLbl: Label 'DENOMINACION O RAZON SOCIAL';
        NUMEROCaptionLbl: Label 'NUMERO';
        TIPOCaptionLbl: Label 'TIPO';
        DOCUMENTO_DE_IDENTIDADCaptionLbl: Label 'DOCUMENTO DE IDENTIDAD';
        APELLIDOS_Y_NOMBRESCaptionLbl: Label 'APELLIDOS Y NOMBRES';
        INFORMACION_DE_TERCEROSCaptionLbl: Label 'INFORMACION DE TERCEROS';
        N__DOCUMENTOCaptionLbl: Label 'N° DOCUMENTO';
        SALDO_FINAL_TOTAL_CaptionLbl: Label 'SALDO FINAL TOTAL:';
        TOTAL_CaptionLbl: Label ' TOTAL MOV:';
        gGLEntry: Record "G/L Entry";
        GbOOL: Boolean;
        tBool: Text;
        gCustLedgerEntry: Record "Cust. Ledger Entry";
        _VendorLedgerEntry: Record "Vendor Ledger Entry";
        gCustomer: Record Customer;
        lclRemAmt: Decimal;
        lclRemAmt2: Decimal;
        lclRemAmtTotal: Decimal;
        gMaestroDatosTemp: Record "Master Data Buffer" temporary;
        gCounter: Integer;
        gGLAccount: Record "G/L Account";
        gVendorLedgerEntry: Record "Vendor Ledger Entry";
        gVendor: Record Vendor;

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
        IF PAGE.RUNMODAL(PAGE::"Accounting Periods", recAccountingPeriod) = ACTION::LookupOK THEN
            verperiodo := '';
        FechaIni := 0D;
        FechaFin := 0D;
        MesPeriodo := '';
        verperiodo := recAccountingPeriod.Name;
        FechaIni := recAccountingPeriod."Starting Date";
        EVALUATE(FechaFin, FunctionFechaFin(recAccountingPeriod."Starting Date"));
        MesPeriodo := FORMAT(DATE2DMY(recAccountingPeriod."Starting Date", 3));
    end;

    procedure FunctionFechaFin(fechaing: Date): Text[30]
    var
        calmes: Integer;
        "calaño": Integer;
        refmes: Integer;
    begin
        calmes := DATE2DMY(fechaing, 2);
        calaño := DATE2DMY(fechaing, 3);
        IF calaño MOD 4 = 0 THEN
            refmes := 29
        ELSE
            refmes := 28;
        CASE calmes OF
            1:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calaño));
            2:
                EXIT(FORMAT(refmes) + '/' + FORMAT(calmes) + '/' + FORMAT(calaño));
            3:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calaño));
            4:
                EXIT('30/' + FORMAT(calmes) + '/' + FORMAT(calaño));
            5:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calaño));
            6:
                EXIT('30/' + FORMAT(calmes) + '/' + FORMAT(calaño));
            7:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calaño));
            8:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calaño));
            9:
                EXIT('30/' + FORMAT(calmes) + '/' + FORMAT(calaño));
            10:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calaño));
            11:
                EXIT('30/' + FORMAT(calmes) + '/' + FORMAT(calaño));
            12:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calaño));
        END;
    end;
}

