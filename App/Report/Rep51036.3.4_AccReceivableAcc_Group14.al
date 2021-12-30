report 51036 "Acc Receivable. Acc (Group 14)"
{
    //LIBRO 3.4
    // Identify  Nro.  yyyy.MM.dd  Version   Description
    // -----------------------------------------------------
    // ULN::PC   001   2021.07.05    V.1     Peruvian Books (Copy From MT )
    DefaultLayout = RDLC;
    RDLCLayout = './App/Report/RDLC/Acc Receivable. Acc (Group 14).rdl';
    Caption = 'Acct. Receivable. Acc (Group 14)', Comment = 'ESM="Ctas. Por Cobrar .Acc.(Grupo 14)"';
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
            column(G_L_Account_Name; gMaestroDatosTemp."Descripcion Generico")
            {
            }
            column(G_L_Account__No__; gMaestroDatosTemp."Codigo Generico")
            {
            }
            column(SaldoFinalTotal; SaldoFinalTotal)
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
            column(DataItem1000000000; FORMATO_3_4_LIBRO_DE_INVENTARIOS_Y_BALANCES___DETALLE_DEL_SALDO_DE_LA_CUENTA_14)
            {
            }
            column(FECHA_DE_INICIO_DE_LA_OPERACIONCaption; FECHA_DE_INICIO_DE_LA_OPERACIONCaptionLbl)
            {
            }
            column(MONTO_DE_LA_CUENTA_POR_COBRARCaption; MONTO_DE_LA_CUENTA_POR_COBRARCaptionLbl)
            {
            }
            column(DENOMINACION_O_RAZON_SOCIALCaption; DENOMINACION_O_RAZON_SOCIALCaptionLbl)
            {
            }
            column(MONTO_DE_LA_CUENTA_POR_COBRARCaption_Control1000000009; MONTO_DE_LA_CUENTA_POR_COBRARCaption_Control1000000009Lbl)
            {
            }
            column(APELLIDOS_Y_NOMBRESCaption; APELLIDOS_Y_NOMBRESCaptionLbl)
            {
            }
            column(NUMEROCaption; NUMEROCaptionLbl)
            {
            }
            column(DOCUMENTO_DE_IDENTIDADCaption; DOCUMENTO_DE_IDENTIDADCaptionLbl)
            {
            }
            column(INFORMACION_DEL_ACCIONISTA__SOCIO_O_PERSONALCaption; INFORMACION_DEL_ACCIONISTA__SOCIO_O_PERSONALCaptionLbl)
            {
            }
            column(TIPOCaption; TIPOCaptionLbl)
            {
            }
            column(SALDO_FINAL_TOTAL_Caption; SALDO_FINAL_TOTAL_CaptionLbl)
            {
            }
            column(G_L_Entry__G_L_Account_No__; gMaestroDatosTemp."Codigo Generico")
            {
            }
            column(TipoDoc; gMaestroDatosTemp.Departamento)
            {
            }
            column(NombrePersona; gMaestroDatosTemp.Description)
            {
            }
            column(G_L_Entry__G_L_Entry__Amount; gMaestroDatosTemp."Importe Rel")
            {
            }
            column(G_L_Entry__Document_Date_; gMaestroDatosTemp."Fecha Envio")
            {
            }
            column(SUBTOTAL_Caption; SUBTOTAL_CaptionLbl)
            {
            }
            column(G_L_Entry_Entry_No_; gMaestroDatosTemp.sequence)
            {
            }
            column(numDoc; gMaestroDatosTemp."No. Ruc EPS")
            {
            }
            column(GrupoContable; gMaestroDatosTemp."Descripcion Generico")
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
                gCounter := 1;

                //ULN:PC 13.05.21 ++++++
                gEmployeeLedgerEntry.RESET;
                gEmployeeLedgerEntry.SETFILTER("Date Filter", '%1..%2', FechaIni, FechaFin);
                gEmployeeLedgerEntry.SETFILTER("Remaining Amt. (LCY)", '<>%1', 0);
                gEmployeeLedgerEntry.SETFILTER("Payables Account", '%1', '141*');
                IF gEmployeeLedgerEntry.FINDSET THEN
                    REPEAT
                        gEmployeeLedgerEntry.CALCFIELDS("Remaining Amt. (LCY)");
                        gGLAccount.GET(gEmployeeLedgerEntry."Payables Account");
                        gCounter += 1;
                        gMaestroDatosTemp.INIT;
                        gMaestroDatosTemp."No. Mov." := gCounter;
                        gMaestroDatosTemp."Codigo Nav" := gEmployeeLedgerEntry."Employee No.";
                        gMaestroDatosTemp."Descripcion Generico" := gGLAccount.Name;
                        gMaestroDatosTemp."Codigo Generico" := gEmployeeLedgerEntry."Payables Account";
                        IF gEmployeeLedgerEntry."Currency Code" = '' THEN
                            gMaestroDatosTemp."Cod. Pais" := 'S/'
                        ELSE
                            gMaestroDatosTemp."Cod. Pais" := 'USD';
                        gEmployee.RESET;
                        gEmployee.SETRANGE("No.", gEmployeeLedgerEntry."Employee No.");
                        IF gEmployee.FINDSET THEN BEGIN
                            gMaestroDatosTemp.Description := gEmployee.FullName;
                            gMaestroDatosTemp.Departamento := gEmployee."VAT Registration Type";
                            gMaestroDatosTemp."No. Ruc EPS" := gEmployee."VAT Registration No.";
                        END;
                        gMaestroDatosTemp."Document No." := gEmployeeLedgerEntry."Document No.";
                        gMaestroDatosTemp."Fecha Envio" := gEmployeeLedgerEntry."Posting Date";
                        gMaestroDatosTemp.sequence := gEmployeeLedgerEntry."Entry No.";
                        gMaestroDatosTemp."Importe Base" := gEmployeeLedgerEntry."Original Amount" * -1;
                        gMaestroDatosTemp."Importe Rel" := gEmployeeLedgerEntry."Remaining Amt. (LCY)";
                        gMaestroDatosTemp."Gran Familia" := gEmployeeLedgerEntry."External Document No.";
                        gMaestroDatosTemp.INSERT;
                    UNTIL gEmployeeLedgerEntry.NEXT = 0;
                //----------------------
                gCustLedgerEntry.RESET;
                gCustLedgerEntry.SETFILTER("Date Filter", '%1..%2', FechaIni, FechaFin);
                gCustLedgerEntry.SETFILTER("Remaining Amt. (LCY)", '<>%1', 0);
                gCustLedgerEntry.SETFILTER("Receivables Account", '%1|%2|%3|%4|%5', '142*', '143*', '144*', '148*', '149*');
                IF gCustLedgerEntry.FINDSET THEN
                    REPEAT
                        gCustLedgerEntry.CALCFIELDS("Remaining Amt. (LCY)");
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
                        gMaestroDatosTemp.sequence := gCustLedgerEntry."Entry No.";
                        gMaestroDatosTemp."Importe Base" := gCustLedgerEntry."Original Amount" * -1;
                        gMaestroDatosTemp."Importe Rel" := gCustLedgerEntry."Remaining Amt. (LCY)";
                        gMaestroDatosTemp."Gran Familia" := gCustLedgerEntry."External Document No.";
                        gMaestroDatosTemp.INSERT;
                    UNTIL gCustLedgerEntry.NEXT = 0;

                gVendorLedgerEntry.RESET;
                gVendorLedgerEntry.SETFILTER("Date Filter", '%1..%2', FechaIni, FechaFin);
                gVendorLedgerEntry.SETFILTER("Remaining Amt. (LCY)", '<>%1', 0);
                gVendorLedgerEntry.SETFILTER("Payables Account", '%1', '14*');
                IF gVendorLedgerEntry.FINDSET THEN
                    REPEAT
                        gVendorLedgerEntry.CALCFIELDS("Remaining Amt. (LCY)");
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
                        gMaestroDatosTemp."Document No." := gVendorLedgerEntry."Document No.";
                        gMaestroDatosTemp."Fecha Envio" := gVendorLedgerEntry."Document Date";
                        gMaestroDatosTemp.sequence := gVendorLedgerEntry."Entry No.";
                        gMaestroDatosTemp."Importe Base" := gVendorLedgerEntry."Original Amount" * -1;
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
                field(ARef; mescab)
                {
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
        recGlAccount: Record "G/L Account";
        NombreCuenta: Text[100];
        Saldototal: Decimal;
        SaldoFinalTotal: Decimal;
        recVendor: Record Vendor;
        recVendorLedgerEntry: Record "Vendor Ledger Entry";
        recGlEntry: Record "G/L Entry";
        Saldo: Decimal;
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
        cont: Integer;
        DENOMINACION_O_RAZON_SOCIAL_CaptionLbl: Label 'APELLIDOS Y NOMBRES, DENOMINACION O RAZON SOCIAL:';
        EJERCICIO_CaptionLbl: Label 'EJERCICIO:';
        RUC_CaptionLbl: Label 'RUC:';
        PERIODO_CaptionLbl: Label 'PERIODO:';
        FORMATO_3_4_LIBRO_DE_INVENTARIOS_Y_BALANCES___DETALLE_DEL_SALDO_DE_LA_CUENTA_14: Label 'FORMATO 3.4.LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL SALDO DE LA CUENTA 14 - CUENTAS POR COBRAR A ACCIONISTAS (O SOCIOS) Y PERSONAL';
        FECHA_DE_INICIO_DE_LA_OPERACIONCaptionLbl: Label 'FECHA DE INICIO DE LA OPERACION';
        MONTO_DE_LA_CUENTA_POR_COBRARCaptionLbl: Label 'MONTO DE LA CUENTA POR COBRAR';
        DENOMINACION_O_RAZON_SOCIALCaptionLbl: Label 'DENOMINACION O RAZON SOCIAL';
        MONTO_DE_LA_CUENTA_POR_COBRARCaption_Control1000000009Lbl: Label 'MONTO DE LA CUENTA POR COBRAR';
        APELLIDOS_Y_NOMBRESCaptionLbl: Label 'APELLIDOS Y NOMBRES';
        NUMEROCaptionLbl: Label 'NUMERO';
        DOCUMENTO_DE_IDENTIDADCaptionLbl: Label 'DOCUMENTO DE IDENTIDAD';
        INFORMACION_DEL_ACCIONISTA__SOCIO_O_PERSONALCaptionLbl: Label 'INFORMACION DEL ACCIONISTA, SOCIO O PERSONAL';
        TIPOCaptionLbl: Label 'TIPO';
        SALDO_FINAL_TOTAL_CaptionLbl: Label 'SALDO FINAL TOTAL:';
        SUBTOTAL_CaptionLbl: Label 'SUBTOTAL:';
        recDetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        gVendorLedgerEntry: Record "Vendor Ledger Entry";
        gResource: Record "Resource";
        gSaldoManual: Decimal;
        gMaestroDatosTemp: Record "Master Data Buffer" temporary;
        gVendor: Record Vendor;
        gCustomer: Record Customer;
        gEmployee: Record Employee;
        gCounter: Integer;
        gCustomerPostingGroup: Record "Customer Posting Group";
        gVendorPostingGroup: Record "Vendor Posting Group";
        gCustLedgerEntry: Record "Cust. Ledger Entry";
        gEmployeeLedgerEntry: Record "Employee Ledger Entry";
        gFiltrosValidar: Text[1024];
        gNroCta: Code[20];
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

