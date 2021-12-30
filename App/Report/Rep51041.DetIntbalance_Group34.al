report 51041 "Det.Int.balance(Group 34)"
{
    //LIBRO 3.9

    // Identify  Nro.  yyyy.MM.dd  Version   Description
    // -----------------------------------------------------
    // ULN::CCL  001   2018.01.30  v.001     LPE
    DefaultLayout = RDLC;
    RDLCLayout = './App/Report/RDLC/Det.Int.balance(Group 34).rdl';
    Caption = 'Det. Intangible balance (Group 34)', Comment = 'ESM="Det.Saldo Intangib(Grupo 34)"';

    dataset
    {
        dataitem("Fixed Asset"; "Fixed Asset")
        {
            DataItemTableView = SORTING("FA Class Code")
                                ORDER(Ascending)
                                WHERE(Blocked = CONST(false));
            RequestFilterFields = "No.";
            column(CompanyInfo_Name; CompanyInfo.Name)
            {
            }
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
            column("APELLIDOS_Y_NOMBRES__DENOMINACIÛN_O_RAZÛN_SOCIAL_Caption"; APELLIDOS_Y_NOMBRES__DENOMINACIÛN_O_RAZÛN_SOCIAL_CaptionLbl)
            {
            }
            column(FORMATO_3_9_LIBRO_DE_INVENTARIOS_Y_BALANCES___DETALLE_DEL_SALDO_DE_LA_CUENTA_34___INTANGIBLESCaption; FORMATO_3_9_LIBRO_DE_INVENTARIOS_Y_BALANCES___DETALLE_DEL_SALDO_DE_LA_CUENTA_34___INTANGIBLESCaptionLbl)
            {
            }
            column(RUCCaption; RUCCaptionLbl)
            {
            }
            column(EJERCICIO_Caption; EJERCICIO_CaptionLbl)
            {
            }
            column(PERIODO_Caption; PERIODO_CaptionLbl)
            {
            }
            column(VALOR_NETO_CONTABLE_DEL_INTANGIBLECaption; VALOR_NETO_CONTABLE_DEL_INTANGIBLECaptionLbl)
            {
            }
            column("AMORTIZACIÛN_CONTABLE_ACUMULADACaption"; AMORTIZACIÛN_CONTABLE_ACUMULADACaptionLbl)
            {
            }
            column(VALOR_CONTABLE_DEL_INTANGIBLECaption; VALOR_CONTABLE_DEL_INTANGIBLECaptionLbl)
            {
            }
            column(TIPO_DE_INTANGIBLECaption; TIPO_DE_INTANGIBLECaptionLbl)
            {
            }
            column("DESCRIPCIÛN_DEL_INTANGIBLECaption"; DESCRIPCIÛN_DEL_INTANGIBLECaptionLbl)
            {
            }
            column(FECHA_INICIO_DE_LA_OPERACIONCaption; FECHA_INICIO_DE_LA_OPERACIONCaptionLbl)
            {
            }
            column(Fixed_Asset_No_; "No.")
            {
            }
            dataitem("FA Depreciation Book"; "FA Depreciation Book")
            {
                DataItemLink = "FA No." = FIELD("No.");
                RequestFilterFields = "Depreciation Book Code";

                trigger OnAfterGetRecord()
                begin

                    "FA Depreciation Book".CALCFIELDS("FA Depreciation Book"."Book Value");

                    LibroAmortizacion := "FA Depreciation Book"."Depreciation Book Code";

                    ValorNetoIntangible := "FA Depreciation Book"."Book Value";
                    TotValorNetoIntangible := TotValorNetoIntangible + ValorNetoIntangible;
                end;
            }
            dataitem("FA Ledger Entry"; "FA Ledger Entry")
            {
                DataItemLink = "FA No." = FIELD("No.");
                DataItemTableView = SORTING("FA No.", "Depreciation Book Code", "FA Posting Date")
                                    ORDER(Ascending);
                column(TipoIntangible; TipoIntangible)
                {
                }
                column(ValorContableIntangible; ValorContableIntangible)
                {
                }
                column(AmortizacionAcumulada; AmortizacionAcumulada)
                {
                }
                column(ValorNetoIntangible; ValorNetoIntangible)
                {
                }
                column(NombreIntangible; NombreIntangible)
                {
                }
                column(FechaInicioAmortiza; FechaInicioAmortiza)
                {
                }
                column(FA_Ledger_Entry_Entry_No_; "Entry No.")
                {
                }
                column(FA_Ledger_Entry_FA_No_; "FA No.")
                {
                }
                column(gFANO; gFANO)
                {
                }
                column(Descripcion; gNombreCuenta)
                {
                }
                column(NroMovimiento; gNroMovimiento)
                {
                }
                column(gNroActivoFijo; gNroActivoFijo)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    ValorContableIntangible := 0;

                    gGLEntry.SETFILTER(gGLEntry."G/L Account No.", '%1|%2', '34*', '392*');
                    gGLEntry.SETRANGE(gGLEntry."Entry No.", "FA Ledger Entry"."G/L Entry No.");
                    gGLEntry.SETRANGE(gGLEntry."Posting Date", 0D, FechaFin);
                    IF gGLEntry.FINDSET THEN BEGIN
                        gNroMovimiento := "FA Ledger Entry"."Entry No.";
                        gNroActivoFijo := "FA Ledger Entry"."FA No.";

                        IF gNroActivoFijo = 'PRGC-N000005' THEN BEGIN
                            gNroMovimiento := "FA Ledger Entry"."Entry No.";
                            gNroActivoFijo := "FA Ledger Entry"."FA No.";
                        END;

                        AmortizacionAcumulada := 0.0;
                        lclAcumulated := 0;
                        lclFALedgerEntry2.RESET;
                        lclFALedgerEntry2.SETRANGE("FA No.", "FA Ledger Entry"."FA No.");
                        lclFALedgerEntry2.SETRANGE("Posting Date", 0D, FechaFin);
                        lclFALedgerEntry2.SETRANGE("FA Posting Type", lclFALedgerEntry2."FA Posting Type"::Depreciation);
                        IF lclFALedgerEntry2.FINDSET THEN
                            REPEAT
                                lclAcumulated := lclAcumulated + ABS(lclFALedgerEntry2.Amount);
                            UNTIL lclFALedgerEntry2.NEXT = 0;

                        IF lclAcumulated <> 0 THEN BEGIN
                            AmortizacionAcumulada := lclAcumulated;
                        END ELSE BEGIN
                            AmortizacionAcumulada := 0.0;
                        END;

                        IF "FA Posting Type" = "FA Posting Type"::"Acquisition Cost" THEN BEGIN
                            ValorContableIntangible := ("FA Ledger Entry".Amount);
                            TotValorContableIntangible := TotValorContableIntangible + ValorContableIntangible;
                        END;

                        gGLEntry.RESET;
                        gGLEntry.SETFILTER(gGLEntry."G/L Account No.", '%1|%2', '34*', '392*');
                        gGLEntry.SETRANGE(gGLEntry."Entry No.", "FA Ledger Entry"."G/L Entry No.");
                        gGLEntry.SETRANGE(gGLEntry."Posting Date", 0D, FechaFin);
                        IF gGLEntry.FINDSET THEN BEGIN
                            gFANO := gGLEntry."G/L Account No.";
                            gNombreCuenta := gGLEntry.Description;
                            FechaInicioAmortiza := gGLEntry."Posting Date";
                        END;

                    END;
                end;

                trigger OnPostDataItem()
                begin
                    TotAmortizacionAcumulada := TotAmortizacionAcumulada + AmortizacionAcumulada
                end;

                trigger OnPreDataItem()
                begin
                    AmortizacionAcumulada := 0;
                    ValorContableIntangible := 0;
                    SETRANGE("FA Ledger Entry"."Depreciation Book Code", LibroAmortizacion);
                    SETRANGE("Posting Date", 0D, FechaFin);
                    //BEGIN ULN::CCL 001 --
                    //SETFILTER("Cuenta Costo",'%1','34*');
                    //END ULN::CCL 001 --
                    SETFILTER("FA Posting Type", '%1', "FA Posting Type"::"Acquisition Cost");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                NombreIntangible := "Fixed Asset".Description;
                TipoIntangible := '';
            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.GET;
                rucCompany := CompanyInfo."VAT Registration No.";

                Ejercicio := FORMAT(FechaIni) + '..' + FORMAT(FechaFin);

                IF FechaIni = 0D THEN
                    ERROR(text001);

                IF FechaFin = 0D THEN
                    ERROR(text002);

                FechaFin := CLOSINGDATE(FechaFin);
                TotValorContableIntangible := 0;
                TotAmortizacionAcumulada := 0;
                TotValorNetoIntangible := 0;
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

    var
        NombreCompany: Text[30];
        rucCompany: Text[30];
        Ejercicio: Text[30];
        CompanyInfo: Record "Company Information";
        FechaIni: Date;
        FechaFin: Date;
        text001: Label 'Ingrese la Fecha de Inicio del Periodo';
        text002: Label '<Ingrese la Fecha Fin del Periodo>';
        FechaInicioAmortiza: Date;
        NombreIntangible: Text[250];
        TipoIntangible: Text[100];
        ValorContableIntangible: Decimal;
        AmortizacionAcumulada: Decimal;
        ValorNetoIntangible: Decimal;
        TotValorContableIntangible: Decimal;
        TotAmortizacionAcumulada: Decimal;
        TotValorNetoIntangible: Decimal;
        Mes: Text[30];
        MesPeriodo: Text[30];
        MostrarInfo: Boolean;
        FechaInfo: Text[30];
        PaginaInfo: Text[30];
        UsuarioInfo: Text[30];
        recConfigSunat: Record "Master Data";
        LibroAmortizacion: Text[30];
        FechaImpresion: Date;
        verperiodo: Text[100];
        mescab: Integer;
        mosfr: Boolean;
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
        "APELLIDOS_Y_NOMBRES__DENOMINACIÛN_O_RAZÛN_SOCIAL_CaptionLbl": Label 'APELLIDOS Y NOMBRES, DENOMINACIÛN O RAZÛN SOCIAL:';
        FORMATO_3_9_LIBRO_DE_INVENTARIOS_Y_BALANCES___DETALLE_DEL_SALDO_DE_LA_CUENTA_34___INTANGIBLESCaptionLbl: Label 'FORMATO 3.9.LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL SALDO DE LA CUENTA 34 - INTANGIBLES';
        RUCCaptionLbl: Label 'RUC:';
        EJERCICIO_CaptionLbl: Label 'EJERCICIO:';
        PERIODO_CaptionLbl: Label 'PERIODO:';
        VALOR_NETO_CONTABLE_DEL_INTANGIBLECaptionLbl: Label 'VALOR NETO CONTABLE DEL INTANGIBLE';
        "AMORTIZACIÛN_CONTABLE_ACUMULADACaptionLbl": Label 'AMORTIZACIÛN CONTABLE ACUMULADA';
        VALOR_CONTABLE_DEL_INTANGIBLECaptionLbl: Label 'VALOR CONTABLE DEL INTANGIBLE';
        TIPO_DE_INTANGIBLECaptionLbl: Label 'TIPO DE INTANGIBLE';
        "DESCRIPCIÛN_DEL_INTANGIBLECaptionLbl": Label 'DESCRIPCIÛN DEL INTANGIBLE';
        FECHA_INICIO_DE_LA_OPERACIONCaptionLbl: Label 'FECHA INICIO DE LA OPERACION';
        gFANO: Text;
        gGLEntry: Record "G/L Entry";
        gNombreCuenta: Code[45];
        gNroMovimiento: Integer;
        gNroActivoFijo: Code[35];
        lclFALedgerEntry2: Record "FA Ledger Entry";
        lclAcumulated: Decimal;

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

