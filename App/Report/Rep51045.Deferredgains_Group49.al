report 51045 "Deferred gains (Group 49)"
{
    //LIBRO 3.15

    // Identify  Nro.  yyyy.MM.dd  Version   Description
    // -----------------------------------------------------
    // ULN::CCL  001   2018.01.31  v.001     LPE
    DefaultLayout = RDLC;
    RDLCLayout = './App/Report/RDLC/Deferred gains (Group 49).rdl';
    Caption = 'Deferred gains (Group 49)', Comment = 'ESM="Ganancias Diferidas(Grupo 49)"';
    ProcessingOnly = false;
    UseSystemPrinter = false;

    dataset
    {
        dataitem("Company Information"; "Company Information")
        {
            column(Ejercicio; Ejercicio)
            {
            }
            column(rucCompany; rucCompany)
            {
            }
            column(NombreProv; CompanyInfo.Name)
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
            column(SALDOTOTAL; SALDOTOTAL)
            {
            }
            column(SALDOTOTAL_Control1000000016; SALDOTOTAL)
            {
            }
            column(FORMATO_3_15_LIBRO_DE_INVENTARIOS_Y_BALANCES____DETALLE_DEL_SALDO_DE_LA_CUENTA__49___GANANCIAS_DIFERIDASCaption; FORMATO_3_15_LIBRO_DE_INVENTARIOS_Y_BALANCES____DETALLE_DEL_SALDO_DE_LA_CUENTA__49___GANANCIAS_DIFERIDASCaptionLbl)
            {
            }
            column(EJERCICIO_Caption; EJERCICIO_CaptionLbl)
            {
            }
            column(RUCCaption; RUCCaptionLbl)
            {
            }
            column(APELLIDOS_Y_NOMBRES__DENOMINACION_O_RAZON_SOCIAL_Caption; APELLIDOS_Y_NOMBRES__DENOMINACION_O_RAZON_SOCIAL_CaptionLbl)
            {
            }
            column(PERIODOCaption; PERIODOCaptionLbl)
            {
            }
            column(NUMERO_DE_COMPROBANTE_DE_PAGO_RELACIONADOCaption; NUMERO_DE_COMPROBANTE_DE_PAGO_RELACIONADOCaptionLbl)
            {
            }
            column(CONCEPTOCaption; CONCEPTOCaptionLbl)
            {
            }
            column(SALDOCaption; SALDOCaptionLbl)
            {
            }
            column(SALDO_FINAL_TOTAL_Caption; SALDO_FINAL_TOTAL_CaptionLbl)
            {
            }
            column(SALDO_FINAL_TOTAL_Caption_Control1000000014; SALDO_FINAL_TOTAL_Caption_Control1000000014Lbl)
            {
            }
            column(G_L_Account_No_; gMaestroDatosTemp."Codigo Generico")
            {
            }
            column(G_L_Entry_Amount; gMaestroDatosTemp."Importe Rel")
            {
            }
            column(G_L_Entry_Description; gMaestroDatosTemp.Description)
            {
            }
            column(G_L_Entry__G_L_Entry___Document_No__; gMaestroDatosTemp."Document No.")
            {
            }
            column(G_L_Entry_Entry_No_; gMaestroDatosTemp.sequence)
            {
            }
            column(G_L_Entry_G_L_Account_No_; gMaestroDatosTemp."Codigo Generico")
            {
            }
            column(PostingDate_GLEntry; gMaestroDatosTemp."Fecha Envio")
            {
            }
            column(DescripcionCuenta; gMaestroDatosTemp."Descripcion Generico")
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
                gCounter := 1;
                gCustLedgerEntry.RESET;
                gCustLedgerEntry.SETFILTER("Date Filter", '%1..%2', 0D, FechaFin);
                gCustLedgerEntry.SETFILTER("Remaining Amt. (LCY)", '<>%1', 0);
                gCustLedgerEntry.SETFILTER("Receivables Account", '%1|%2', '49*', '37*');
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
                gVendorLedgerEntry.SETFILTER("Payables Account", '%1|%2', '49*', '37*');
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

                gGLEntry.RESET;
                gGLEntry.SETRANGE("Posting Date", FechaIni, FechaFin);
                gGLEntry.SETFILTER("G/L Account No.", '%1', '37*');
                gGLEntry.SETRANGE(Reversed, FALSE);
                IF gGLEntry.FINDSET THEN
                    REPEAT
                        gGLAccount.GET(gGLEntry."G/L Account No.");
                        gCounter += 1;
                        gMaestroDatosTemp.INIT;
                        gMaestroDatosTemp."No. Mov." := gCounter;
                        gMaestroDatosTemp."Codigo Nav" := gGLEntry."Source No.";
                        gMaestroDatosTemp."Descripcion Generico" := gGLAccount.Name;
                        gMaestroDatosTemp."Codigo Generico" := gGLAccount."No.";
                        gMaestroDatosTemp."Cod. Pais" := 'S/';
                        gVendor.RESET;
                        gVendor.SETRANGE("No.", gGLEntry."Source No.");
                        IF gVendor.FINDSET THEN BEGIN
                            gMaestroDatosTemp.Description := gVendor.Name;
                            gMaestroDatosTemp.Departamento := gVendor."VAT Registration Type";
                            gMaestroDatosTemp."No. Ruc EPS" := gVendor."VAT Registration No.";
                        END;
                        gCustomer.RESET;
                        gCustomer.SETRANGE("No.", gGLEntry."Source No.");
                        IF gCustomer.FINDSET THEN BEGIN
                            gMaestroDatosTemp.Description := gCustomer.Name;
                            gMaestroDatosTemp.Departamento := gCustomer."VAT Registration Type";
                            gMaestroDatosTemp."No. Ruc EPS" := gCustomer."VAT Registration No.";
                        END;
                        IF gMaestroDatosTemp.Description = '' THEN
                            gMaestroDatosTemp.Description := gGLEntry.Description;
                        gMaestroDatosTemp."Global Dimension 1 Code" := gGLEntry."Global Dimension 1 Code";
                        gMaestroDatosTemp."Global Dimension 2 Code" := gGLEntry."Global Dimension 2 Code";
                        gMaestroDatosTemp."Document No." := gGLEntry."Document No.";
                        gMaestroDatosTemp."Fecha Envio" := gGLEntry."Document Date";
                        gMaestroDatosTemp.sequence := gGLEntry."Entry No.";
                        gMaestroDatosTemp."Importe Base" := gGLEntry.Amount;
                        gMaestroDatosTemp."Importe Rel" := gGLEntry.Amount;
                        gMaestroDatosTemp."Gran Familia" := gGLEntry."External Document No.";
                        gMaestroDatosTemp.INSERT;
                    UNTIL gGLEntry.NEXT = 0;

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
                    MultiLine = false;

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
                    Caption = 'Aref', Comment = 'ESM="Aref"';
                    ShowCaption = true;
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
                    Caption = 'Fecha inicio', Comment = 'ESM="Fecha inicio"';
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
                    Caption = 'Fecha Inicio de Periodo', Comment = 'ESM="Fecha Inicio de Periodo"';
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
        NombreProv: Text[100];
        recVendor: Record Vendor;
        CompanyInfo: Record "Company Information";
        rucCompany: Text[30];
        text001: Label 'Por favor Ingresar la Fecha Inicio del Periodo';
        FechaPeriodo: Date;
        text002: Label 'Por favor Ingresar la Fecha Fin del Periodo';
        Mes: Text[30];
        MesPeriodo: Text[30];
        MostrarInfo: Boolean;
        FechaInfo: Text[30];
        PaginaInfo: Text[30];
        UsuarioInfo: Text[30];
        FechaImpresion: Date;
        verperiodo: Text[100];
        mescab: Integer;
        mosfr: Boolean;
        FORMATO_3_15_LIBRO_DE_INVENTARIOS_Y_BALANCES____DETALLE_DEL_SALDO_DE_LA_CUENTA__49___GANANCIAS_DIFERIDASCaptionLbl: Label 'FORMATO 3.15.LIBRO DE INVENTARIOS Y BALANCES -  DETALLE DEL SALDO DE LA CUENTA  49 - GANANCIAS DIFERIDAS';
        EJERCICIO_CaptionLbl: Label 'EJERCICIO:';
        RUCCaptionLbl: Label 'RUC';
        APELLIDOS_Y_NOMBRES__DENOMINACION_O_RAZON_SOCIAL_CaptionLbl: Label 'APELLIDOS Y NOMBRES, DENOMINACION O RAZON SOCIAL:';
        PERIODOCaptionLbl: Label 'PERIODO';
        NUMERO_DE_COMPROBANTE_DE_PAGO_RELACIONADOCaptionLbl: Label 'NUMERO DE COMPROBANTE DE PAGO RELACIONADO';
        CONCEPTOCaptionLbl: Label 'CONCEPTO';
        SALDOCaptionLbl: Label 'SALDO';
        SALDO_FINAL_TOTAL_CaptionLbl: Label 'SALDO FINAL TOTAL:';
        SALDO_FINAL_TOTAL_Caption_Control1000000014Lbl: Label 'SALDO FINAL TOTAL:';
        gMaestroDatosTemp: Record "Master Data Buffer" temporary;
        gVendor: Record Vendor;
        gCustomer: Record Customer;
        gVendorLedgerEntry: Record "Vendor Ledger Entry";
        gCustLedgerEntry: Record "Cust. Ledger Entry";
        gCounter: Integer;
        gGLAccount: Record "G/L Account";
        gGLEntry: Record "G/L Entry";

    procedure FunctionFechaFin(fechaing: Date): Text[30]
    var
        calmes: Integer;
        calano: Integer;
        refmes: Integer;
    begin
        calmes := DATE2DMY(fechaing, 2);
        calano := DATE2DMY(fechaing, 3);
        IF calano MOD 4 = 0 THEN
            refmes := 29
        ELSE
            refmes := 28;
        CASE calmes OF
            1:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calano));
            2:
                EXIT(FORMAT(refmes) + '/' + FORMAT(calmes) + '/' + FORMAT(calano));
            3:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calano));
            4:
                EXIT('30/' + FORMAT(calmes) + '/' + FORMAT(calano));
            5:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calano));
            6:
                EXIT('30/' + FORMAT(calmes) + '/' + FORMAT(calano));
            7:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calano));
            8:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calano));
            9:
                EXIT('30/' + FORMAT(calmes) + '/' + FORMAT(calano));
            10:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calano));
            11:
                EXIT('30/' + FORMAT(calmes) + '/' + FORMAT(calano));
            12:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calano));
        END;
    end;

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
}

