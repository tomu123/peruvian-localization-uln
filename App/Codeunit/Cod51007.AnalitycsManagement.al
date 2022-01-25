codeunit 51007 "Analitycs Management"
{
    trigger OnRun()
    begin

    end;

    local procedure SetSetup()
    begin
        SLSetup.Get();
    end;

    local procedure OpenWindows()
    var
        ContaintText: Text[200];
    begin
        ContaintText := Processing;
        Windows.Open(ContaintText);
    end;

    local procedure UpdateWindows(Number: Integer; Counter: Integer; Total: Integer)
    begin
        Windows.Update(Number, Round(Counter / Total * 10000, 2));
    end;

    local procedure CloseWindows()
    begin
        Windows.Close();
    end;

    local procedure SetDate(): Boolean
    var
        SetDatePage: Page "Analitycs Set Date";
    begin
        Clear(SetDatePage);
        if SetDatePage.RunModal() in [Action::LookupOK, Action::OK, Action::Yes] then begin
            SetDatePage.SetFilterDate(StartDate, EndDate);
            exit(true);
        end;
        exit(false);
    end;

    local procedure CheckPeriod()
    var
        AccountPeriod: Record "Accounting Period";
    begin
        AccountPeriod.Reset();
        AccountPeriod.SetRange("Starting Date", 0D, StartDate);
        if AccountPeriod.FindFirst() then begin
            AccountPeriod.TestField("New Fiscal Year", true);
            AccountPeriod.TestField("Date Locked", true);
        end;
        AccountPeriod.Reset();
        AccountPeriod.SetRange("Starting Date", 0D, EndDate);
        if AccountPeriod.FindFirst() then begin
            AccountPeriod.TestField("New Fiscal Year", true);
            AccountPeriod.TestField("Date Locked", true);
        end;
    end;

    local procedure CheckPostingDate()
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        GeneralLedgerSetup.Get();

        if StartDate < GeneralLedgerSetup."Allow Posting From" then
            Error('Esta fecha no esta permitida para el registro');

        if EndDate > GeneralLedgerSetup."Allow Posting To" then
            Error('Esta fecha no esta permitida para el registro');
    end;

    procedure ReassignAnalitycsAccounts()
    var
        GLEntry: Record "G/L Entry";
        GLEntry2: Record "G/L Entry";
        GLReg: Record "G/L Register";
        GLAcc: Record "G/L Account";
        AccountingPeriod: Record "Accounting Period";
        TotalRecords: array[2] of Integer;
        CountRecords: array[2] of Integer;
        FromEntryNo: Integer;
        NextEntryNo: Integer;
        NextRegisterEntryNo: Integer;
        VATEntryNo: Integer;
    begin
        if not SetDate() then
            exit;
        checkPostingDate();
        CheckPeriod();
        SetSetup();
        OpenWindows();
        GLEntry.Reset();
        GLEntry.SetCurrentKey("Entry No.");
        GLEntry.FindLast();
        FromEntryNo := GLEntry."Entry No.";
        NextEntryNo := FromEntryNo;

        GLEntry.LockTable();
        GLReg.LockTable();
        GLAcc.LockTable();

        GLAcc.Reset();
        GLAcc.SetRange(Analitycs, true);
        //GLAcc.SetRange("No.", '651103');
        TotalRecords[1] := GLAcc.Count;
        if GLAcc.FindSet() then
            repeat
                CountRecords[1] += 1;
                GLEntry.Reset();
                GLEntry.SetRange("G/L Account No.", GLAcc."No.");
                GLEntry.SetRange("Posting Date", StartDate, ClosingDate(EndDate));
                TotalRecords[2] := GLEntry.Count;
                if GLEntry.FindFirst() then
                    repeat
                        CountRecords[2] += 1;
                        GLEntry2.Reset();
                        GLEntry2.SetRange("Analityc Base Entry No.", GLEntry."Entry No.");
                        GLEntry2.SetRange("Posting Date", StartDate, ClosingDate(EndDate));
                        if GLEntry2.IsEmpty then
                            SetReassingAnalitycsAccounts(GLEntry, NextEntryNo);
                        UpdateWindows(2, CountRecords[2], TotalRecords[2]);
                    until GLEntry.Next() = 0;
                UpdateWindows(1, CountRecords[1], TotalRecords[1]);
            until GLAcc.Next() = 0;
        if FromEntryNo <> NextEntryNo then begin
            GLReg.Reset();
            GLReg.SetCurrentKey("No.");
            GLReg.FindLast();
            NextRegisterEntryNo := GLReg."No." + 1;
            VATEntryNo := GLReg."To VAT Entry No.";

            GLReg.Init;
            GLReg."No." := NextRegisterEntryNo;
            GLReg."From Entry No." := FromEntryNo;
            GLReg."To Entry No." := NextEntryNo;
            GLReg."From VAT Entry No." := VATEntryNo;
            GLReg."To Entry No." := VATEntryNo;
            GLReg."Creation Date" := Today;
            GLReg."Creation Time" := Time;
            GLReg."Source Code" := '';
            GLReg."Journal Batch Name" := '';
            GLReg."User ID" := UserId;
            GLReg.Insert();
        end;
        CloseWindows();
        Message('Proceso Finalizado.');
    end;

    local procedure SetReassingAnalitycsAccounts(var GLEntry: Record "G/L Entry"; var NextEntryNo: Integer)
    var
        GLEntry2: Record "G/L Entry";
        GLAcc: Record "G/L Account";
        DimSetEntry: Record "Dimension Set Entry";
        DimValue: Record "Dimension Value";
        LastCuoCorrelative: Code[20];
        report595: Report 595;
        CUOEntry: Record "ULN CUO Entry";
    begin
        if SLSetup."Analityc Global Dimension" = '' then
            exit;
        if GLEntry.Reversed then
            exit;
        if not DimSetEntry.Get(GLEntry."Dimension Set ID", SLSetup."Analityc Global Dimension") then
            exit;
        DimValue.Get(DimSetEntry."Dimension Code", DimSetEntry."Dimension Value Code");
        if not DimValue.Analityc then
            exit;
        DimValue.TestField("Debit Analityc G/L Acc. No.");
        DimValue.TestField("Credit Analityc G/L Acc. No.");

        GLEntry2.Reset();
        GLEntry2.SetCurrentKey("Correlative CUO");
        GLEntry2.SetRange("Document No.", GLEntry."Document No.");
        if GLEntry2.FindLast() then
            LastCuoCorrelative := GLEntry2."Correlative CUO";

        NextEntryNo += 1;
        LastCuoCorrelative := IncStr(LastCuoCorrelative);

        GLEntry2.Init();
        GLEntry2.TransferFields(GLEntry, false);
        GLEntry2."Entry No." := NextEntryNo;
        GLEntry2."Correlative CUO" := LastCuoCorrelative;
        GLEntry2."G/L Account No." := DimValue."Debit Analityc G/L Acc. No.";
        GLEntry2."Analityc Entry" := true;
        GLEntry2."Analityc Base Entry No." := GLEntry."Entry No.";
        GLEntry2.Insert();

        NextEntryNo += 1;
        LastCuoCorrelative := IncStr(LastCuoCorrelative);

        GLEntry2.Init();
        GLEntry2.TransferFields(GLEntry, false);
        GLEntry2."Entry No." := NextEntryNo;
        GLEntry2."Correlative CUO" := LastCuoCorrelative;
        GLEntry2."G/L Account No." := DimValue."Credit Analityc G/L Acc. No.";
        GLEntry2.Amount := GLEntry.Amount * -1;
        GLEntry2."Additional-Currency Amount" := GLEntry."Additional-Currency Amount" * -1;//ULN::RRR 20/07/2021
        if GLEntry2.Amount < 0 then begin
            GLEntry2."Credit Amount" := Abs(GLEntry2.Amount);
            GLEntry2."Debit Amount" := 0;
            GLEntry2."Add.-Currency Credit Amount" := GLEntry2."Add.-Currency Debit Amount";
            GLEntry2."Add.-Currency Debit Amount" := 0;
        end else begin
            GLEntry2."Debit Amount" := Abs(GLEntry2.Amount);
            GLEntry2."Credit Amount" := 0;
            GLEntry2."Add.-Currency Debit Amount" := GLEntry2."Add.-Currency Credit Amount";
            GLEntry2."Add.-Currency Credit Amount" := 0;
        end;
        GLEntry2."Analityc Entry" := true;
        GLEntry2."Analityc Base Entry No." := GLEntry."Entry No.";
        GLEntry2.Insert();

        CUOEntry.SetRange("CUO Transaction No.", GLEntry."Transaction CUO");
        if CUOEntry.FindFirst() then begin
            CUOEntry."Last. used CUO Correlative" := LastCuoCorrelative;
            CUOEntry.Modify()
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInsertGlobalGLEntry', '', true, true)]
    procedure SetAnalitycsAccounts(var GLEntry: Record "G/L Entry"; var TempGLEntryBuf: Record "G/L Entry"; var NextEntryNo: Integer)
    var
        GLAcc: Record "G/L Account";
        DimSetEntry: Record "Dimension Set Entry";
        DimValue: Record "Dimension Value";
        GLEntry2: Record "G/L Entry";
        NextCUOCorrelative: Code[30];
    begin
        SetSetup();
        if SLSetup."Analityc Global Dimension" = '' then
            exit;
        GLAcc.Get(GLEntry."G/L Account No.");
        if Not GLAcc.Analitycs then
            exit;
        if GLEntry.Reversed then
            exit;
        if not DimSetEntry.Get(GLEntry."Dimension Set ID", SLSetup."Analityc Global Dimension") then
            exit;
        DimValue.Get(DimSetEntry."Dimension Code", DimSetEntry."Dimension Value Code");
        if not DimValue.Analityc then
            exit;
        DimValue.TestField("Debit Analityc G/L Acc. No.");
        DimValue.TestField("Credit Analityc G/L Acc. No.");

        CUOMgt.SetProcessCUO(TempGLEntryBuf);
        NextCUOCorrelative := TempGLEntryBuf."Correlative CUO";

        GLEntry2.Init();
        GLEntry2.TransferFields(GLEntry, false);
        GLEntry2."Entry No." := NextEntryNo;
        GLEntry2."G/L Account No." := DimValue."Debit Analityc G/L Acc. No.";
        GLEntry2."Analityc Entry" := true;
        GLEntry2."Analityc Base Entry No." := GLEntry."Entry No.";
        GLEntry2."Correlative CUO" := NextCUOCorrelative;
        GLEntry2.Insert();

        NextEntryNo += 1;
        CUOMgt.SetProcessCUO(TempGLEntryBuf);
        NextCUOCorrelative := TempGLEntryBuf."Correlative CUO";

        GLEntry2.Init();
        GLEntry2.TransferFields(GLEntry, false);
        GLEntry2."Entry No." := NextEntryNo;
        GLEntry2."G/L Account No." := DimValue."Credit Analityc G/L Acc. No.";
        GLEntry2.Amount := GLEntry.Amount * -1;
        GLEntry2."Additional-Currency Amount" := GLEntry."Additional-Currency Amount" * -1;//ULN::RRR 20/07/2021
        if GLEntry2.Amount < 0 then begin
            GLEntry2."Credit Amount" := Abs(GLEntry2.Amount);
            GLEntry2."Debit Amount" := 0;
            GLEntry2."Add.-Currency Credit Amount" := GLEntry2."Add.-Currency Debit Amount";
            GLEntry2."Add.-Currency Debit Amount" := 0;
        end else begin
            GLEntry2."Debit Amount" := Abs(GLEntry2.Amount);
            GLEntry2."Credit Amount" := 0;
            GLEntry2."Add.-Currency Debit Amount" := GLEntry2."Add.-Currency Credit Amount";
            GLEntry2."Add.-Currency Credit Amount" := 0;
        end;
        GLEntry2."Analityc Entry" := true;
        GLEntry2."Analityc Base Entry No." := GLEntry."Entry No.";
        GLEntry2."Correlative CUO" := NextCUOCorrelative;
        GLEntry2.Insert();

        NextEntryNo += 1;
    end;

    local procedure MyProcedure()
    var
        FileMgt: Codeunit "File Management";
        TempBlob: Codeunit "Temp Blob";
    begin
        FileMgt.BLOBImportFromServerFile(TempBlob, '');
    end;

    var
        SLSetup: Record "Setup Localization";
        CUOMgt: Codeunit "CUO Management";
        StartDate: Date;
        EndDate: Date;
        Windows: Dialog;
        Processing: Label 'G/L Account  #1#######################\\Processing  #2#######################',
        Comment = 'ESM="N° Cuenta  #1#######################\\Procesando  #2#######################"';
}