report 51039 "BALANCE DE COMPROBACION"
{
    //LIBRO 3.17

    // Identify  Nro.  yyyy.MM.dd  Version   Description
    // -----------------------------------------------------
    // ULN::CCL  001   2018.01.31  v.001     LPE
    DefaultLayout = RDLC;
    RDLCLayout = './App/Report/RDLC/BALANCE DE COMPROBACION.rdl';
    Caption = 'BALANCE DE COMPROBACION', Comment = 'ESM="BALANCE DE COMPROBACION"';

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            RequestFilterFields = "No.", "Account Type";
            column(DecimalValues1; DecimalValues[1])
            {
            }
            column(DecimalValues2; DecimalValues[2])
            {
            }
            column(DecimalValues3; DecimalValues[3])
            {
            }
            column(DecimalValues4; DecimalValues[4])
            {
            }
            column(DecimalValues5; DecimalValues[5])
            {
            }
            column(DecimalValues6; DecimalValues[6])
            {
            }
            column(DecimalValues7; DecimalValues[7])
            {
            }
            column(DecimalValues8; DecimalValues[8])
            {
            }
            column(DecimalValues9; DecimalValues[9])
            {
            }
            column(DecimalValues10; DecimalValues[10])
            {
            }
            column(DecimalValues11; DecimalValues[11])
            {
            }
            column(DecimalValues12; DecimalValues[12])
            {
            }
            column(No_GLAccount; "G/L Account"."No.")
            {
            }
            column(Name_GLAccount; "G/L Account".Name)
            {
            }
            column(RazonSocial; recCompanyInformation.Name)
            {
            }
            column(RUC; recCompanyInformation."VAT Registration No.")
            {
            }
            column(PERIODO; gPeriodo)
            {
            }

            trigger OnAfterGetRecord()
            var
                lclGLAccount: Record "G/L Account";
                DebeSaldoPeriodo: Decimal;
                HaberSaldoPeriodo: Decimal;
            begin
                IF COPYSTR("G/L Account"."No.", 1, 2) = 'MS' THEN
                    CurrReport.SKIP;

                //PC.20.05.21 ++++++
                IF COPYSTR("G/L Account"."No.", 1, 3) = 'MIG' THEN
                    CurrReport.SKIP;
                //PC.20.05.21 ++++++

                CLEAR(DecimalValues);
                gdinicial := 0;
                gdfinal := 0;

                SETRANGE("G/L Account"."Date Filter", StartDate, EndDate);

                //CALCFIELDS("G/L Account"."Debit Amount Apertura.", "G/L Account"."Credit Amount Apertura.");
                // lclGLAccount.Reset();
                // lclGLAccount.SetRange("No.", "G/L Account"."No.");
                // lclGLAccount.SetFilter("Date Filter", '..%1', StartDate);
                // if lclGLAccount.FindSet() then begin
                //     lclGLAccount.CalcFields("Balance at Date");
                //     gdinicial := lclGLAccount."Balance at Date";
                // end;
                // lclGLAccount.Reset();
                // lclGLAccount.SetRange("No.", "G/L Account"."No.");
                // lclGLAccount.SetFilter("Date Filter", '..%1', EndDate);
                // if lclGLAccount.FindSet() then begin
                //     lclGLAccount.CalcFields("Balance at Date");
                //     gdfinal := lclGLAccount."Balance at Date";
                // end;

                // SETRANGE("G/L Account"."Date Filter", DMY2DATE(1, 1, DATE2DMY(StartDate, 3)), CALCDATE('<-1D>', StartDate));

                // CALCFIELDS("G/L Account"."Debit Amount", "G/L Account"."Credit Amount");
                // gimporte := ("G/L Account"."Debit Amount" - "G/L Account"."Credit Amount") + (gdinicial - gdfinal);
                gimporte := fnRecalculateAmountMIG(TRUE);//PC 20-05-21
                IF gimporte > 0 THEN
                    DecimalValues[1] := gimporte
                ELSE
                    DecimalValues[2] := ABS(gimporte);

                SETRANGE("G/L Account"."Date Filter", StartDate, EndDate);
                //CALCFIELDS("G/L Account"."Debit Amount", "G/L Account"."Credit Amount", "G/L Account"."Debit Amount Apertura.", "G/L Account"."Credit Amount Apertura.");
                //DecimalValues[3] := "G/L Account"."Debit Amount" - "G/L Account"."Debit Amount Apertura.";

                //DecimalValues[4] := "G/L Account"."Credit Amount" - "G/L Account"."Credit Amount Apertura.";
                //PC 20-05-21+++++++++++++
                fnRecalculateAmountNoMIG(FALSE, DebeSaldoPeriodo, HaberSaldoPeriodo);
                DecimalValues[3] := DebeSaldoPeriodo;
                DecimalValues[4] := HaberSaldoPeriodo;
                //PC 20-05-21-----------
                SETRANGE("G/L Account"."Date Filter", DMY2DATE(1, 1, DATE2DMY(StartDate, 3)), EndDate);
                CALCFIELDS("G/L Account"."Debit Amount", "G/L Account"."Credit Amount");
                gimporte := ("G/L Account"."Debit Amount" - "G/L Account"."Credit Amount");

                IF gimporte > 0 THEN
                    DecimalValues[5] := gimporte
                ELSE
                    DecimalValues[6] := ABS(gimporte);

                IF "G/L Account"."Income/Balance" = "G/L Account"."Income/Balance"::"Balance Sheet" THEN
                    IF gimporte > 0 THEN
                        DecimalValues[7] := gimporte
                    ELSE
                        DecimalValues[8] := ABS(gimporte);

                IF COPYSTR("G/L Account"."No.", 1, 2) IN ['69', '70', '71', '72', '73', '74', '75', '76', '77', '78', '88', '90', '91', '92', '93', '94', '95', '97'] THEN //se agrego la cuenta '88'
                    IF gimporte > 0 THEN
                        DecimalValues[9] := gimporte
                    ELSE
                        DecimalValues[10] := ABS(gimporte);
                //PC 20-05-25+++++++++++++
                IF "G/L Account"."No." IN ['676101', '676102'] THEN BEGIN
                    IF gimporte > 0 THEN
                        DecimalValues[9] := gimporte
                    ELSE
                        DecimalValues[10] := ABS(gimporte);
                END;
                //PC 20-05-25+++++++++++++

                IF COPYSTR("G/L Account"."No.", 1, 2) IN ['60', '61', '62', '63', '64', '65', '66', '67', '68', '69', '70', '71', '72', '73', '74', '75', '76', '77', '78', '88'] THEN ////se agrego la cuenta '88'
                    IF gimporte > 0 THEN
                        DecimalValues[11] := gimporte
                    ELSE
                        DecimalValues[12] := ABS(gimporte);

                IF (DecimalValues[1] = 0) AND (DecimalValues[2] = 0) AND (DecimalValues[3] = 0) AND (DecimalValues[4] = 0) AND (DecimalValues[5] = 0) AND
                   (DecimalValues[6] = 0) AND (DecimalValues[7] = 0) AND (DecimalValues[8] = 0) AND (DecimalValues[9] = 0) AND (DecimalValues[10] = 0) AND
                   (DecimalValues[11] = 0) AND (DecimalValues[12] = 0) THEN
                    CurrReport.SKIP;
            end;

            trigger OnPreDataItem()
            begin
                recCompanyInformation.GET;
                gPeriodo := DATE2DMY(EndDate, 3);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                field(StartDate; StartDate)
                {
                    Caption = 'Start Date', Comment = 'ESM="Fecha Inicial"';
                }
                field(EndDate; EndDate)
                {
                    Caption = 'End Date', Comment = 'ESM="Fecha Fin"';
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
        DecimalValues: array[12] of Decimal;
        StartDate: Date;
        EndDate: Date;
        gimporte: Decimal;
        gdinicial: Decimal;
        gdfinal: Decimal;
        recCompanyInformation: Record "Company Information";
        gPeriodo: Integer;

    local procedure fnRecalculateAmountMIG(pOnlyMigration: Boolean): Decimal
    var
        lclRecGLEntry: Record "G/L Entry";
        lclAmount: Decimal;
    begin
        gimporte := 0;
        lclAmount := 0;
        lclRecGLEntry.RESET;
        lclRecGLEntry.SETFILTER("Posting Date", '..%1', EndDate);
        lclRecGLEntry.SETRANGE("G/L Account No.", "G/L Account"."No.");
        CASE pOnlyMigration OF
            TRUE:
                lclRecGLEntry.SETFILTER("Document No.", '%1', 'MIG*');
            FALSE:
                lclRecGLEntry.SETFILTER("Document No.", '<>%1', 'MIG*');
        END;

        IF lclRecGLEntry.FINDSET THEN
            REPEAT
                lclAmount += lclRecGLEntry.Amount;
            UNTIL lclRecGLEntry.NEXT = 0;

        EXIT(lclAmount);
    end;

    local procedure fnRecalculateAmountNoMIG(pOnlyMigration: Boolean; var DebeSaldoPeriodo: Decimal; var HaberSaldoPeriodo: Decimal)
    var
        lclRecGLEntry: Record "G/L Entry";
    begin
        gimporte := 0;
        DebeSaldoPeriodo := 0;
        HaberSaldoPeriodo := 0;
        lclRecGLEntry.RESET;
        lclRecGLEntry.SETFILTER("Posting Date", '..%1', EndDate);
        lclRecGLEntry.SETRANGE("G/L Account No.", "G/L Account"."No.");
        CASE pOnlyMigration OF
            TRUE:
                lclRecGLEntry.SETFILTER("Document No.", '%1', 'MIG*');
            FALSE:
                lclRecGLEntry.SETFILTER("Document No.", '<>%1', 'MIG*');
        END;

        IF lclRecGLEntry.FINDSET THEN
            REPEAT
                DebeSaldoPeriodo += lclRecGLEntry."Debit Amount";
                HaberSaldoPeriodo += lclRecGLEntry."Credit Amount";
            UNTIL lclRecGLEntry.NEXT = 0;
    end;

}

