report 51038 "Det.Vend.Cob.Dud.(Group 19)"
{
    //LIBRO 3.6
    // Identify  Nro.  yyyy.MM.dd  Version   Description
    // -----------------------------------------------------
    // ULN::PC   001   2021.07.05    V.1     Peruvian Books (Copy From MT )
    DefaultLayout = RDLC;
    RDLCLayout = './App/Report/RDLC/Det.Vend.Cob.Dud.(Group 19).rdl';
    Caption = 'Det.Vend.Cob.Dud.(Group 19)', Comment = 'ESM="Det.Prov.Cob.Dud.(Grupo 19)"';
    ProcessingOnly = false;
    UseSystemPrinter = false;

    dataset
    {
        dataitem("Company Information"; "Company Information")
        {
            column(rucCompany; rucCompany)
            {
            }
            column(Ejercicio; Ejercicio)
            {
            }

            trigger OnPreDataItem()
            begin
                CompanyInfo.GET;
                rucCompany := CompanyInfo."VAT Registration No.";
                Ejercicio := FORMAT(FechaIni) + '..' + FORMAT(FechaFin);
            end;
        }
        dataitem(Integer; Integer)
        {
            PrintOnlyIfDetail = false;
            column(CompanyInfo_Name; CompanyInfo.Name)
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
            column(TipoDoc; gMaestroDatosTemp.Departamento)
            {
            }
            column(numDoc; gMaestroDatosTemp."No. Ruc EPS")
            {
            }
            column(NombrePersona; gMaestroDatosTemp.Description)
            {
            }
            column(G_L_Entry__G_L_Entry___Posting_Date_; gMaestroDatosTemp."Fecha Envio")
            {
            }
            column(G_L_Account__No__; gMaestroDatosTemp."Codigo Generico")
            {
            }
            column(G_L_Account_Name; gMaestroDatosTemp."Descripcion Generico")
            {
            }
            column(G_L_Entry__G_L_Entry__Amount; gMaestroDatosTemp."Importe Rel")
            {
            }
            column(G_L_Entry__External_Document_No__; gMaestroDatosTemp."Gran Familia")
            {
            }
            column(G_L_Entry__G_L_Entry__Amount_Control1000000011; gMaestroDatosTemp."Importe Rel")
            {
            }
            column(DataItem1000000000; FORMATO_3_6LIBRO_DE_INVENTARIOS_Y_BALANCES)
            {
            }
            column(APELLIDOS_Y_NOMBRES__DENOMINACION_O_RAZON_SOCIAL_Caption; APELLIDOS_Y_NOMBRES__DENOMINACION_O_RAZON_SOCIAL_CaptionLbl)
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
            column(FECHA_DE_LA_EMSION_DEL_COMPROBANTE_DE_PAGOCaption; FECHA_DE_LA_EMSION_DEL_COMPROBANTE_DE_PAGOCaptionLbl)
            {
            }
            column(DENOMINACION_O_RAZON_SOCIALCaption; DENOMINACION_O_RAZON_SOCIALCaptionLbl)
            {
            }
            column(MONTO_DE_LA_CUENTA_POR_COBRARCaption; MONTO_DE_LA_CUENTA_POR_COBRARCaptionLbl)
            {
            }
            column(NUMEROCaption; NUMEROCaptionLbl)
            {
            }
            column(DOCUMENTO_DE_IDENTIDADCaption; DOCUMENTO_DE_IDENTIDADCaptionLbl)
            {
            }
            column(APELLIDOS_Y_NOMBRESCaption; APELLIDOS_Y_NOMBRESCaptionLbl)
            {
            }
            column(TIPOCaption; TIPOCaptionLbl)
            {
            }
            column(INFORMACION_DE_DEUDORESCaption; INFORMACION_DE_DEUDORESCaptionLbl)
            {
            }
            column(NUMERO_DE_DOCUMENTOCaption; NUMERO_DE_DOCUMENTOCaptionLbl)
            {
            }
            column(CUENTA_POR_COBRAR_PROVISIONADACaption; CUENTA_POR_COBRAR_PROVISIONADACaptionLbl)
            {
            }
            column(MONTO_DE_LA_CUENTA_POR_COBRARCaption_Control1000000033; MONTO_DE_LA_CUENTA_POR_COBRARCaption_Control1000000033Lbl)
            {
            }
            column(SALDO_FINAL_TOTAL_Caption; SALDO_FINAL_TOTAL_CaptionLbl)
            {
            }
            column(G_L_Entry_Entry_No_; gMaestroDatosTemp.sequence)
            {
            }
            column(DocumentNo; gMaestroDatosTemp."Document No.")
            {
            }

            trigger OnAfterGetRecord()
            var
                lclBoolEnter: Boolean;
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
                Ejercicio := FORMAT(FechaIni, 0, '<Year4>');
                gCounter := 1;

                gCustLedgerEntry.RESET;
                gCustLedgerEntry.SETFILTER("Date Filter", '%1..%2', 0D, FechaFin);
                gCustLedgerEntry.SETFILTER("Remaining Amt. (LCY)", '<>%1', 0);
                gCustLedgerEntry.SETFILTER("Receivables Account", '%1', '19*');
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
                        gMaestroDatosTemp."Importe Rel" := gCustLedgerEntry."Remaining Amt. (LCY)" * -1;
                        gMaestroDatosTemp."Gran Familia" := gCustLedgerEntry."External Document No.";
                        gMaestroDatosTemp.INSERT;
                    UNTIL gCustLedgerEntry.NEXT = 0;

                gVendorLedgerEntry.RESET;
                gVendorLedgerEntry.SETFILTER("Date Filter", '%1..%2', 0D, FechaFin);
                gVendorLedgerEntry.SETFILTER("Remaining Amt. (LCY)", '<>%1', 0);
                gVendorLedgerEntry.SETFILTER("Payables Account", '%1', '19*');
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
                    Caption = 'Fecha Referencial', Comment = 'ESM="Fecha Referencial"';
                }
                field(verperiodo; verperiodo)
                {
                    Caption = 'Periodo', Comment = 'ESM="Periodo"';

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
        rucCompany := CompanyInfo."VAT Registration No.";
        Ejercicio := FORMAT(FechaIni) + '..' + FORMAT(FechaFin);
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
        ExcelBuf: Record "Excel Buffer" temporary;
        PrintToExcel: Boolean;
        Text0001: Label 'Trial Balance';
        Text0002: Label 'Data';
        Text003: Label 'Debit';
        Text004: Label 'Credit';
        Text005: Label 'Company Name';
        Text006: Label 'Report No.';
        Text007: Label 'Report Name';
        Text008: Label 'User ID';
        Text009: Label 'Date';
        Text010: Label 'G/L Filter';
        Text011: Label 'Period Filter';
        SaldoFinalTotal: Decimal;
        FORMATO_3_6LIBRO_DE_INVENTARIOS_Y_BALANCES: Label 'FORMATO 3.6LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL SALDO DE LA CUENTA 19 - PROVISION PARA CUENTAS DE COBRANZA DUDOSA';
        APELLIDOS_Y_NOMBRES__DENOMINACION_O_RAZON_SOCIAL_CaptionLbl: Label 'APELLIDOS Y NOMBRES, DENOMINACION O RAZON SOCIAL:';
        EJERCICIO_CaptionLbl: Label 'EJERCICIO:';
        RUCCaptionLbl: Label 'RUC';
        PERIODO_CaptionLbl: Label 'PERIODO:';
        FECHA_DE_LA_EMSION_DEL_COMPROBANTE_DE_PAGOCaptionLbl: Label 'FECHA DE LA EMSION DEL COMPROBANTE DE PAGO';
        DENOMINACION_O_RAZON_SOCIALCaptionLbl: Label 'DENOMINACION O RAZON SOCIAL';
        MONTO_DE_LA_CUENTA_POR_COBRARCaptionLbl: Label 'MONTO DE LA CUENTA POR COBRAR';
        NUMEROCaptionLbl: Label 'NUMERO';
        DOCUMENTO_DE_IDENTIDADCaptionLbl: Label 'DOCUMENTO DE IDENTIDAD';
        APELLIDOS_Y_NOMBRESCaptionLbl: Label 'APELLIDOS Y NOMBRES';
        TIPOCaptionLbl: Label 'TIPO';
        INFORMACION_DE_DEUDORESCaptionLbl: Label 'INFORMACION DE DEUDORES';
        NUMERO_DE_DOCUMENTOCaptionLbl: Label 'NUMERO DE DOCUMENTO';
        CUENTA_POR_COBRAR_PROVISIONADACaptionLbl: Label 'CUENTA POR COBRAR PROVISIONADA';
        MONTO_DE_LA_CUENTA_POR_COBRARCaption_Control1000000033Lbl: Label 'MONTO DE LA CUENTA POR COBRAR';
        SALDO_FINAL_TOTAL_CaptionLbl: Label 'SALDO FINAL TOTAL:';
        gCustLedgerEntry: Record "Cust. Ledger Entry";
        _VendorLedgerEntry: Record "Vendor Ledger Entry";
        gCustomer: Record Customer;
        lclRemAmt: Decimal;
        lclRemAmt2: Decimal;
        lclRemAmtTotal: Decimal;
        recVendor: Record Vendor;
        gCounter: Integer;
        gGLAccount: Record "G/L Account";
        gMaestroDatosTemp: Record "Master Data Buffer" temporary;
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
        MesPeriodo := recAccountingPeriod.Name + ' del ' + FORMAT(DATE2DMY(recAccountingPeriod."Starting Date", 3));
    end;

    procedure FunctionFechaFin(fechaing: Date): Text[30]
    var
        calmes: Integer;
        "calaõo": Integer;
        refmes: Integer;
    begin
        calmes := DATE2DMY(fechaing, 2);
        calaõo := DATE2DMY(fechaing, 3);
        IF calaõo MOD 4 = 0 THEN
            refmes := 29
        ELSE
            refmes := 28;
        CASE calmes OF
            1:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calaõo));
            2:
                EXIT(FORMAT(refmes) + '/' + FORMAT(calmes) + '/' + FORMAT(calaõo));
            3:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calaõo));
            4:
                EXIT('30/' + FORMAT(calmes) + '/' + FORMAT(calaõo));
            5:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calaõo));
            6:
                EXIT('30/' + FORMAT(calmes) + '/' + FORMAT(calaõo));
            7:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calaõo));
            8:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calaõo));
            9:
                EXIT('30/' + FORMAT(calmes) + '/' + FORMAT(calaõo));
            10:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calaõo));
            11:
                EXIT('30/' + FORMAT(calmes) + '/' + FORMAT(calaõo));
            12:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calaõo));
        END;
    end;
}

