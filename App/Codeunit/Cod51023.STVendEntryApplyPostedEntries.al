codeunit 51023 "ST VendEntry-Apply Posted Entr"
{
    trigger OnRun()
    begin

    end;

    procedure CheckReversal(VendLedgEntryNo: Integer)
    var
        VendLedgEntry: Record "Vendor Ledger Entry";
    begin
        VendLedgEntry.Get(VendLedgEntryNo);
        if VendLedgEntry.Reversed then
            Error(CannotUnapplyInReversalErr, VendLedgEntryNo);
    end;

    procedure FindLastApplEntry(VendLedgEntryNo: Integer): Integer
    var
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        ApplicationEntryNo: Integer;
    begin
        with DtldVendLedgEntry do begin
            SetCurrentKey("Vendor Ledger Entry No.", "Entry Type");
            SetRange("Vendor Ledger Entry No.", VendLedgEntryNo);
            SetRange("Entry Type", "Entry Type"::Application);
            SetRange(Unapplied, false);
            ApplicationEntryNo := 0;
            if Find('-') then
                repeat
                    if "Entry No." > ApplicationEntryNo then
                        ApplicationEntryNo := "Entry No.";
                until Next = 0;
        end;
        exit(ApplicationEntryNo);
    end;

    local procedure UnApplyUniqueVendor(DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry")
    var
        UnapplyVendEntries: Page "Unapply Vendor Entries";
    begin
        with DtldVendLedgEntry do begin
            TestField("Entry Type", "Entry Type"::Application);
            TestField(Unapplied, false);
            UnapplyVendEntries.SetUnapplyUnique();
            UnapplyVendEntries.SetDtldVendLedgEntryUnique("Entry No.");
            UnapplyVendEntries.SetDtldVendLedgEntry("Entry No.");
            UnapplyVendEntries.LookupMode(true);
            UnapplyVendEntries.RunModal;
        end;
    end;

    procedure UnApplyVendLedgEntry(VendLedgEntryNo: Integer)
    var
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        ApplicationEntryNo: Integer;
    begin
        CheckReversal(VendLedgEntryNo);
        ApplicationEntryNo := FindLastApplEntry(VendLedgEntryNo);
        if ApplicationEntryNo = 0 then
            Error(NoApplicationEntryErr, VendLedgEntryNo);
        DtldVendLedgEntry.Get(ApplicationEntryNo);
        UnApplyUniqueVendor(DtldVendLedgEntry);
    end;

    local procedure CollectAffectedLedgerEntries(var TempVendorLedgerEntry: Record "Vendor Ledger Entry" temporary; DetailedVendorLedgEntry2: Record "Detailed Vendor Ledg. Entry")
    var
        DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry";
    begin
        TempVendorLedgerEntry.DeleteAll();
        with DetailedVendorLedgEntry do begin
            if DetailedVendorLedgEntry2."Transaction No." = 0 then begin
                SetCurrentKey("Application No.", "Vendor No.", "Entry Type");
                SetRange("Application No.", DetailedVendorLedgEntry2."Application No.");
            end else begin
                SetCurrentKey("Transaction No.", "Vendor No.", "Entry Type");
                SetRange("Transaction No.", DetailedVendorLedgEntry2."Transaction No.");
            end;
            SetRange("Vendor No.", DetailedVendorLedgEntry2."Vendor No.");
            SetRange(Unapplied, false);
            SetFilter("Entry Type", '<>%1', "Entry Type"::"Initial Entry");
            if FindSet then
                repeat
                    TempVendorLedgerEntry."Entry No." := "Vendor Ledger Entry No.";
                    if TempVendorLedgerEntry.Insert() then;
                until Next = 0;
        end;
    end;

    local procedure CheckPostingDate(PostingDate: Date; var MaxPostingDate: Date)
    var
        GenJnlCheckLine: Codeunit "Gen. Jnl.-Check Line";
    begin
        if GenJnlCheckLine.DateNotAllowed(PostingDate) then
            Error(NotAllowedPostingDatesErr);

        if PostingDate > MaxPostingDate then
            MaxPostingDate := PostingDate;
    end;

    local procedure CheckAdditionalCurrency(OldPostingDate: Date; NewPostingDate: Date)
    var
        GLSetup: Record "General Ledger Setup";
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        if OldPostingDate = NewPostingDate then
            exit;
        GLSetup.Get();
        if GLSetup."Additional Reporting Currency" <> '' then
            if CurrExchRate.ExchangeRate(OldPostingDate, GLSetup."Additional Reporting Currency") <>
               CurrExchRate.ExchangeRate(NewPostingDate, GLSetup."Additional Reporting Currency")
            then
                Error(CannotUnapplyExchRateErr, NewPostingDate);
    end;

    local procedure FindLastApplTransactionEntry(VendLedgEntryNo: Integer): Integer
    var
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        LastTransactionNo: Integer;
    begin
        DtldVendLedgEntry.SetCurrentKey("Vendor Ledger Entry No.", "Entry Type");
        DtldVendLedgEntry.SetRange("Vendor Ledger Entry No.", VendLedgEntryNo);
        DtldVendLedgEntry.SetRange("Entry Type", DtldVendLedgEntry."Entry Type"::Application);
        LastTransactionNo := 0;
        if DtldVendLedgEntry.Find('-') then
            repeat
                if (DtldVendLedgEntry."Transaction No." > LastTransactionNo) and not DtldVendLedgEntry.Unapplied then
                    LastTransactionNo := DtldVendLedgEntry."Transaction No.";
            until DtldVendLedgEntry.Next = 0;
        exit(LastTransactionNo);
    end;

    local procedure FindLastTransactionNo(VendLedgEntryNo: Integer): Integer
    var
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        LastTransactionNo: Integer;
    begin
        with DtldVendLedgEntry do begin
            SetCurrentKey("Vendor Ledger Entry No.", "Entry Type");
            SetRange("Vendor Ledger Entry No.", VendLedgEntryNo);
            SetRange(Unapplied, false);
            SetFilter("Entry Type", '<>%1&<>%2', "Entry Type"::"Unrealized Loss", "Entry Type"::"Unrealized Gain");
            LastTransactionNo := 0;
            if FindSet then
                repeat
                    if LastTransactionNo < "Transaction No." then
                        LastTransactionNo := "Transaction No.";
                until Next = 0;
        end;
        exit(LastTransactionNo);
    end;

    procedure PostUnApplyUniqueVendor(DtldVendLedgEntry2: Record "Detailed Vendor Ledg. Entry"; DocNo: Code[20]; PostingDate: Date; FilterVendorLedgerEntryNos: Text)
    var
        GLEntry: Record "G/L Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        SourceCodeSetup: Record "Source Code Setup";
        GenJnlLine: Record "Gen. Journal Line";
        DateComprReg: Record "Date Compr. Register";
        TempVendorLedgerEntry: Record "Vendor Ledger Entry" temporary;
        STAdjustExchangeRates: Report "ST Adjust Exchange Rates";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        GenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";
        Window: Dialog;
        LastTransactionNo: Integer;
        AddCurrChecked: Boolean;
        MaxPostingDate: Date;
    begin
        MaxPostingDate := 0D;
        GLEntry.LockTable();
        DtldVendLedgEntry.LockTable();
        VendLedgEntry.LockTable();
        VendLedgEntry.Get(DtldVendLedgEntry2."Vendor Ledger Entry No.");
        CheckPostingDate(PostingDate, MaxPostingDate);
        if PostingDate < DtldVendLedgEntry2."Posting Date" then
            Error(MustNotBeBeforeErr);
        if DtldVendLedgEntry2."Transaction No." = 0 then begin
            DtldVendLedgEntry.SetCurrentKey("Application No.", "Vendor No.", "Entry Type");
            DtldVendLedgEntry.SetRange("Application No.", DtldVendLedgEntry2."Application No.");
        end else begin
            DtldVendLedgEntry.SetCurrentKey("Transaction No.", "Vendor No.", "Entry Type");
            DtldVendLedgEntry.SetRange("Transaction No.", DtldVendLedgEntry2."Transaction No.");
        end;
        DtldVendLedgEntry.SetRange("Vendor No.", DtldVendLedgEntry2."Vendor No.");
        DtldVendLedgEntry.SetFilter("Entry No.", FilterVendorLedgerEntryNos);
        DtldVendLedgEntry.SetFilter("Entry Type", '<>%1', DtldVendLedgEntry."Entry Type"::"Initial Entry");
        DtldVendLedgEntry.SetRange(Unapplied, false);
        if DtldVendLedgEntry.Find('-') then
            repeat
                if not AddCurrChecked then begin
                    CheckAdditionalCurrency(PostingDate, DtldVendLedgEntry."Posting Date");
                    AddCurrChecked := true;
                end;
                CheckReversal(DtldVendLedgEntry."Vendor Ledger Entry No.");
                if DtldVendLedgEntry."Transaction No." <> 0 then begin
                    if DtldVendLedgEntry."Entry Type" = DtldVendLedgEntry."Entry Type"::Application then begin
                        LastTransactionNo :=
                          FindLastApplTransactionEntry(DtldVendLedgEntry."Vendor Ledger Entry No.");
                        if (LastTransactionNo <> 0) and (LastTransactionNo <> DtldVendLedgEntry."Transaction No.") then
                            Error(UnapplyAllPostedAfterThisEntryErr, DtldVendLedgEntry."Vendor Ledger Entry No.");
                    end;
                    LastTransactionNo := FindLastTransactionNo(DtldVendLedgEntry."Vendor Ledger Entry No.");
                    if (LastTransactionNo <> 0) and (LastTransactionNo <> DtldVendLedgEntry."Transaction No.") then
                        Error(LatestEntryMustBeApplicationErr, DtldVendLedgEntry."Vendor Ledger Entry No.");
                end;
            until DtldVendLedgEntry.Next = 0;

        DateComprReg.CheckMaxDateCompressed(MaxPostingDate, 0);

        with DtldVendLedgEntry2 do begin
            SourceCodeSetup.Get();
            VendLedgEntry.Get("Vendor Ledger Entry No.");
            GenJnlLine."Document No." := DocNo;
            GenJnlLine."Posting Date" := PostingDate;
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::Vendor;
            GenJnlLine."Account No." := "Vendor No.";
            GenJnlLine.Correction := true;
            GenJnlLine."Document Type" := "Document Type";
            GenJnlLine.Description := VendLedgEntry.Description;
            GenJnlLine."Shortcut Dimension 1 Code" := VendLedgEntry."Global Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code" := VendLedgEntry."Global Dimension 2 Code";
            GenJnlLine."Dimension Set ID" := VendLedgEntry."Dimension Set ID";
            GenJnlLine."Posting Group" := VendLedgEntry."Vendor Posting Group";
            GenJnlLine."Source Type" := GenJnlLine."Source Type"::Vendor;
            GenJnlLine."Source No." := "Vendor No.";
            GenJnlLine."Source Code" := SourceCodeSetup."Unapplied Purch. Entry Appln.";
            GenJnlLine."Source Currency Code" := "Currency Code";
            GenJnlLine."System-Created Entry" := true;
            Window.Open(UnapplyingMsg);
            CollectAffectedLedgerEntries(TempVendorLedgerEntry, DtldVendLedgEntry2);
            GenJnlPostLine.UnapplyUniqueVendLedgEntry_ULN(GenJnlLine, DtldVendLedgEntry2, FilterVendorLedgerEntryNos);
            STAdjustExchangeRates.AdjustExchRateVend(GenJnlLine, TempVendorLedgerEntry);

            if PreviewMode then
                GenJnlPostPreview.ThrowError;

            Commit();
            Window.Close;
        end;
    end;

    var
        PreviewMode: Boolean;
        UnapplyingMsg: Label 'Unapplying and posting...';
        NotAllowedPostingDatesErr: Label 'Posting date is not within the range of allowed posting dates.';
        LatestEntryMustBeApplicationErr: Label 'The latest Transaction No. must be an application in Vendor Ledger Entry No. %1.';
        UnapplyAllPostedAfterThisEntryErr: Label 'Before you can unapply this entry, you must first unapply all application entries in Vendor Ledger Entry No. %1 that were posted after this entry.';
        CannotUnapplyExchRateErr: Label 'You cannot unapply the entry with the posting date %1, because the exchange rate for the additional reporting currency has been changed.';
        atestEntryMustBeApplicationErr: Label 'The latest Transaction No. must be an application in Vendor Ledger Entry No. %1.';
        MustNotBeBeforeErr: Label 'The posting date entered must not be before the posting date on the vendor ledger entry.';
        NoApplicationEntryErr: Label 'Vendor Ledger Entry No. %1 does not have an application entry.';
        CannotUnapplyInReversalErr: Label 'You cannot unapply Vendor Ledger Entry No. %1 because the entry is part of a reversal.';
}