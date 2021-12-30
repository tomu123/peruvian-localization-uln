report 51049 "Patrimonio Neto"
{
    //LIBRO 3.19
    // Identify  Nro.  yyyy.MM.dd  Version   Description
    // -----------------------------------------------------
    // ULN::PC   001   2021.07.05    V.1     Peruvian Books (Copy From MT )
    DefaultLayout = RDLC;
    RDLCLayout = './App/Report/RDLC/Patrimonio Neto.rdl';

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            RequestFilterFields = "Date Filter";
            column(Ejercicio; gPeriodo)
            {
            }
            column(empresa; gInfComp.Name)
            {
            }
            column(ruc; gInfComp."VAT Registration No.")
            {
            }
            column(SaldoAnteriorCapital; saldoAnteriorCapital)
            {
            }
            column(SaldoAnteriorResultadoAcumulados; saldoAnteriorResultadoAcumulados)
            {
            }
            column(SaldoAnteriorTotal; SaldoAnteriorTotal)
            {
            }
            column(Total10; Total10)
            {
            }
            column(SaldoActualTotal; SaldoActualTotal)
            {
            }
            column(TextoPeriodoIni; gTextoPeriodoIni)
            {
            }
            column(TextoPeriodoFin; gTextoPeriodoFin)
            {
            }
            column(SaldoAnteriorCapitalAdicional; saldoAnteriorCapitalAdicionalR)
            {
            }
            column(SaldoAnteriorAccionesInversion; saldoAnteriorAccionesInversionR)
            {
            }
            column(SaldoAnteriorExcedenteRevaluacion; saldoAnteriorExcedenteRevaluacionR)
            {
            }
            column(SaldoAnteriorReservaLegal; SaldoAnteriorReservaLegalR)
            {
            }
            column(SaldoAnteriorOtrasReservas; SaldoAnteriorOtrasReservasR)
            {
            }
            column(SaldoAnteriorResultadoAcumulado; SaldoAnteriorResultadosAcumuladosR)
            {
            }
            column(saldoPeriodo1; saldoPeriodo[1])
            {
            }
            column(saldoPeriodo2; saldoPeriodo[2])
            {
            }
            column(saldoPeriodo3; saldoPeriodo[3])
            {
            }
            column(saldoPeriodo4; saldoPeriodo[4])
            {
            }
            column(saldoPeriodo5; saldoPeriodo[5])
            {
            }
            column(saldoPeriodo6; saldoPeriodo[6])
            {
            }
            column(saldoPeriodo7; saldoPeriodo[7])
            {
            }
            column(saldoPeriodo8; saldoPeriodo[8])
            {
            }
            column(saldoPeriodo9; saldoPeriodo[9])
            {
            }
            column(saldoPeriodo10; saldoPeriodo[10])
            {
            }
            column(saldoPeriodo11; saldoPeriodo[11])
            {
            }
            column(saldoPeriodo12; saldoPeriodo[12])
            {
            }
            column(saldoPeriodo13; saldoPeriodo[13])
            {
            }
            column(saldoPeriodo14; saldoPeriodo[14])
            {
            }
            column(saldoPeriodo15; saldoPeriodo[15])
            {
            }
            column(saldoPeriodo16; saldoPeriodo[16])
            {
            }
            column(saldoPeriodo17; saldoPeriodo[17])
            {
            }
            column(saldoPeriodo18; saldoPeriodo[18])
            {
            }
            column(saldoPeriodo19; saldoPeriodo[19])
            {
            }
            column(saldoPeriodo20; saldoPeriodo[20])
            {
            }
            column(saldoPeriodo21; saldoPeriodo[21])
            {
            }
            column(saldoPeriodo22; saldoPeriodo[22])
            {
            }
            column(saldoPeriodo23; saldoPeriodo[23])
            {
            }
            column(saldoPeriodo24; saldoPeriodo[24])
            {
            }
            column(saldoPeriodo25; saldoPeriodo[25])
            {
            }
            column(saldoPeriodo26; saldoPeriodo[26])
            {
            }
            column(saldoPeriodo27; saldoPeriodo[27])
            {
            }
            column(saldoPeriodo28; saldoPeriodo[28])
            {
            }
            column(saldoPeriodo29; saldoPeriodo[29])
            {
            }
            column(saldoPeriodo30; saldoPeriodo[30])
            {
            }
            column(saldoPeriodo31; saldoPeriodo[31])
            {
            }
            column(saldoPeriodo32; saldoPeriodo[32])
            {
            }
            column(saldoPeriodo33; saldoPeriodo[33])
            {
            }
            column(saldoPeriodo34; saldoPeriodo[34])
            {
            }
            column(saldoPeriodo35; saldoPeriodo[35])
            {
            }
            column(saldoPeriodo36; saldoPeriodo[36])
            {
            }
            column(saldoPeriodo37; saldoPeriodo[37])
            {
            }
            column(saldoPeriodo38; saldoPeriodo[38])
            {
            }
            column(saldoPeriodo39; saldoPeriodo[39])
            {
            }
            column(saldoPeriodo40; saldoPeriodo[40])
            {
            }
            column(saldoPeriodo41; saldoPeriodo[41])
            {
            }
            column(saldoPeriodo42; saldoPeriodo[42])
            {
            }
            column(saldoPeriodo43; saldoPeriodo[43])
            {
            }
            column(saldoPeriodo44; saldoPeriodo[44])
            {
            }
            column(saldoPeriodo45; saldoPeriodo[45])
            {
            }
            column(saldoPeriodo46; saldoPeriodo[46])
            {
            }
            column(saldoPeriodo47; saldoPeriodo[47])
            {
            }
            column(saldoPeriodo48; saldoPeriodo[48])
            {
            }
            column(saldoPeriodo49; saldoPeriodo[49])
            {
            }
            column(saldoPeriodo50; saldoPeriodo[50])
            {
            }
            column(saldoPeriodo51; saldoPeriodo[51])
            {
            }
            column(saldoPeriodo52; saldoPeriodo[52])
            {
            }
            column(saldoPeriodo53; saldoPeriodo[53])
            {
            }
            column(saldoPeriodo54; saldoPeriodo[54])
            {
            }
            column(saldoPeriodo55; saldoPeriodo[55])
            {
            }
            column(saldoPeriodo56; saldoPeriodo[56])
            {
            }
            column(saldoPeriodo57; saldoPeriodo[57])
            {
            }
            column(saldoPeriodo58; saldoPeriodo[58])
            {
            }
            column(saldoPeriodo59; saldoPeriodo[59])
            {
            }
            column(saldoPeriodo60; saldoPeriodo[60])
            {
            }
            column(saldoPeriodo61; saldoPeriodo[61])
            {
            }
            column(saldoPeriodo62; saldoPeriodo[62])
            {
            }
            column(saldoPeriodo63; saldoPeriodo[63])
            {
            }
            column(saldoPeriodo64; saldoPeriodo[64])
            {
            }
            column(saldoPeriodo65; saldoPeriodo[65])
            {
            }
            column(saldoPeriodo66; saldoPeriodo[66])
            {
            }
            column(saldoPeriodo67; saldoPeriodo[67])
            {
            }
            column(saldoPeriodo68; saldoPeriodo[68])
            {
            }
            column(saldoPeriodo69; saldoPeriodo[69])
            {
            }
            column(saldoPeriodo70; saldoPeriodo[70])
            {
            }
            column(saldoPeriodo71; saldoPeriodo[71])
            {
            }
            column(saldoPeriodo72; saldoPeriodo[72])
            {
            }
            column(saldoPeriodo73; saldoPeriodo[73])
            {
            }
            column(saldoPeriodo74; saldoPeriodo[74])
            {
            }
            column(saldoPeriodo75; saldoPeriodo[75])
            {
            }
            column(saldoPeriodo76; saldoPeriodo[76])
            {
            }
            column(saldoPeriodo77; saldoPeriodo[77])
            {
            }

            trigger OnAfterGetRecord()
            begin
                IF DATE2DMY(FechaFin, 3) = 2016 THEN BEGIN
                    lclFechaInicialAnterior := FechaInicio;
                    lclFechaFinalAnterior := FechaFin;
                END ELSE BEGIN
                    lclFechaInicialAnterior := CALCDATE('-PA-1A', FechaInicio);
                    lclFechaFinalAnterior := CALCDATE('PA-1A', FechaInicio);
                END;

                gGLEntry.RESET;
                gGLEntry.SETFILTER(gGLEntry."G/L Account No.", '%1', '50????');
                gGLEntry.SETRANGE(gGLEntry."Posting Date", lclFechaInicialAnterior, lclFechaFinalAnterior);
                IF gGLEntry.FINDSET THEN
                    REPEAT
                        saldoAnteriorCapital += gGLEntry.Amount;
                    UNTIL gGLEntry.NEXT = 0;

                saldoAnteriorResultadoAcumulados := "#CalculoSaldoAnteriorResultadoAcumulado"(0D, CALCDATE('-1D', FechaInicio), '=%1', '591101');
                saldoAnteriorResultadoAcumulados += "#CalculoSaldoAnteriorResultadoAcumulado"(0D, CALCDATE('-1D', FechaInicio), '=%1', '591102');
                saldoAnteriorResultadoAcumulados += "#CalculoSaldoAnteriorResultadoAcumulado"(0D, CALCDATE('-1D', FechaInicio), '=%1', '592101');
                saldoAnteriorResultadoAcumulados += "#CalculoSaldoAnteriorResultadoAcumulado"(0D, CALCDATE('-1D', FechaInicio), '=%1', '592102');
                saldoAnteriorResultadoAcumulados += "#CalculoSaldoAnteriorResultadoAcumulado"(0D, CALCDATE('-1D', FechaInicio), '=%1', '591111');
                saldoAnteriorResultadoAcumulados += "#CalculoSaldoAnteriorResultadoAcumulado"(0D, CALCDATE('-1D', FechaInicio), '=%1', '592111');

                IF saldoAnteriorResultadoAcumulados = 0 THEN BEGIN
                    gGLEntry.SETFILTER(gGLEntry."G/L Account No.", '%1', '59*');
                    gGLEntry.SETRANGE(gGLEntry."Global Dimension 7 Code", 'CPN12');
                    gGLEntry.SETRANGE(gGLEntry."Posting Date", FechaInicio, FechaFin);
                    IF gGLEntry.FINDSET THEN
                        REPEAT
                            saldoAnteriorResultadoAcumulados += gGLEntry.Amount;
                        UNTIL gGLEntry.NEXT = 0;
                END;

                saldoAnteriorCapitalAdicionalR := "#CalculoSaldoAnteriorResultadoAcumulado"(0D, CALCDATE('-1D', FechaInicio), '%1', '52????');
                saldoAnteriorAccionesInversionR := "#CalculoSaldoAnteriorResultadoAcumulado"(0D, CALCDATE('-1D', FechaInicio), '%1', '51????');
                saldoAnteriorExcedenteRevaluacionR := "#CalculoSaldoAnteriorResultadoAcumulado"(0D, CALCDATE('-1D', FechaInicio), '%1', '57????');

                SaldoAnteriorReservaLegalR := "#CalculoSaldoAnteriorResultadoAcumulado"(0D, CALCDATE('-1D', FechaInicio), '=%1', '582111');
                IF SaldoAnteriorReservaLegalR = 0 THEN BEGIN
                    gGLEntry.SETFILTER(gGLEntry."G/L Account No.", '%1', '582111');
                    gGLEntry.SETRANGE(gGLEntry."Posting Date", FechaInicio, FechaFin);
                    IF gGLEntry.FINDSET THEN
                        REPEAT
                            SaldoAnteriorReservaLegalR += gGLEntry.Amount;
                        UNTIL gGLEntry.NEXT = 0;

                END;

                SaldoAnteriorOtrasReservasR := "#CalculoSaldoAnteriorResultadoAcumulado"(0D, CALCDATE('-1D', FechaInicio), '=%1', '581*');
                SaldoAnteriorOtrasReservasR += "#CalculoSaldoAnteriorResultadoAcumulado"(0D, CALCDATE('-1D', FechaInicio), '=%1', '583*');
                SaldoAnteriorOtrasReservasR += "#CalculoSaldoAnteriorResultadoAcumulado"(0D, CALCDATE('-1D', FechaInicio), '=%1', '584*');
                SaldoAnteriorOtrasReservasR += "#CalculoSaldoAnteriorResultadoAcumulado"(0D, CALCDATE('-1D', FechaInicio), '=%1', '585*');
                SaldoAnteriorOtrasReservasR += "#CalculoSaldoAnteriorResultadoAcumulado"(0D, CALCDATE('-1D', FechaInicio), '=%1', '589*');

                SaldoAnteriorResultadosAcumuladosR := "#CalculoSaldoAnteriorResultadoAcumulado"(0D, CALCDATE('-1D', FechaInicio), '=%1', '59*');
                SaldoAnteriorResultadosAcumuladosR := SaldoAnteriorResultadosAcumuladosR * -1;

                Total10 := ResultadoEjercicio;
                SaldoAnteriorTotal := saldoAnteriorCapital + saldoAnteriorCapitalAdicionalR + saldoAnteriorAccionesInversionR + saldoAnteriorExcedenteRevaluacionR + SaldoAnteriorOtrasReservasR +
                                      SaldoAnteriorReservaLegalR + SaldoAnteriorOtrasReservasR + saldoAnteriorResultadoAcumulados;
                SaldoActualTotal := SaldoAnteriorTotal + Total10;

                "#AsignacionVariable"(FechaInicio, FechaFin, 0, 'CPN01');
                "#AsignacionVariable"(FechaInicio, FechaFin, 7, 'CPN02');
                "#AsignacionVariable"(FechaInicio, FechaFin, 14, 'CPN03');
                "#AsignacionVariable"(FechaInicio, FechaFin, 21, 'CPN04');
                "#AsignacionVariable"(FechaInicio, FechaFin, 28, 'CPN05');
                "#AsignacionVariable"(FechaInicio, FechaFin, 35, 'CPN06');
                "#AsignacionVariable"(FechaInicio, FechaFin, 42, 'CPN07');
                "#AsignacionVariable"(FechaInicio, FechaFin, 49, 'CPN08');
                "#AsignacionVariable"(FechaInicio, FechaFin, 56, 'CPN09');
                "#AsignacionVariable"(FechaInicio, FechaFin, 63, 'CPN10');
                "#AsignacionVariable"(FechaInicio, FechaFin, 70, 'CPN11');
            end;

            trigger OnPreDataItem()
            begin
                SETFILTER("G/L Account"."No.", '%1', '50????');//1101');
                gAno := FORMAT(CALCDATE('-1D', FechaInicio), 0, '<Year4>');
                gMes := FORMAT(CALCDATE('-1D', FechaInicio), 0, '<Month,2>');
                gMes := "#MesTexto"(gMes);

                gTextoPeriodoIni := FORMAT(CALCDATE('-1D', FechaInicio), 0, '<Day,2>') + ' DE ' + UPPERCASE(gMes) + ' DE ' + gAno;
                gMes := FORMAT(FechaFin, 0, '<Month,2>');
                gMes := "#MesTexto"(gMes);

                gTextoPeriodoFin := FORMAT(FechaFin, 0, '<Day,2>') + ' DE ' + UPPERCASE(gMes) + ' DE ' + FORMAT(FechaFin, 0, '<Year4>');
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(FechaInicio; FechaInicio)
                {
                    Caption = 'Fecha Inicio', Comment = 'ESM="Fecha Inicio"';
                }
                field(FechaFin; FechaFin)
                {
                    Caption = 'Fecha Fin', Comment = 'ESM="Fecha Fin"';
                }
                field(gPeriodo; gPeriodo)
                {
                    Caption = 'Ejercicio', Comment = 'ESM="Ejercicio"';
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
        gInfComp.GET();
    end;

    var
        saldoAnteriorCapital: Decimal;
        saldoAnteriorCapitalAdicional: Decimal;
        saldoAnteriorAccionesInversion: Decimal;
        saldoAnteriorExcedenteRevaluacion: Decimal;
        SaldoAnteriorReservaLegal: Decimal;
        SaldoAnteriorOtrasReservas: Decimal;
        SaldoAnteriorTotal: Decimal;
        Total10: Decimal;
        SaldoActualTotal: Decimal;
        saldoAnteriorResultadoAcumulados: Decimal;
        recGLAccount: Record "G/L Account";
        recEntry: Record "G/L Entry";
        FechaInicio: Date;
        FechaFin: Date;
        Ejercicio: Text;
        gTextoPeriodoIni: Text[150];
        gMes: Text[50];
        gDia: Text[50];
        gAno: Text[50];
        gTextoPeriodoFin: Text[150];
        gInfComp: Record "Company Information";
        saldoAnteriorCapitalAdicionalR: Decimal;
        saldoAnteriorAccionesInversionR: Decimal;
        saldoAnteriorExcedenteRevaluacionR: Decimal;
        SaldoAnteriorReservaLegalR: Decimal;
        SaldoAnteriorOtrasReservasR: Decimal;
        SaldoAnteriorResultadosAcumuladosR: Decimal;
        saldoPeriodo: array[77] of Decimal;
        gPeriodo: Text[50];
        gFechaFin: Date;
        gGLEntry: Record "G/L Entry";
        lclFechaInicialAnterior: Date;
        lclFechaFinalAnterior: Date;

    procedure ResultadoEjercicio() TotalEjercicio: Decimal
    begin
        CLEAR(TotalEjercicio);
        TotalEjercicio := "#CalculoTotalEjercicio"(FechaInicio, FechaFin, '%1', '9*');
        TotalEjercicio += "#CalculoTotalEjercicio"(FechaInicio, FechaFin, '%1', '62*');
        TotalEjercicio += "#CalculoTotalEjercicio"(FechaInicio, FechaFin, '%1', '63*');
        TotalEjercicio += "#CalculoTotalEjercicio"(FechaInicio, FechaFin, '%1', '64*');
        TotalEjercicio += "#CalculoTotalEjercicio"(FechaInicio, FechaFin, '%1', '65*');
        TotalEjercicio += "#CalculoTotalEjercicio"(FechaInicio, FechaFin, '%1', '66*');
        TotalEjercicio += "#CalculoTotalEjercicio"(FechaInicio, FechaFin, '%1', '67*');
        TotalEjercicio += "#CalculoTotalEjercicio"(FechaInicio, FechaFin, '%1', '68*');
        TotalEjercicio += "#CalculoTotalEjercicio"(FechaInicio, FechaFin, '%1', '69*');
        TotalEjercicio += "#CalculoTotalEjercicio"(FechaInicio, FechaFin, '%1', '61*');
        TotalEjercicio += "#CalculoTotalEjercicio"(FechaInicio, FechaFin, '%1', '60*');
        TotalEjercicio += "#CalculoTotalEjercicio"(FechaInicio, FechaFin, '%1', '7*');
    end;

    procedure "#MesTexto"(pMes: Text[2]) gMes: Text[50]
    begin
        CASE pMes OF
            '01':
                gMes := 'Enero';
            '02':
                gMes := 'Febrero';
            '03':
                gMes := 'Marzo';
            '04':
                gMes := 'Abril';
            '05':
                gMes := 'Mayo';
            '06':
                gMes := 'Junio';
            '07':
                gMes := 'Julio';
            '08':
                gMes := 'Agosto';
            '09':
                gMes := 'Setiembre';
            '10':
                gMes := 'Octubre';
            '11':
                gMes := 'Noviembre';
            '12':
                gMes := 'Diciembre';
        END;
    end;

    procedure "#CalculoSaldoAnteriorResultadoAcumulado"(pFecIni: Date; pFecFin: Date; pCondicion: Text[50]; pValores: Text[100]) TotalSumarizadoSaldoAnterior: Decimal
    var
        pGLAcount: Record "G/L Account";
        lclGLEntry: Record "G/L Entry";
    begin
        TotalSumarizadoSaldoAnterior := 0.0;

        lclGLEntry.RESET;
        lclGLEntry.SETFILTER("G/L Account No.", pCondicion, pValores);
        lclGLEntry.SETRANGE("Posting Date", pFecIni, CLOSINGDATE(pFecFin));
        lclGLEntry.SETFILTER("Source Code", '<>%1&<>%2', 'APERTURA', 'CIERRE');
        lclGLEntry.CALCSUMS(Amount);
        TotalSumarizadoSaldoAnterior := lclGLEntry.Amount;
    end;

    procedure "#CalculoTotalEjercicio"(pFecIni: Date; pFecfin: Date; pCondicion: Text[50]; pValores: Text[50]) TotalSumarizado: Decimal
    var
        pGLEntry: Record "G/L Entry";
    begin
        TotalSumarizado := 0.0;
        pGLEntry.RESET;
        pGLEntry.SETFILTER("G/L Account No.", pCondicion, pValores);
        pGLEntry.SETRANGE("Posting Date", pFecIni, pFecfin);
        IF pGLEntry.FIND('-') THEN BEGIN
            REPEAT
                TotalSumarizado += pGLEntry.Amount
            UNTIL pGLEntry.NEXT = 0;
        END;
    end;

    procedure "#CalculoSaldoPeriodo"(pInicial: Date; pFinal: Date; pValores: Text[50]; pDimensionValue: Text[50]) pSaldoPeriodo: Decimal
    var
        pGLEntry: Record "G/L Entry";
        pGroupDimension: Record "Dimension Set Entry";
    begin
        pSaldoPeriodo := 0.0;

        pGLEntry.RESET;
        pGLEntry.SETRANGE(pGLEntry."Posting Date", CLOSINGDATE(pInicial), CLOSINGDATE(pFinal));
        pGLEntry.SETFILTER(pGLEntry."G/L Account No.", '%1', pValores);
        IF pGLEntry.FINDSET THEN
            REPEAT
                pGroupDimension.RESET;
                pGroupDimension.SETRANGE("Dimension Set ID", pGLEntry."Dimension Set ID");
                pGroupDimension.SETRANGE("Dimension Value Code", pDimensionValue);
                IF pGroupDimension.FINDSET THEN BEGIN
                    pSaldoPeriodo += pGLEntry.Amount;
                END;
            UNTIL pGLEntry.NEXT = 0;
    end;

    procedure "#AsignacionVariable"(pFecIni: Date; pFecFin: Date; pIdent: Integer; pIdentText: Text[10])
    begin
        saldoPeriodo[1 + pIdent] := "#CalculoSaldoPeriodo"(pFecIni, pFecFin, '50*', pIdentText);
        saldoPeriodo[2 + pIdent] := "#CalculoSaldoPeriodo"(pFecIni, pFecFin, '52*', pIdentText);
        saldoPeriodo[3 + pIdent] := "#CalculoSaldoPeriodo"(pFecIni, pFecFin, '51*', pIdentText);
        saldoPeriodo[4 + pIdent] := "#CalculoSaldoPeriodo"(pFecIni, pFecFin, '57*', pIdentText);
        saldoPeriodo[5 + pIdent] := "#CalculoSaldoPeriodo"(pFecIni, pFecFin, '582111', pIdentText);
        saldoPeriodo[6 + pIdent] := "#CalculoSaldoPeriodo"(pFecIni, pFecFin, '581*', pIdentText);
        saldoPeriodo[6 + pIdent] += "#CalculoSaldoPeriodo"(pFecIni, pFecFin, '583*', pIdentText);
        saldoPeriodo[6 + pIdent] += "#CalculoSaldoPeriodo"(pFecIni, pFecFin, '584*', pIdentText);
        saldoPeriodo[6 + pIdent] += "#CalculoSaldoPeriodo"(pFecIni, pFecFin, '585*', pIdentText);
        saldoPeriodo[6 + pIdent] += "#CalculoSaldoPeriodo"(pFecIni, pFecFin, '589*', pIdentText);

        saldoPeriodo[7 + pIdent] := "#CalculoSaldoPeriodo"(pFecIni, pFecFin, '59????', pIdentText);
    end;
}

