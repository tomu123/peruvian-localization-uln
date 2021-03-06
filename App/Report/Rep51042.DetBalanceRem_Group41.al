report 51042 "Det.Balance Rem.(Group 41)"
{
    //LIBRO 3.11

    // Identify  Nro.  yyyy.MM.dd  Version   Description
    // -----------------------------------------------------
    // ULN::CCL  001   2018.01.31  v.001     LPE
    DefaultLayout = RDLC;
    RDLCLayout = './App/Report/RDLC/Det.Balance Rem.(Group 41).rdl';
    Caption = 'Det.Balance Rem.(Group 41)', Comment = 'ESM="Det.Saldo Rem.(Grupo 41)"';

    dataset
    {
        dataitem(Integer; Integer)
        {
            column(rucCompany; rucCompany)
            {
            }
            column(Ejercicio; Ejercicio)
            {
            }
            column(UserInfo; UsuarioInfo)
            {
            }
            column(MesPeriodo; MesPeriodo)
            {
            }
            column(PaginaInfo; PaginaInfo)
            {
            }
            column(InfoFecha; FechaInfo)
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
            column(FORMATO_3_11_LIBRO_DE_INVENTARIOS_Y_BALANCES___DETALLE_DEL_SALDO_DE_LA_CUENTA_41___REMUNERACIONES_POR_PAGARCaption; FORMATO_3_11_LIBRO_DE_INVENTARIOS_Y_BALANCES___DETALLE_DEL_SALDO_DE_LA_CUENTA_41___REMUNERACIONES_POR_PAGARCaptionLbl)
            {
            }
            column(SALDO_FINALCaption; SALDO_FINALCaptionLbl)
            {
            }
            column(NUMEROCaption; NUMEROCaptionLbl)
            {
            }
            column(TIPO_Caption; TIPO_CaptionLbl)
            {
            }
            column(APELLIDOS_Y_NOMBRECaption; APELLIDOS_Y_NOMBRECaptionLbl)
            {
            }
            column(DENOMINACIONCaption; DENOMINACIONCaptionLbl)
            {
            }
            column(MONTO_DE_LA_CUENTA_POR_COBRARCaption; MONTO_DE_LA_CUENTA_POR_COBRARCaptionLbl)
            {
            }
            column(CODIGOCaption; CODIGOCaptionLbl)
            {
            }
            column(CUENTACaption; CUENTACaptionLbl)
            {
            }
            column(TRABAJADORCaption; TRABAJADORCaptionLbl)
            {
            }
            column(CODIGOCaption_Control1000000043; CODIGOCaption_Control1000000043Lbl)
            {
            }
            column(SALDO_FINAL_TOTAL_Caption; SALDO_FINAL_TOTAL_CaptionLbl)
            {
            }
            column(G_L_Entry_Amount; gMaestroDatosTemp."Importe Rel")
            {
            }
            column(G_L_Entry__G_L_Account_No__; gMaestroDatosTemp."Codigo Generico")
            {
            }
            column(DenominacionCuenta; gMaestroDatosTemp."Descripcion Generico")
            {
            }
            column(NombrePersona; gMaestroDatosTemp.Description)
            {
            }
            column(TipoDoc; gMaestroDatosTemp.Departamento)
            {
            }
            column(NumDoc; gMaestroDatosTemp."No. Ruc EPS")
            {
            }
            column(CodigoVendor; gMaestroDatosTemp."No. Ruc EPS")
            {
            }
            column(CodigoVendor_Control1000000001; gMaestroDatosTemp."No. Ruc EPS")
            {
            }
            column(G_L_Entry_Amount_Control1000000007; gMaestroDatosTemp."Importe Rel")
            {
            }
            column(G_L_Entry__G_L_Account_No___Control1000000038; gMaestroDatosTemp."Codigo Generico")
            {
            }
            column(TOTAL_Caption; TOTAL_CaptionLbl)
            {
            }
            column(G_L_Entry_Entry_No_; gMaestroDatosTemp.sequence)
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

                //ULN:PC 13.05.21 ++++++
                gEmployeeLedgerEntry.RESET;
                gEmployeeLedgerEntry.SETFILTER("Date Filter", '%1..%2', 0D, FechaFin);
                gEmployeeLedgerEntry.SETFILTER("Remaining Amt. (LCY)", '<>%1', 0);
                gEmployeeLedgerEntry.SETFILTER("Payables Account", '%1', '41*');
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
                //------------------

                gCustLedgerEntry.RESET;
                gCustLedgerEntry.SETFILTER("Date Filter", '%1..%2', 0D, FechaFin);
                gCustLedgerEntry.SETFILTER("Remaining Amt. (LCY)", '<>%1', 0);
                gCustLedgerEntry.SETFILTER("Receivables Account", '%1', '41*');
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
                gVendorLedgerEntry.SETFILTER("Payables Account", '%1', '41*');
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
                field(chkanio; mosfr)
                {
                    Caption = 'A??o Referencial', Comment = 'ESM="A??o Referencial"';

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
                    Caption = 'Fecha Impresi??n', Comment = 'ESM="Fecha Impresi??n"';
                }
                field(FechaPeriodo; FechaPeriodo)
                {
                    Caption = 'Fecha Inicio del Periodo', Comment = 'ESM="Fecha Inicio del Periodo"';
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
        CompanyInfo: Record "Company Information";
        rucCompany: Text[30];
        NombreCompany: Text[30];
        Ejercicio: Text[30];
        FechaIni: Date;
        FechaFin: Date;
        text001: Label 'Ingrese la Fecha de Inicio del Periodo';
        text002: Label '<Ingrese la Fecha Fin del Periodo>';
        FechaPeriodo: Date;
        MesPeriodo: Text[30];
        MostrarInfo: Boolean;
        FechaInfo: Text[30];
        PaginaInfo: Text[30];
        UsuarioInfo: Text[30];
        SaldoFinal: Decimal;
        Total: Decimal;
        DenominacionCuenta: Text[100];
        TipoDoc: Text[30];
        NumDoc: Text[30];
        NombrePersona: Text[200];
        recCustomer: Record Customer;
        recCuenta: Record "G/L Account";
        CodPersona: Text[30];
        gResource: Record Resource;
        recConfigSunat: Record "Master Data";
        FechaImpresion: Date;
        verperiodo: Text[100];
        mescab: Integer;
        mosfr: Boolean;
        SaldoFinalTotal: Decimal;
        SaldoTotal: Decimal;
        recGlEntry: Record "G/L Entry";
        Monto: Decimal;
        recVendor: Record Vendor;
        CodigoVendor: Text[30];
        DENOMINACION_O_RAZON_SOCIAL_CaptionLbl: Label 'DENOMINACION O RAZON SOCIAL:';
        EJERCICIO_CaptionLbl: Label 'EJERCICIO:';
        RUC_CaptionLbl: Label 'RUC:';
        PERIODO_CaptionLbl: Label 'PERIODO';
        FORMATO_3_11_LIBRO_DE_INVENTARIOS_Y_BALANCES___DETALLE_DEL_SALDO_DE_LA_CUENTA_41___REMUNERACIONES_POR_PAGARCaptionLbl: Label 'FORMATO 3.11.LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL SALDO DE LA CUENTA 41 - REMUNERACIONES POR PAGAR';
        SALDO_FINALCaptionLbl: Label 'SALDO FINAL';
        NUMEROCaptionLbl: Label 'NUMERO';
        TIPO_CaptionLbl: Label 'TIPO (TABLA 2)';
        APELLIDOS_Y_NOMBRECaptionLbl: Label 'APELLIDOS Y NOMBRE';
        DENOMINACIONCaptionLbl: Label 'DENOMINACION';
        MONTO_DE_LA_CUENTA_POR_COBRARCaptionLbl: Label 'DOCUMENTOS DE IDENTIDAD';
        CODIGOCaptionLbl: Label 'CODIGO';
        CUENTACaptionLbl: Label 'CUENTA';
        TRABAJADORCaptionLbl: Label 'TRABAJADOR';
        CODIGOCaption_Control1000000043Lbl: Label 'CODIGO';
        SALDO_FINAL_TOTAL_CaptionLbl: Label 'SALDO FINAL TOTAL:';
        TOTAL_CaptionLbl: Label ' TOTAL MOV:';
        gGLEntry: Record "G/L Entry";
        gMaestroDatosTemp: Record "Master Data Buffer" temporary;
        gCounter: Integer;
        gVendorLedgerEntry: Record "Vendor Ledger Entry";
        gCustLedgerEntry: Record "Cust. Ledger Entry";
        gGLAccount: Record "G/L Account";
        gCustomer: Record Customer;
        gVendor: Record Vendor;
        gEmployeeLedgerEntry: Record "Employee Ledger Entry";
        gEmployee: Record Employee;

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
        "cala??o": Integer;
        refmes: Integer;
    begin
        calmes := DATE2DMY(fechaing, 2);
        cala??o := DATE2DMY(fechaing, 3);
        IF cala??o MOD 4 = 0 THEN
            refmes := 29
        ELSE
            refmes := 28;
        CASE calmes OF
            1:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(cala??o));
            2:
                EXIT(FORMAT(refmes) + '/' + FORMAT(calmes) + '/' + FORMAT(cala??o));
            3:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(cala??o));
            4:
                EXIT('30/' + FORMAT(calmes) + '/' + FORMAT(cala??o));
            5:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(cala??o));
            6:
                EXIT('30/' + FORMAT(calmes) + '/' + FORMAT(cala??o));
            7:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(cala??o));
            8:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(cala??o));
            9:
                EXIT('30/' + FORMAT(calmes) + '/' + FORMAT(cala??o));
            10:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(cala??o));
            11:
                EXIT('30/' + FORMAT(calmes) + '/' + FORMAT(cala??o));
            12:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(cala??o));
        END;
    end;
}

