report 51044 "Accounts Payable (Group 46)"
{
    //LIBRO 3.13

    // Identify  Nro.  yyyy.MM.dd  Version   Description
    // -----------------------------------------------------
    // ULN::CCL  001   2018.01.31  v.001     LPE
    DefaultLayout = RDLC;
    RDLCLayout = './App/Report/RDLC/Accounts Payable (Group 46).rdl';
    Caption = 'Accounts Payable (Group 46)', Comment = 'ESM="Cuentas por Pagar(Grupo 46)"';
    ProcessingOnly = false;
    UseSystemPrinter = false;

    dataset
    {
        dataitem("Company Information"; "Company Information")
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

            trigger OnPreDataItem()
            begin
                CompanyInfo.GET;
                rucCompany := CompanyInfo."VAT Registration No.";
                Ejercicio := FORMAT(FechaIni) + '..' + FORMAT(FechaFin);
            end;
        }
        dataitem(Integer; Integer)
        {
            column(PaginaInfo; PaginaInfo)
            {
            }
            column(InfoFecha; FechaInfo)
            {
            }
            column(G_L_Account_Name; gMaestroDatosTemp."Descripcion Generico")
            {
            }
            column(G_L_Account_Net_Change_; ABS(SaldoPeriodo))
            {
            }
            column(G_L_Account__No__; gMaestroDatosTemp."Codigo Generico")
            {
            }
            column(ABS_SaldoPeriodo_; ABS(SaldoPeriodo))
            {
            }
            column(ABS_saldototalfinal_; ABS(saldototalfinal))
            {
            }
            column(DENOMINACION_O_RAZON_SOCIAL_Caption; DENOMINACION_O_RAZON_SOCIAL_CaptionLbl)
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
            column(FORMATO_3_13_LIBRO_DE_INVENTARIOS_Y_BALANCES___DETALLE_DEL_SALDO_DE_LA_CUENTA_46___CUENTAS_POR_PAGAR_DIVERSASCaption; FORMATO_3_13_LIBRO_DE_INVENTARIOS_Y_BALANCES___DETALLE_DEL_SALDO_DE_LA_CUENTA_46___CUENTAS_POR_PAGAR_DIVERSASCaptionLbl)
            {
            }
            column(FECHA_DE_LA_EMSION_DEL_COMPROBANTE_DE_PAGOCaption; FECHA_DE_LA_EMSION_DEL_COMPROBANTE_DE_PAGOCaptionLbl)
            {
            }
            column(MONTO_DE_LA_CUENTA_POR_PAGARCaption; MONTO_DE_LA_CUENTA_POR_PAGARCaptionLbl)
            {
            }
            column(DESCRIPCION_DE_LA_OBLIGACIONCaption; DESCRIPCION_DE_LA_OBLIGACIONCaptionLbl)
            {
            }
            column(APELLIDOS_Y_NOMBRESCaption; APELLIDOS_Y_NOMBRESCaptionLbl)
            {
            }
            column(DENOMINACION_O_RAZON_SOCIALCaption; DENOMINACION_O_RAZON_SOCIALCaptionLbl)
            {
            }
            column(INFORMACION_DEL_TERCEROSCaption; INFORMACION_DEL_TERCEROSCaptionLbl)
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
            column(SALDO_FINAL_TOTAL_Caption; SALDO_FINAL_TOTAL_CaptionLbl)
            {
            }
            column(tbool; tBool)
            {
            }
            column(G_L_Entry__G_L_Entry___Posting_Date_; gMaestroDatosTemp."Fecha Envio")
            {
            }
            column(G_L_Entry__G_L_Entry__Description; gMaestroDatosTemp.Description)
            {
            }
            column(nomProveedor; gMaestroDatosTemp."Descripcion Generico")
            {
            }
            column(G_L_Entry__Source_No__; gMaestroDatosTemp.Departamento)
            {
            }
            column(tipoDoc; gMaestroDatosTemp.Departamento)
            {
            }
            column(G_L_Entry__External_Document_No__; gMaestroDatosTemp."Gran Familia")
            {
            }
            column(G_L_Entry_Entry_No_; gMaestroDatosTemp.sequence)
            {
            }
            column(G_L_Entry_G_L_Account_No_; gMaestroDatosTemp."Codigo Generico")
            {
            }
            column(tipodocProv; gMaestroDatosTemp.Departamento)
            {
            }
            column(NombreProv; gMaestroDatosTemp.Description)
            {
            }
            column(ABS__G_L_Entry__Amount_; gMaestroDatosTemp."Importe Rel")
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
            column(Consolidado; gBool)
            {
            }
            column(DocumentNo; gMaestroDatosTemp."Document No.")
            {
            }
            column(NombreVendor; gMaestroDatosTemp."Descripcion Nav")
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
                saldototalfinal := 0;
                tBool := '1';
                gCounter := 1;

                //ULN:PC 13.05.21 ++++++
                gEmployeeLedgerEntry.RESET;
                gEmployeeLedgerEntry.SETFILTER("Date Filter", '%1..%2', 0D, FechaFin);
                gEmployeeLedgerEntry.SETFILTER("Remaining Amt. (LCY)", '<>%1', 0);
                gEmployeeLedgerEntry.SETFILTER("Payables Account", '%1', '46*', '47*');
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
                gCustLedgerEntry.SETFILTER("Receivables Account", '%1|%2', '46*', '47*');
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
                            gMaestroDatosTemp.Description := gCustLedgerEntry.Description;
                            gMaestroDatosTemp."Descripcion Nav" := gCustomer.Name;
                            gMaestroDatosTemp.Departamento := gCustomer."VAT Registration Type";
                            gMaestroDatosTemp."No. Ruc EPS" := gCustomer."VAT Registration No.";
                        END;

                        gMaestroDatosTemp."Document No." := gCustLedgerEntry."Document No.";

                        IF gCustLedgerEntry."External Document No." <> '' THEN
                            gMaestroDatosTemp."Document No." := gCustLedgerEntry."External Document No.";

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
                gVendorLedgerEntry.SETFILTER("Payables Account", '%1|%2', '46*', '47*');
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


                        IF gVendorLedgerEntry."Posting Text" <> '' THEN
                            gMaestroDatosTemp."Descripcion Generico" := gVendorLedgerEntry."Posting Text";

                        //  gVendorLedgerEntry.CALCFIELDS("Text Registro");
                        gMaestroDatosTemp.Description := gVendorLedgerEntry."Posting Text";
                        IF gMaestroDatosTemp.Description = '' THEN
                            gMaestroDatosTemp.Description := gVendorLedgerEntry.Description;

                        gVendor.RESET;
                        gVendor.SETRANGE("No.", gVendorLedgerEntry."Vendor No.");
                        IF gVendor.FINDSET THEN BEGIN
                            gMaestroDatosTemp."Descripcion Nav" := gVendor.Name;
                            gMaestroDatosTemp.Departamento := gVendor."VAT Registration Type";
                            gMaestroDatosTemp."No. Ruc EPS" := gVendor."VAT Registration No.";
                        END;


                        gMaestroDatosTemp."Global Dimension 1 Code" := gVendorLedgerEntry."Global Dimension 1 Code";
                        gMaestroDatosTemp."Global Dimension 2 Code" := gVendorLedgerEntry."Global Dimension 2 Code";
                        gMaestroDatosTemp."Document No." := gVendorLedgerEntry."Document No.";

                        IF gVendorLedgerEntry."External Document No." <> '' THEN
                            gMaestroDatosTemp."Document No." := gVendorLedgerEntry."External Document No.";

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
                    Caption = 'Fecha Inicio del Periodo', Comment = 'ESM="Fecha Inicio del Periodo"';
                }
                field(gBool; gBool)
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
        Ejercicio: Text[30];
        FechaIni: Date;
        FechaFin: Date;
        NombreProv: Text[100];
        gGLEntry: Record "G/L Entry";
        recVendorLE: Record Vendor;
        CompanyInfo: Record "Company Information";
        rucCompany: Text[30];
        text001: Label 'Por favor ingresar la fecha inicio del periodo.';
        FechaPeriodo: Date;
        tipodocProv: Text[30];
        NombreCompany: Text[30];
        text002: Label 'Por favor ingresar la fecha fin del periodo.';
        Mes: Text[30];
        MesPeriodo: Text[30];
        MostrarInfo: Boolean;
        FechaInfo: Text[30];
        PaginaInfo: Text[30];
        UsuarioInfo: Text[30];
        codProveedor: Text[30];
        tipoDoc: Text[30];
        numDoc: Code[20];
        nomProveedor: Text[200];
        recProveedor: Record Vendor;
        recConfigSunat: Record "Master Data";
        FechaImpresion: Date;
        verperiodo: Text[100];
        mescab: Integer;
        mosfr: Boolean;
        saldototal: Decimal;
        saldototalfinal: Decimal;
        recGlEntry: Record "G/L Entry";
        Monto: Decimal;
        SaldoPeriodo: Decimal;
        DENOMINACION_O_RAZON_SOCIAL_CaptionLbl: Label ' DENOMINACION O RAZON SOCIAL:';
        RUC_CaptionLbl: Label 'RUC:';
        EJERCICIO_CaptionLbl: Label 'EJERCICIO:';
        PERIODO_CaptionLbl: Label 'PERIODO:';
        FORMATO_3_13_LIBRO_DE_INVENTARIOS_Y_BALANCES___DETALLE_DEL_SALDO_DE_LA_CUENTA_46___CUENTAS_POR_PAGAR_DIVERSASCaptionLbl: Label 'FORMATO 3.13.LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL SALDO DE LA CUENTA 46 - CUENTAS POR PAGAR DIVERSAS';
        FECHA_DE_LA_EMSION_DEL_COMPROBANTE_DE_PAGOCaptionLbl: Label 'FECHA DE LA EMSION DEL COMPROBANTE DE PAGO';
        MONTO_DE_LA_CUENTA_POR_PAGARCaptionLbl: Label 'MONTO DE LA CUENTA POR PAGAR';
        DESCRIPCION_DE_LA_OBLIGACIONCaptionLbl: Label 'DESCRIPCION DE LA OBLIGACION';
        APELLIDOS_Y_NOMBRESCaptionLbl: Label 'APELLIDOS Y NOMBRES';
        DENOMINACION_O_RAZON_SOCIALCaptionLbl: Label 'DENOMINACION O RAZON SOCIAL';
        INFORMACION_DEL_TERCEROSCaptionLbl: Label 'INFORMACION DEL TERCEROS';
        DOCUMENTO_DE_IDENTIDADCaptionLbl: Label 'DOCUMENTO DE IDENTIDAD';
        NUMEROCaptionLbl: Label 'NUMERO';
        TIPOCaptionLbl: Label 'TIPO';
        SALDO_FINAL_TOTAL_CaptionLbl: Label 'SALDO FINAL TOTAL:';
        recvendor: Record Vendor;
        RemainingAmtLCY: Decimal;
        gBool: Boolean;
        tBool: Text;
        RemainingAmt: Decimal;
        gMaestroDatosTemp: Record "Master Data Buffer" temporary;
        gVendor: Record Vendor;
        gCustomer: Record Customer;
        gVendorLedgerEntry: Record "Vendor Ledger Entry";
        gCustLedgerEntry: Record "Cust. Ledger Entry";
        gEmployeeLedgerEntry: Record "Employee Ledger Entry";
        gEmployee: Record Employee;
        gCounter: Integer;
        gGLAccount: Record "G/L Account";
        gVendorName: Code[100];

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

