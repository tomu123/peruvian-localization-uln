report 51053 "Detalle de Activo Fijo"
{
    //LIBRO 7.1
    // Identify  Nro.  yyyy.MM.dd  Version   Description
    // -----------------------------------------------------
    // ULN::PC   001   2021.07.05    V.1     Peruvian Books (Copy From MT )
    DefaultLayout = RDLC;
    RDLCLayout = './App/Report/RDLC/Detalle de Activo Fijo.rdl';
    dataset
    {
        dataitem("FA Ledger Entry"; "FA Ledger Entry")
        {
            RequestFilterFields = "No. of Depreciation Days", "FA Posting Group";
            column(MesPeriodo; MesPeriodo)
            {
            }
            column(Ruc; ruc)
            {
            }
            column(Name; name)
            {
            }
            column(cuenta; cuenta)
            {
            }
            column(SaldoInicial; SaldoInicial)
            {
            }
            column(AdqAdd; AdqAdd)
            {
            }
            column(No; "FA Ledger Entry"."FA No.")
            {
            }
            column(Impmejoras; Impmejoras)
            {
            }
            column(ImpBaja; ImpBaja)
            {
            }
            column(ImpOtroAj; ImpOtroAj)
            {
            }
            column(ValorHistorial; SaldoInicial + AdqAdd + Impmejoras + ImpBaja + ImpOtroAj)
            {
            }
            column(FechaAdq; FORMAT(FechaAdq, 0))
            {
            }
            column(FechaUso; FORMAT(FechaUso, 0))
            {
            }
            column(Method; Method)
            {
            }
            column(Straight; Straight)
            {
            }
            column(importeLastYear; importeLastYear)
            {
            }
            column(ImpDepEjercAct; ImpDepEjercAct)
            {
            }
            column(ImpBajaEjerAct; ImpBajaEjerAct)
            {
            }
            column(DepHistorico; importeLastYear + ImpDepEjercAct + ImpBajaEjerAct)
            {
            }
            column(gTipoAmt; gTipoAmt)
            {
            }
            column(Descripcion; gDescripcion)
            {
            }
            column(Marca; gMarca)
            {
            }
            column(Modelo; gModelo)
            {
            }
            column(NoSerie; gSerie)
            {
            }
            column(Fecha_Amort; "FA Ledger Entry"."Depreciation Starting Date")
            {
            }
            column(FechaUso2; FechaUso2)
            {
            }

            trigger OnAfterGetRecord()
            begin

                glAdqGroup := '';
                glRecDepBook.RESET;
                glRecDepBook.SETRANGE("FA No.", "FA Ledger Entry"."FA No.");
                IF glRecDepBook.FINDSET THEN BEGIN
                    FechaUso2 := glRecDepBook."Depreciation Starting Date";
                    IF glPostingGroup.GET(glRecDepBook."FA Posting Group") THEN BEGIN
                        glAdqGroup := COPYSTR(glPostingGroup."Acquisition Cost Account", 1, 2);
                    END;
                END;



                IF (glAdqGroup = '33') AND ("FA Ledger Entry"."Transaction No." > 0) THEN BEGIN
                    glRecDepBook.RESET;
                    glRecDepBook.SETRANGE("FA No.", "FA Ledger Entry"."FA No.");
                    IF glRecDepBook.FINDSET THEN BEGIN
                        glPostingGroup.GET(glRecDepBook."FA Posting Group");
                    END;

                    IF STRLEN(glPostingGroup."Acquisition Cost Account") > 24 THEN BEGIN
                        glPostingGroup."Acquisition Cost Account" := COPYSTR(glPostingGroup."Acquisition Cost Account", 1, 24);
                    END;
                    cuenta := glPostingGroup."Acquisition Cost Account";

                    glActivoFijo.RESET;
                    glActivoFijo.SETRANGE("No.", "FA Ledger Entry"."FA No.");
                    IF glActivoFijo.FINDSET THEN BEGIN
                        IF STRLEN(glActivoFijo.Description) > 40 THEN BEGIN
                            glActivoFijo.Description := COPYSTR(glActivoFijo.Description, 1, 40);
                        END;
                        gDescripcion := glActivoFijo.Description;
                    END ELSE BEGIN
                        gDescripcion := '';
                    END;

                    IF glActivoFijo."LD Brand" = '' THEN BEGIN
                        gMarca := '-';
                    END ELSE BEGIN
                        IF STRLEN(glActivoFijo."LD Brand") > 20 THEN BEGIN
                            glActivoFijo."LD Brand" := COPYSTR(glActivoFijo."LD Brand", 1, 20);
                        END;
                        gMarca := glActivoFijo."LD Brand";
                    END;

                    //--[Modelo del Activo Fijo]
                    IF glActivoFijo."LD Model" = '' THEN BEGIN
                        gModelo := '-';
                    END ELSE BEGIN
                        IF STRLEN(glActivoFijo."LD Model") > 20 THEN BEGIN
                            glActivoFijo."LD Model" := COPYSTR(glActivoFijo."LD Model", 1, 20);
                        END;
                        gModelo := glActivoFijo."LD Model";
                    END;

                    //--[Número de serie y/o placa del Activo Fijo]
                    IF glActivoFijo."No. Series" = glActivoFijo.Plate THEN BEGIN
                        IF glActivoFijo."No. Series" = '' THEN BEGIN
                            gSerie := '-';
                        END ELSE BEGIN
                            IF STRLEN(glActivoFijo."No. Series") > 30 THEN BEGIN
                                glActivoFijo."No. Series" := COPYSTR(glActivoFijo."No. Series", 1, 30);
                            END;
                            gSerie := glActivoFijo."No. Series";
                        END;
                    END ELSE BEGIN
                        IF (glActivoFijo."No. Series" <> '') AND (glActivoFijo.Plate = '') THEN BEGIN
                            gSerie := glActivoFijo."No. Series";
                        END ELSE BEGIN
                            IF (glActivoFijo."No. Series" = '') AND (glActivoFijo.Plate <> '') THEN BEGIN
                                gSerie := glActivoFijo.Plate;
                            END ELSE BEGIN
                                gSerie := glActivoFijo."No. Series";
                            END;
                        END;
                    END;

                    //--[Importe del saldo inicial del Activo Fijo]
                    SaldoInicial := 0;
                    glSaldoInicial := 0;
                    glLedgerEntry2.RESET;
                    glLedgerEntry2.SETRANGE("FA No.", "FA Ledger Entry"."FA No.");
                    glLedgerEntry2.SETRANGE("FA Posting Date", 0D, glAnioAnterior);
                    IF glLedgerEntry2.FINDSET THEN
                        REPEAT
                            IF glLedgerEntry2."FA Posting Type" = glLedgerEntry2."FA Posting Type"::"Acquisition Cost" THEN BEGIN
                                glSaldoInicial += glLedgerEntry2.Amount;
                            END;
                        UNTIL glLedgerEntry2.NEXT = 0;
                    SaldoInicial := glSaldoInicial;

                    //--[Importe de las adquisiciones o adiciones de Activo Fijo]
                    AdqAdd := 0;
                    glAdquisicionesAdd := 0;
                    glLedgerEntry2.RESET;
                    glLedgerEntry2.SETRANGE("FA No.", "FA Ledger Entry"."FA No.");
                    glLedgerEntry2.SETRANGE("FA Posting Date", fechainicio, fechafin);
                    IF glLedgerEntry2.FINDSET THEN
                        REPEAT
                            IF glLedgerEntry2."FA Posting Type" = glLedgerEntry2."FA Posting Type"::"Acquisition Cost" THEN BEGIN
                                glAdquisicionesAdd += glLedgerEntry2.Amount;
                            END;
                        UNTIL glLedgerEntry2.NEXT = 0;
                    AdqAdd := glAdquisicionesAdd;

                    //--[Importe de las mejoras del Activo Fijo]
                    Impmejoras := 0;
                    glImpMejoras := 0;
                    IF ("FA Ledger Entry"."FA Posting Type" = 3) AND (DATE2DMY("FA Ledger Entry"."FA Posting Date", 3) = DATE2DMY(fechafin, 3)) THEN BEGIN
                        glImpMejoras := "FA Ledger Entry".Amount;
                    END;
                    Impmejoras := glImpMejoras;

                    //--[Importe de los retiros y/o bajas del Activo Fijo]
                    glImpBaja := 0;
                    IF ("FA Ledger Entry"."FA Posting Type" = "FA Ledger Entry"."FA Posting Type"::"Proceeds on Disposal") THEN BEGIN
                        glImpBaja := "FA Ledger Entry".Amount;
                    END;

                    IF ("FA Ledger Entry"."FA Posting Type" = "FA Ledger Entry"."FA Posting Type"::"Acquisition Cost") AND ("FA Ledger Entry"."Document Type" = "FA Ledger Entry"."Document Type"::"Credit Memo") THEN BEGIN
                        glImpBaja := ABS("FA Ledger Entry".Amount);
                    END;
                    ImpBaja := glImpBaja;

                    //--[Importe por otros ajustes en el valor del Activo Fijo]
                    glImpAjustes := 0;
                    IF "FA Ledger Entry"."FA Posting Type" = "FA Ledger Entry"."FA Posting Type"::"Salvage Value" THEN BEGIN
                        glImpAjustes := "FA Ledger Entry".Amount;
                    END;
                    ImpOtroAj := glImpAjustes;

                    //--[Fecha de adquisición del Activo Fijo]
                    FechaAdq := "FA Ledger Entry"."Document Date";


                    //--[Fecha de inicio del Uso del Activo Fijo]
                    FechaUso := "FA Ledger Entry"."FA Posting Date";

                    //--[Código del Método aplicado en el cálculo de la depreciación]
                    Method := FORMAT("FA Ledger Entry"."Depreciation Method");//'1';

                    glRecDepBook.RESET;
                    glRecDepBook.SETRANGE("FA No.", "FA Ledger Entry"."FA No.");
                    IF glRecDepBook.FINDSET THEN BEGIN
                        Straight := glRecDepBook."ST Equivalence Year %";
                    END;


                    //--[Depreciación acumulada al cierre del ejercicio anterior.]
                    glDepAcumAnterior := 0;
                    glLedgerEntry2.RESET;
                    glLedgerEntry2.SETRANGE("FA No.", "FA Ledger Entry"."FA No.");
                    glLedgerEntry2.SETFILTER("FA Posting Date", '<=%1', glAnioAnterior);
                    IF glLedgerEntry2.FINDSET THEN
                        REPEAT
                            IF glLedgerEntry2."FA Posting Type" = glLedgerEntry2."FA Posting Type"::Depreciation THEN BEGIN//IF "FA Ledger Entry"2."FA Posting Type" = "FA Ledger Entry"2."FA Posting Type"::"Write-Down" THEN BEGIN
                                glDepAcumAnterior += ABS(glLedgerEntry2.Amount);
                            END;
                        UNTIL glLedgerEntry2.NEXT = 0;
                    importeLastYear := glDepAcumAnterior;

                    //--[Valor de la depreciación del ejercicio sin considerar la revaluación]
                    glDepEjer := 0;
                    glLedgerEntry2.RESET;
                    glLedgerEntry2.SETRANGE("FA No.", "FA Ledger Entry"."FA No.");
                    glLedgerEntry2.SETRANGE("FA Posting Date", fechainicio, fechafin);
                    "FA Ledger Entry"."FA Posting Date" := "FA Ledger Entry"."FA Posting Date";
                    IF glLedgerEntry2.FINDSET THEN
                        REPEAT
                            IF glLedgerEntry2."FA Posting Type" = glLedgerEntry2."FA Posting Type"::Depreciation THEN BEGIN
                                glDepEjer += ABS(glLedgerEntry2.Amount);
                            END;
                        UNTIL glLedgerEntry2.NEXT = 0;
                    ImpDepEjercAct := glDepEjer;

                    //--[Valor de la depreciación del ejercicio relacionada con los retiros y/o bajas del Activo Fijo]
                    glDepBaja := 0;
                    ImpBajaEjerAct := 0;

                END ELSE BEGIN
                    CurrReport.SKIP;
                END;

                IF (OLDFaNo_ <> "FA Ledger Entry"."FA No.") THEN BEGIN
                    gContador += 1;

                END ELSE BEGIN
                    CurrReport.SKIP;
                END;

                OLDFaNo_ := "FA Ledger Entry"."FA No.";

                IF CGCAF <> '' THEN BEGIN
                    IF cuenta <> CGCAF THEN
                        CurrReport.SKIP;
                END;
            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.GET();
                name := CompanyInfo.Name;
                ruc := CompanyInfo."VAT Registration No.";

                FGroup := "FA Ledger Entry".GETFILTER("FA Posting Group");

                IF fechainicio = 0D THEN
                    ERROR('Ingresar Fecha de Inicio');

                IF fechafin = 0D THEN
                    ERROR('Ingresar Fecha Final.');

                glAnioAnterior := DMY2DATE(31, 12, (DATE2DMY(NORMALDATE(fechafin), 3)) - 1);

                RESET;
                SETRANGE("FA Posting Date", 0D, fechafin);
                IF FGroup <> '' THEN
                    SETFILTER("FA Ledger Entry"."FA Posting Group", '%1', FGroup);
                SETCURRENTKEY("FA No.");
                SETASCENDING("FA No.", TRUE);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Fecha Fin Proceso"; FechadeProceso)
                {
                }
                field("Codigo Libro Amortizacion"; CodBookSec)
                {
                    TableRelation = "Depreciation Book";
                }
                field(Periodo; MesPeriodo)
                {
                }
                field("Fecha Impresion"; FechaImpresion)
                {
                }
                field("Cuenta Contable AF"; CGCAF)
                {
                    TableRelation = "G/L Account"."No." WHERE("No." = CONST('3*'),
                                                             "Account Type" = FILTER(Posting));
                }
                field("Filtro Fecha Compra Inicial"; FiltroFechaCompraIni)
                {
                }
                field("Filtro Fecha Compra Final"; FiltroFechaCompraFin)
                {
                }
                field("Mostrar Inf. Audit."; MostrarInfo)
                {
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            MostrarInfo := TRUE;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        year := DATE2DMY(FechadeProceso, 3);
        fechainicio := DMY2DATE(1, 1, year);
        fechafin := FechadeProceso;

        periodo := FORMAT(fechainicio, 0, 4) + ' AL ' + FORMAT(FechadeProceso, 0, 4);

        LastYearStartDate := CALCDATE('<-1Y>', NORMALDATE(fechainicio) + 1) - 1;
        LastYearEndDate := CALCDATE('<-1Y>', NORMALDATE(DMY2DATE(31, 12, year)) + 1) - 1;

        IF FiscalYearStartDate <> NORMALDATE(fechainicio) THEN
            LastYearStartDate := CLOSINGDATE(LastYearStartDate);

        IF FiscalYearEndDate <> NORMALDATE(fechafin) THEN
            LastYearEndDate := CLOSINGDATE(LastYearEndDate);

        IF MostrarInfo THEN BEGIN
            FechaInfo := FORMAT(FechaImpresion, 0, 4);
            PaginaInfo := 'Página: ' + FORMAT(CurrReport.PAGENO);
            UsuarioInfo := USERID;
        END
    end;

    var
        recLedgerEntry: Record "FA Ledger Entry";
        recFAPostingGroup: Record "FA Posting Group";
        CompanyInfo: Record "Company Information";
        recDepBook: Record "FA Depreciation Book";
        CodBookSec: Code[10];
        MostrarInfo: Boolean;
        CGCAF: Code[20];
        name: Text[50];
        ruc: Text[50];
        cuenta: Text[30];
        FechaUso: Date;
        Method: Text[30];
        periodo: Text[100];
        MesPeriodo: Text[30];
        FechaInfo: Text[30];
        PaginaInfo: Text;
        UsuarioInfo: Text;
        FechaImpresion: Date;
        fechainicio: Date;
        fechafin: Date;
        FiltroFechaCompraIni: Date;
        FiltroFechaCompraFin: Date;
        FechadeProceso: Date;
        FechaAdq: Date;
        LastYearStartDate: Date;
        LastYearEndDate: Date;
        FiscalYearEndDate: Date;
        FiscalYearStartDate: Date;
        Impmejoras: Decimal;
        importeLastYear: Decimal;
        ImpBajaEjerAct: Decimal;
        ImpOtroAj: Decimal;
        ImpBaja: Decimal;
        AdqAdd: Decimal;
        ImpDepEjercAct: Decimal;
        importe: Decimal;
        SaldoInicial: Decimal;
        Straight: Decimal;
        year: Integer;
        gTipoCambio: Decimal;
        gCurrExchRate: Record "Currency Exchange Rate";
        gTipoAmt: Decimal;
        glAdqGroup: Text;
        glRecDepBook: Record "FA Depreciation Book";
        glPostingGroup: Record "FA Posting Group";
        glActivoFijo: Record "Fixed Asset";
        glSaldoInicial: Decimal;
        glLedgerEntry2: Record "FA Ledger Entry";
        glAdquisicionesAdd: Decimal;
        glImpMejoras: Decimal;
        glImpBaja: Decimal;
        glImpAjustes: Decimal;
        glLineaDiarioGeneral: Record "Gen. Journal Line";
        glPorcentajeDep: Decimal;
        glDepAcumAnterior: Decimal;
        glDepEjer: Decimal;
        glDepBaja: Decimal;
        glAnioAnterior: Date;
        gDescripcion: Code[55];
        gMarca: Code[35];
        gModelo: Code[45];
        gSerie: Code[35];
        OLDFaNo_: Code[35];
        gContador: Integer;
        FGroup: Code[35];
        gFADepreciationBook: Record "FA Depreciation Book";
        FechaUso2: Date;
}

