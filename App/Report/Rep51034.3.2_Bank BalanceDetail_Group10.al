report 51034 "Bank Balance Detail (Group 10)"
{
    //LIBRO 3.2
    // Identify  Nro.  yyyy.MM.dd  Version   Description
    // -----------------------------------------------------
    // ULN::PC   001   2021.07.05    V.1     Peruvian Books (Copy From MT )
    DefaultLayout = RDLC;
    UsageCategory = Administration;
    ApplicationArea = All;
    RDLCLayout = './App/Report/RDLC/Bank Balance Detail (Group 10).rdl';
    Caption = 'Bank Balance Detail (Group 10)', Comment = 'ESM="Detalle Saldo Banco (Grupo 10)"';

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            DataItemTableView = SORTING("G/L Account No.", "Posting Date")
                                WHERE("G/L Account No." = FILTER('10*'));
            column(reccompany_Name; reccompany.Name)
            {
            }
            column(ruc; ruc)
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
            column(G_L_Entry__Debit_Amount_; "Debit Amount")
            {
            }
            column(G_L_Entry__Credit_Amount_; "Credit Amount")
            {
            }
            column(G_L_Account___No__; "G/L Account"."No.")
            {
            }
            column(G_L_Account__Name; "G/L Account".Name)
            {
            }
            column(Debit_Amount___Credit_Amount_; "Debit Amount" - "Credit Amount")
            {
            }
            column(G_L_Entry__Debit_Amount__Control1000000040; "Debit Amount")
            {
            }
            column(G_L_Entry__Credit_Amount__Control1000000041; "Credit Amount")
            {
            }
            column(G_L_Account___No___Control1000000027; "G/L Account"."No.")
            {
            }
            column(G_L_Account__Name_Control1000000043; "G/L Account".Name)
            {
            }
            column(NombreBanco; NombreBanco)
            {
            }
            column(CuentaBanco; CuentaBanco)
            {
            }
            column(MonedaBanco; MonedaBanco)
            {
            }
            column(Debit_Amount___Credit_Amount__Control1000000021; "Debit Amount" - "Credit Amount")
            {
            }
            column(G_L_Entry__Credit_Amount__Control1000000038; "Credit Amount")
            {
            }
            column(G_L_Entry__Debit_Amount__Control1000000039; "Debit Amount")
            {
            }
            column(Debit_Amount___Credit_Amount__Control1000000031; "Debit Amount" - "Credit Amount")
            {
            }
            column(RUC_Caption; RUC_CaptionLbl)
            {
            }
            column(FORMATO_3_2_LIBRO_DE_INVENTARIOS_Y_BALANCES___DETALLE_DEL_SALDO_DE_LA_CUENTA_10___CAJA_Y_BANCOSCaption; FORMATO_3_2_LIBRO_DE_INVENTARIOS_Y_BALANCES___DETALLE_DEL_SALDO_DE_LA_CUENTA_10___CAJA_Y_BANCOSCaptionLbl)
            {
            }
            column(DENOMINACION_O_RAZON_SOCIAL_Caption; DENOMINACIÛN_O_RAZÛN_SOCIAL_CaptionLbl)
            {
            }
            column(PERIODO_Caption; PERIODO_CaptionLbl)
            {
            }
            column(Fecha_registroCaption; Fecha_registroCaptionLbl)
            {
            }
            column(CODIGOCaption; CODIGOCaptionLbl)
            {
            }
            column(ENTIDAD_FINANCIERACaption; ENTIDAD_FINANCIERACaptionLbl)
            {
            }
            column(ACREEDORCaption; ACREEDORCaptionLbl)
            {
            }
            column(DEUDORCaption; DEUDORCaptionLbl)
            {
            }
            column(NUMERO_DE_CUENTACaption; NUMERO_DE_CUENTACaptionLbl)
            {
            }
            column(TIPO_DE_MONEDACaption; TIPO_DE_MONEDACaptionLbl)
            {
            }
            column(CUENTACaption; CUENTACaptionLbl)
            {
            }
            column(REFERENCIA_DE_LA_CUENTACaption; REFERENCIA_DE_LA_CUENTACaptionLbl)
            {
            }
            column(MOVIMIENTOS_CONTABLESCaption; MOVIMIENTOS_CONTABLESCaptionLbl)
            {
            }
            column(SALDO_CONTABLE_FINALCaption; SALDO_CONTABLE_FINALCaptionLbl)
            {
            }
            column(TOTALCaption; TOTALCaptionLbl)
            {
            }
            column(G_L_Entry_Entry_No_; "Entry No.")
            {
            }
            column(G_L_Entry_G_L_Account_No_; "G/L Account No.")
            {
            }
            column(PrintDate; gPrintDate)
            {
            }
            column(Deudor; _Deudor)
            {
            }
            column(Acreedor; _Acreedor)
            {
            }
            column(TotalDeudor; _TotalDeudor)
            {
            }
            column(TotalAcreedor; _TotalAcreedor)
            {
            }

            trigger OnAfterGetRecord()
            begin

                gContador := gContador + 1;
                IF (OLDAccountNo <> "G/L Entry"."G/L Account No.") THEN BEGIN
                    _Deudor := 0;
                    _Acreedor := 0;
                    fechaantes := CALCDATE('<-1D>', "G/L Entry"."Posting Date");

                    "G/L Account".SETRANGE("Date Filter", FechaIni, FechaFin);
                    "G/L Account".SETFILTER("No.", "G/L Entry"."G/L Account No.");
                    "G/L Account".SETRANGE("G/L Account"."Account Type", "G/L Account"."Account Type"::Posting);
                    IF "G/L Account".FIND('-') THEN
                        REPEAT

                            "G/L Account".CALCFIELDS("Additional-Currency Net Change", "Net Change");
                            IF "G/L Account"."Net Change" > 0 THEN BEGIN
                                _Deudor := _Deudor + "G/L Account"."Net Change";
                            END ELSE BEGIN
                                _Acreedor := _Acreedor + ABS("G/L Account"."Net Change");
                            END;

                        UNTIL "G/L Account".NEXT = 0;
                    IF (_Deudor = 0) AND (_Acreedor = 0) THEN
                        CurrReport.SKIP;
                    //13.05.21 PC +++++++
                    gRecBankAccountPostingGroup.RESET;
                    gRecBankAccountPostingGroup.SETRANGE("G/L Bank Account No.", "G/L Account"."No.");
                    IF NOT gRecBankAccountPostingGroup.FINDFIRST THEN
                        CLEAR(gRecBankAccountPostingGroup);
                    //13.05.21 PC ------
                    recbanco.RESET;
                    recbanco.SETRANGE(recbanco."Bank Acc. Posting Group", gRecBankAccountPostingGroup.Code);//13.05.21 "G/L Entry"."Source No.");
                    IF recbanco.FIND('-') THEN BEGIN
                        NombreBanco := recbanco."Legal Document";
                        CuentaBanco := recbanco."Bank Account No.";
                        MonedaBanco := recbanco."Currency Code";
                        IF MonedaBanco = '' THEN
                            MonedaBanco := 'PEN'
                        ELSE
                            MonedaBanco := recbanco."Currency Code";
                    END ELSE BEGIN
                        NombreBanco := '';
                        CuentaBanco := '';
                        MonedaBanco := '';
                    END;
                END ELSE
                    CurrReport.SKIP;


                _TotalDeudor := _TotalDeudor + ABS(_Deudor);
                _TotalAcreedor := _TotalAcreedor + ABS(_Acreedor);

                OLDAccountNo := "G/L Entry"."G/L Account No.";
            end;

            trigger OnPreDataItem()
            begin
                reccompany.FIND('-');
                ruc := reccompany."VAT Registration No.";

                Ejercicio := FORMAT(FechaIni) + '..' + FORMAT(FechaFin);

                IF FechaIni = 0D THEN
                    ERROR(text001);

                IF FechaFin = 0D THEN
                    ERROR(text002);

                SETRANGE("G/L Entry"."Posting Date", 0D, FechaFin);

                IF gMovimientoCierre THEN BEGIN
                    SETFILTER("G/L Entry"."Document No.", 'CIERRE*');
                    SETRANGE("G/L Entry"."Posting Date", FechaFin);
                END;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                Description = 'Mensual';
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
                    Caption = 'Periodo', Comment = 'ESM="Periodo"';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookUpPeriodo();
                        // LookUpPeriodo_PAG;
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
                field(gPrintDate; gPrintDate)
                {
                    Caption = 'Fecha Impresión', Comment = 'ESM="Fecha Impresión"';
                }
                field(chkMovimientoCierre; gMovimientoCierre)
                {
                    Caption = 'Mostrar Cierre', Comment = 'ESM="Mostrar Cierre"';
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
        reccompany.GET;
    end;

    var
        "G/L Account": Record "G/L Account";
        empresa: Text[30];
        ruc: Text[30];
        reccompany: Record "Company Information";
        Text1100005: Label 'There is not any period in this range of date';
        GLFilterAccType: Text[30];
        GLFilterAcc: Text[30];
        HeaderText: Text[40];
        GLFilter: Text[250];
        NameAcc: Text[30];
        Num: Integer;
        i: Integer;
        FromDate: Date;
        ToDate: Date;
        gDebit: Decimal;
        gCredit: Decimal;
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
        SALDOTOTAL: Decimal;
        Ejercicio: Text[30];
        FechaIni: Date;
        FechaFin: Date;
        NombreCliente: Text[100];
        recCustomer: Record Customer;
        CompanyInfo: Record "Company Information";
        rucCompany: Text[30];
        FechaPeriodo: Date;
        mes: Integer;
        tipodocEmp: Option;
        NombreCompany: Text[30];
        tipoDocCliente: Text[30];
        numDoc: Code[20];
        text001: Label 'Ingrese la Fecha de Inicio del Periodo';
        text002: Label '<Ingrese la Fecha Fin del Periodo>';
        intPrimeraVuelta: Integer;
        SaldoInicial: Decimal;
        recbanco: Record "Bank Account";
        NombreBanco: Text[100];
        CuentaBanco: Text[100];
        MonedaBanco: Text[30];
        MesPromedio: Text[30];
        MesPeriodo: Text[30];
        MostrarInfo: Boolean;
        FechaInfo: Text[30];
        PaginaInfo: Text[30];
        UsuarioInfo: Text[30];
        FechaImpresion: Date;
        verperiodo: Text[100];
        mescab: Integer;
        mosfr: Boolean;
        RUC_CaptionLbl: Label 'RUC:';
        FORMATO_3_2_LIBRO_DE_INVENTARIOS_Y_BALANCES___DETALLE_DEL_SALDO_DE_LA_CUENTA_10___CAJA_Y_BANCOSCaptionLbl: Label 'FORMATO 3.2.LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL SALDO DE LA CUENTA 10 - CAJA Y BANCOS';
        "DENOMINACIÛN_O_RAZÛN_SOCIAL_CaptionLbl": Label 'DENOMINACIÛN O RAZÛN SOCIAL:';
        PERIODO_CaptionLbl: Label 'PERIODO:';
        Fecha_registroCaptionLbl: Label 'Fecha registro';
        CODIGOCaptionLbl: Label 'CODIGO';
        ENTIDAD_FINANCIERACaptionLbl: Label 'ENTIDAD FINANCIERA';
        ACREEDORCaptionLbl: Label 'ACREEDOR';
        DEUDORCaptionLbl: Label 'DEUDOR';
        NUMERO_DE_CUENTACaptionLbl: Label 'NUMERO DE CUENTA';
        TIPO_DE_MONEDACaptionLbl: Label 'TIPO DE MONEDA';
        CUENTACaptionLbl: Label 'CUENTA';
        REFERENCIA_DE_LA_CUENTACaptionLbl: Label 'REFERENCIA DE LA CUENTA';
        MOVIMIENTOS_CONTABLESCaptionLbl: Label 'MOVIMIENTOS CONTABLES';
        SALDO_CONTABLE_FINALCaptionLbl: Label 'SALDO CONTABLE FINAL';
        TOTALCaptionLbl: Label 'TOTAL';
        gPrintDate: Date;
        gMovimientoCierre: Boolean;
        gAnioCierre: Code[10];
        _Deudor: Decimal;
        _Acreedor: Decimal;
        _TotalDeudor: Decimal;
        _TotalAcreedor: Decimal;
        OLDAccountNo: Code[45];
        gContador: Integer;
        gRecBankAccountPostingGroup: Record "Bank Account Posting Group";

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

        IF PAGE.RUNMODAL(PAGE::"Accounting Periods", recAccountingPeriod) = ACTION::LookupOK THEN BEGIN
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

    procedure LookUpPeriodo_PAG()
    var
        recAccountingPeriod2: Record "Accounting Period";
        fini: Date;
        ffin: Date;
        PAGES: Page "Accounting Periods";
    begin

        fini := DMY2DATE(1, 1, DATE2DMY(WORKDATE, 3));
        ffin := DMY2DATE(31, 12, DATE2DMY(WORKDATE, 3));
        IF mosfr = TRUE THEN BEGIN
            fini := DMY2DATE(1, 1, mescab);
            ffin := DMY2DATE(31, 12, mescab);
        END;
        recAccountingPeriod2.SETFILTER(recAccountingPeriod2."Starting Date", '>=%1&<=%2', fini, ffin);

        IF PAGES.RUNMODAL = ACTION::LookupOK THEN BEGIN
            verperiodo := '';
            FechaIni := 0D;
            FechaFin := 0D;
            MesPeriodo := '';
            verperiodo := recAccountingPeriod2.Name;
            FechaIni := recAccountingPeriod2."Starting Date";
            FechaFin := CALCDATE('<+CM>', recAccountingPeriod2."Starting Date");
            //EVALUATE(FechaFin,FunctionFechaFin(recAccountingPeriod."Starting Date"));
            //MesPeriodo:=recAccountingPeriod2.Name+' del '+FORMAT(DATE2DMY(recAccountingPeriod2."Starting Date",3));
            MesPeriodo := FORMAT(DATE2DMY(recAccountingPeriod2."Starting Date", 3));
        END;
    end;
}

