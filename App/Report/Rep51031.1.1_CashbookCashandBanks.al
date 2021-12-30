report 51031 "Cashbook Cash and Banks"
{
    //LIBRO 1.1
    // Identify  Nro.  yyyy.MM.dd  Version   Description
    // -----------------------------------------------------
    // ULN::PC   001   2021.07.05    V.1     Peruvian Books (Copy From MT )
    DefaultLayout = RDLC;
    RDLCLayout = './App/Report/RDLC/Cashbook Cash and Banks.rdl';
    UsageCategory = Administration;
    ApplicationArea = All;
    Caption = 'Cashbook Cash and Banks', Comment = 'ESM="Libro Caja y Bancos Efectivos"';

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = WHERE(Number = CONST(1));
            column(ruc; ruc)
            {
            }
            column(empresa; empresa)
            {
            }
            column(Periodo; Periodo_)
            {
            }
            column(DescripcionMovimiento; DescripcionMovimiento)
            {
            }
            column(TieneMovimiento; TieneMovimiento_)
            {
            }
            dataitem("G/L Entry"; "G/L Entry")
            {
                DataItemTableView = SORTING("G/L Account No.", "Posting Date")
                                    ORDER(Ascending);
                RequestFilterFields = "G/L Account No.";
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
                column(SaldoIniDeudor; SaldoIniDeudor)
                {
                }
                column(G_L_Entry___G_L_Account_No________G_L_Account__Name; "G/L Entry"."G/L Account No." + ' ' + "G/L Account".Name)
                {
                }
                column(SaldoIniAcreedor; SaldoIniAcreedor)
                {
                }
                column(SaldoFinAcreedor; SaldoFinAcreedor)
                {
                }
                column(SaldoFinDeudor; SaldoFinDeudor)
                {
                }
                column(TFTotalCreditAmt; TFTotalCreditAmt)
                {
                }
                column(TFTotalDebitAmt; TFTotalDebitAmt)
                {
                }
                column(TFTotalDebitAmt_Control1000000016; TFTotalDebitAmt)
                {
                }
                column(TFTotalCreditAmt_Control1000000003; TFTotalCreditAmt)
                {
                }
                column(FORMATO_1_1__LIBRO_CAJA_Y_BANCOS___DETALLE_DE_LOS_MOVIMIENTOS_DE_EFECTIVOCaption; FORMATO_1_1__LIBRO_CAJA_Y_BANCOS___DETALLE_DE_LOS_MOVIMIENTOS_DE_EFECTIVOCaptionLbl)
                {
                }
                column(RUCCaption; RUCCaptionLbl)
                {
                }
                column(RAZON_SOCIALCaption; RAZON_SOCIALCaptionLbl)
                {
                }
                column(PERIODO_Caption; PERIODO_CaptionLbl)
                {
                }
                column(FECHA_DE_LA_OPERACIONCaption; FECHA_DE_LA_OPERACIONCaptionLbl)
                {
                }
                column(No__ASIENTOCaption; No__ASIENTOCaptionLbl)
                {
                }
                column(DESCRIPCION_DE_LA_OPERACIONCaption; DESCRIPCION_DE_LA_OPERACIONCaptionLbl)
                {
                }
                column(ACREEDORCaption; ACREEDORCaptionLbl)
                {
                }
                column(DEUDORCaption; DEUDORCaptionLbl)
                {
                }
                column(SALDOS_Y_MOVIMIENTOSCaption; SALDOS_Y_MOVIMIENTOSCaptionLbl)
                {
                }
                column(DENOMINACIONCaption; DENOMINACIONCaptionLbl)
                {
                }
                column(CODIGOCaption; CODIGOCaptionLbl)
                {
                }
                column(CUENTA_CONTABLE_ASOCIADACaption; CUENTA_CONTABLE_ASOCIADACaptionLbl)
                {
                }
                column(Saldo_AnteriorCaption; Saldo_AnteriorCaptionLbl)
                {
                }
                column(Saldo_FinalCaption; Saldo_FinalCaptionLbl)
                {
                }
                column(Suma_y_Sigue__Caption; Suma_y_Sigue__CaptionLbl)
                {
                }
                column(TotalCaption; TotalCaptionLbl)
                {
                }
                column(G_L_Entry_Entry_No_; "Entry No.")
                {
                }
                column(G_L_Entry_G_L_Account_No_; "G/L Account No.")
                {
                }
                column(G_L_Entry_Transaction_No_; "Transaction No.")
                {
                }
                dataitem("<G/L Entry 2>"; "G/L Entry")
                {
                    DataItemLink = "Transaction No." = FIELD("Transaction No.");
                    DataItemTableView = SORTING("Transaction No.")
                                        ORDER(Ascending);
                    PrintOnlyIfDetail = false;
                    column(Beneficiario; gBeneficiario)
                    {
                    }
                    column(G_L_Entry_2___G_L_Account_No__; "G/L Account No.")
                    {
                    }
                    column(G_L_Entry_2__Description; Description)
                    {
                    }
                    column(G_L_Entry_2___Debit_Amount_; "Debit Amount")
                    {
                    }
                    column(G_L_Entry_2___Credit_Amount_; "Credit Amount")
                    {
                    }
                    column(G_L_Entry_2___Transaction_No__; "Transaction No.")
                    {
                    }
                    column(G_L_Entry_2___Posting_Date_; "Posting Date")
                    {
                    }
                    column(NameAccountDetalle; NameAccountDetalle)
                    {
                    }
                    column(TFTotalCreditAmt_Control1000000022; TFTotalCreditAmt)
                    {
                    }
                    column(TFTotalDebitAmt_Control1000000025; TFTotalDebitAmt)
                    {
                    }
                    column(Suma_y_Sigue__Caption_Control1000000028; Suma_y_Sigue__Caption_Control1000000028Lbl)
                    {
                    }
                    column(G_L_Entry_2__Entry_No_; "Entry No.")
                    {
                    }
                    column(TipoDocumento; TipoDocumento_)
                    {
                    }
                    column(NroSerie; NroSerie_)
                    {
                    }
                    column(NroDocumento; NroDocumento_)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        "G/L Account 2".RESET;
                        "G/L Account 2".SETRANGE("G/L Account 2"."No.", "<G/L Entry 2>"."G/L Account No.");
                        "G/L Account 2".SETFILTER("G/L Account 2"."No.", '%1&<>%2&<>%3&<>%7', '10*', '104*', '106*', '107*');
                        "G/L Account 2".FIND('-');
                        NameAccountDetalle := "G/L Account 2".Name;


                        TipoDocumento_ := '';
                        recMovProveedores.RESET;
                        recMovProveedores.SETRANGE(recMovProveedores."Document No.", "Document No.");
                        IF recMovProveedores.FINDSET THEN BEGIN
                            NroMov_ := recMovProveedores."Entry No.";
                            recMovProveedores2.RESET;
                            recMovProveedores2.SETRANGE(recMovProveedores2."Closed by Entry No.", NroMov_);
                            IF recMovProveedores2.FINDFIRST THEN
                                TipoDocumento_ := recMovProveedores2."Legal Document";
                        END;

                        NroDocumento_ := "<G/L Entry 2>"."Document No.";
                    end;

                    trigger OnPreDataItem()
                    var
                        LCLglentry: Record "G/L Entry";
                    begin
                        SETFILTER("<G/L Entry 2>".Amount, '<>0');
                        SETFILTER("<G/L Entry 2>"."G/L Account No.", '<>%1&<>%2&<>%3&<>%4&<>%5&<>%6', '101*', '102*', '103*', '105*', '108*', '107*');
                        SETFILTER("Document No.", '<>%1', 'APER*');
                        SETRANGE("Analityc Entry", FALSE);
                        SETFILTER("<G/L Entry 2>"."Posting Date", '%1..%2', FechaIni, FechaFin);
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    LCLglentry: Record "G/L Entry";
                begin
                    TieneMovimiento_ := TRUE;
                    SaldoInicial10 := 0;
                    SaldoFinal10 := 0;
                    SaldoIniAcreedor := 0;
                    SaldoIniDeudor := 0;
                    SaldoFinAcreedor := 0;
                    SaldoFinDeudor := 0;
                    fechaantes := FechaIni - 1;
                    fechaantes := CLOSINGDATE(fechaantes);
                    "G/L Account".SETRANGE("G/L Account"."Date Filter", 0D, fechaantes);
                    "G/L Account".SETRANGE("G/L Account"."No.", "G/L Entry"."G/L Account No.");
                    IF "G/L Account".FIND('-') THEN
                        REPEAT
                            "G/L Account".CALCFIELDS("Net Change");
                            SaldoInicial10 := SaldoInicial10 + "G/L Account"."Net Change"
                        UNTIL "G/L Account".NEXT = 0;

                    LCLglentry.RESET;
                    LCLglentry.SETRANGE("G/L Account No.", "G/L Account No.");
                    LCLglentry.SETFILTER("Document No.", '%1', 'APER*');
                    LCLglentry.SETRANGE("Posting Date", FechaIni, FechaFin);
                    IF LCLglentry.FINDSET THEN
                        REPEAT
                            SaldoInicial10 += LCLglentry.Amount;
                        UNTIL LCLglentry.NEXT = 0;

                    SaldoInicial104 := 0;
                    SaldoInicial := SaldoInicial10 - SaldoInicial104;
                    IF SaldoInicial > 0 THEN
                        SaldoIniDeudor := SaldoInicial
                    ELSE
                        SaldoIniAcreedor := ABS(SaldoInicial);

                    /* IF (SaldoIniDeudor = 0) AND (SaldoIniAcreedor = 0) THEN
                      CurrReport.SKIP;*/

                    "G/L Account".SETRANGE("G/L Account"."Date Filter", 0D, FechaFin);
                    "G/L Account".SETRANGE("G/L Account"."No.", "G/L Entry"."G/L Account No.");
                    IF "G/L Account".FIND('-') THEN
                        REPEAT
                            "G/L Account".CALCFIELDS("Net Change");
                            SaldoFinal10 := SaldoFinal10 + "G/L Account"."Net Change"
                        UNTIL "G/L Account".NEXT = 0;


                    SaldoFinal104 := 0;

                    SaldoFinal := SaldoFinal10 - SaldoFinal104;

                    IF SaldoFinal > 0 THEN
                        SaldoFinAcreedor := SaldoFinal
                    ELSE
                        SaldoFinDeudor := ABS(SaldoFinal);

                    gBeneficiario := '';
                    gBankAccLedEntry.RESET;
                    gBankAccLedEntry.SETRANGE("Transaction No.", "Transaction No.");
                    IF gBankAccLedEntry.FINDSET THEN BEGIN
                        gBeneficiario := '';//gBankAccLedEntry.Beneficiario;//Beneficiario comentado
                    END;

                end;

                trigger OnPreDataItem()
                begin
                    empresa := reccompany.Name;
                    ruc := reccompany."VAT Registration No.";
                    Periodo_ := FORMAT(FechaIni) + ' del ' + FORMAT(FechaFin);

                    intPrimeraVuelta := 0;


                    IF FechaIni = 0D THEN
                        ERROR(text012);

                    IF FechaFin = 0D THEN
                        ERROR(text013);

                    Ejercicio := FORMAT(FechaIni) + '..' + FORMAT(FechaFin);
                    SETRANGE("Analityc Entry", FALSE);
                    SETFILTER("G/L Entry"."G/L Account No.", '%1&<>%2&<>%3&<>%4', '10*', '104*', '106*', '107*');

                    CantRegistro_ := 0;
                    CantRegistro_ := "G/L Entry".COUNT();
                    IF CantRegistro_ = 0 THEN BEGIN
                        TieneMovimiento_ := FALSE;
                        DescripcionMovimiento := 'No tiene Movimiento';
                    END;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("<Control1000000001>"; mosfr)
                {
                    Caption = 'Habilitar año de Referencial', Comment = 'ESM="Habilitar año de Referencial"';
                    Enabled = true;

                    trigger OnValidate()
                    begin

                        IF mosfr = TRUE THEN BEGIN
                            //RequestOptionsPage.ARef.ENABLED(TRUE);
                            mescab := DATE2DMY(TODAY, 3)
                        END ELSE BEGIN
                            //RequestOptionsPage.ARef.ENABLED:=FALSE;
                            mescab := 0;
                        END;
                    end;
                }
                field(mescab; mescab)
                {
                    Caption = 'Año Referencial', Comment = 'ESM="Año Referencial"';
                }
                field(verperiodo; verperiodo)
                {
                    Caption = 'Fecha de Referencia', Comment = 'ESM="Fecha de Referencia"';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookUpPeriodo;
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
                field(MostrarInfo; MostrarInfo)
                {
                    Caption = 'Mostrar Info Audit.', Comment = 'ESM="Mostrar Info Audit."';
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

    trigger OnInitReport()
    begin
        TFTotalDebitAmt := 0;
        TFTotalCreditAmt := 0;
        reccompany.GET;
    end;

    trigger OnPreReport()
    begin
        FiltroCuenta := "G/L Entry".GETFILTER("G/L Entry"."G/L Account No.");
    end;

    var
        "G/L Account": Record "G/L Account";
        empresa: Text[100];
        ruc: Text[30];
        reccompany: Record "Company Information";
        Text1100005: Label 'There is not any period in this range of date';
        GLFilterAccType: Text[30];
        GLFilterAcc: Text[30];
        HeaderText: Text[40];
        GLFilter: Text[30];
        NameAcc: Text[30];
        Num: Integer;
        i: Integer;
        FromDate: Date;
        ToDate: Date;
        PostDate: Date;
        InitPeriodDate: Date;
        DateClose: Date;
        EndPeriodDate: Date;
        DateOpen: Date;
        LastDate: Date;
        NormPostDate: Date;
        PrintAmountsInAddCurrency: Boolean;
        Print: Boolean;
        PrintClosing: Boolean;
        HaveEntries: Boolean;
        NotFound: Boolean;
        Found: Boolean;
        Open: Boolean;
        TFTotalDebitAmt: Decimal;
        TFTotalCreditAmt: Decimal;
        TFGLBalance: Decimal;
        TD: Decimal;
        TC: Decimal;
        TB: Decimal;
        TotalDebit: Decimal;
        TotalBalance: Decimal;
        TotalCredit: Decimal;
        GLBalance: Decimal;
        CloseTotalDebitEntries: Decimal;
        CloseTotalCreditEntries: Decimal;
        CloseGLBalanceEntries: Decimal;
        TransDebit: Decimal;
        TransCredit: Decimal;
        NewPagePerAcc: Boolean;
        PreviusData: Boolean;
        IncludeAccountBalance: Boolean;
        GLAcc2: Record "G/L Account";
        IncludeZeroBalance: Boolean;
        GLFilterDim1: Code[20];
        GLFilterDim2: Code[20];
        LineNo: Integer;
        MaxLines: Integer;
        NotFooterHeader: Boolean;
        Text1100004: Label '';
        fechaantes: Date;
        DebeIni: Decimal;
        HaberIni: Decimal;
        DebeFin: Decimal;
        Haberfin: Decimal;
        Saldoini: Decimal;
        Saldofin: Decimal;
        Arrastrefinal: Decimal;
        Ejercicio: Text[30];
        FechaIni: Date;
        FechaFin: Date;
        text012: Label 'Por favor ingresar la fecha inicio del periodo';
        text013: Label 'Por favor ingresar la fecha fin del periodo';
        NameAccountDetalle: Text[250];
        "G/L Account 2": Record "G/L Account";
        GLEntryDos: Record "G/L Entry";
        intPrimeraVuelta: Integer;
        SaldoInicial: Decimal;
        GLEntryTres: Record "G/L Entry";
        Mes: Text[30];
        MesPeriodo: Text[30];
        MostrarInfo: Boolean;
        FechaInfo: Text[30];
        PaginaInfo: Text[30];
        UsuarioInfo: Text[30];
        FiltroCuenta: Text[30];
        SaldoFinal: Decimal;
        SaldoInicial10: Decimal;
        SaldoFinal10: Decimal;
        SaldoInicial104: Decimal;
        SaldoFinal104: Decimal;
        SaldoIniAcreedor: Decimal;
        SaldoIniDeudor: Decimal;
        SaldoFinAcreedor: Decimal;
        SaldoFinDeudor: Decimal;
        verperiodo: Text[100];
        mescab: Integer;
        mosfr: Boolean;
        PrintToExcel: Boolean;
        Text000: Label 'Period: %1';
        Text001: Label 'Trial Balance';
        Text002: Label 'Data';
        Text003: Label 'Debit';
        Text004: Label 'Credit';
        Text005: Label 'Company Name';
        Text006: Label 'Report No.';
        Text007: Label 'Report Name';
        Text008: Label 'User ID';
        Text009: Label 'Date';
        Text010: Label 'G/L Filter';
        Text011: Label 'Period Filter';
        ExcelBuf: Record "Excel Buffer" temporary;
        FORMATO_1_1__LIBRO_CAJA_Y_BANCOS___DETALLE_DE_LOS_MOVIMIENTOS_DE_EFECTIVOCaptionLbl: Label 'FORMATO 1.1. LIBRO CAJA Y BANCOS - DETALLE DE LOS MOVIMIENTOS DE EFECTIVO';
        RUCCaptionLbl: Label 'RUC';
        RAZON_SOCIALCaptionLbl: Label 'RAZON SOCIAL';
        PERIODO_CaptionLbl: Label 'PERIODO:';
        FECHA_DE_LA_OPERACIONCaptionLbl: Label 'FECHA DE LA OPERACION';
        No__ASIENTOCaptionLbl: Label 'No. ASIENTO';
        DESCRIPCION_DE_LA_OPERACIONCaptionLbl: Label 'DESCRIPCION DE LA OPERACION';
        ACREEDORCaptionLbl: Label 'ACREEDOR';
        DEUDORCaptionLbl: Label 'DEUDOR';
        SALDOS_Y_MOVIMIENTOSCaptionLbl: Label 'SALDOS Y MOVIMIENTOS';
        DENOMINACIONCaptionLbl: Label 'DENOMINACION';
        CODIGOCaptionLbl: Label 'CODIGO';
        CUENTA_CONTABLE_ASOCIADACaptionLbl: Label 'CUENTA CONTABLE ASOCIADA';
        Saldo_AnteriorCaptionLbl: Label 'Saldo Anterior';
        Saldo_FinalCaptionLbl: Label 'Saldo Final';
        Suma_y_Sigue__CaptionLbl: Label 'Suma y Sigue..';
        TotalCaptionLbl: Label 'Total';
        Suma_y_Sigue__Caption_Control1000000028Lbl: Label 'Suma y Sigue..';
        gBankAccLedEntry: Record "Bank Account Ledger Entry";
        gBeneficiario: Text[250];
        NroSerie_: Code[10];
        NroDocumento_: Code[30];
        recMovProveedores: Record "Vendor Ledger Entry";
        NroMov_: Integer;
        recMovProveedores2: Record "Vendor Ledger Entry";
        TipoDocumento_: Code[10];
        CantRegistro_: Integer;
        TieneMovimiento_: Boolean;
        Periodo_: Code[45];
        DescripcionMovimiento: Code[35];

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

