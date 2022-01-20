codeunit 51041 "Reverse Mgt. Localization"
{
    SingleInstance = true;

    trigger OnRun()
    begin

    end;

    procedure SetReverseDate(): Boolean
    begin
        if not EnabledProcess then
            exit;
        Clear(ReverseInformationPage);
        ReverseInformationPage.Caption := 'Información Reversión';
        ReverseInformationPage.SetType(3);
        ReverseInformationPage.SetReverseDate(ReverseDate);
        ReverseInformationPage.SetReverseReason(ReverseReason);
        ReverseInformationPage.LookupMode(true);
        if not (ReverseInformationPage.RunModal() in [Action::OK, Action::LookupOK]) then
            Error('Se canceló el proceso de reversión.');
        ReverseInformationPage.GetReverseInfo(ReverseDate, ReverseReason);
        if ReverseDate <= PostingDate then
            Error('La fecha de reversión %1 no debe ser menor o igual a la fecha de registro %2.', ReverseDate, PostingDate)
    end;

    procedure SetReverseDate(pReverseDate: Date)
    begin
        ReverseDate := pReverseDate;
        PostingDate := pReverseDate
    end;

    procedure SetReverseReason(pReverseReason: Text)
    begin
        ReverseReason := 'Rev. ' + pReverseReason
    end;

    procedure SetEnabledProcess()
    begin
        EnabledProcess := true;
    end;

    procedure SetDisabledProcess()
    begin
        EnabledProcess := false;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Reverse", 'OnReverseGLEntryOnBeforeInsertGLEntry', '', false, false)]
    local procedure SetOnReverseGLEntryOnBeforeInsertGLEntry_codeunit_17(var GLEntry: Record "G/L Entry"; GenJnlLine: Record "Gen. Journal Line"; GLEntry2: Record "G/L Entry")
    begin
        STSetup.Get();
        if not EnabledProcess then
            exit;
        if not STSetup."ST Enabled Reverse" then
            exit;
        if ReverseDate = 0D then
            exit;
        GLEntry."Posting Date" := ReverseDate;
        if ReverseReason = '' then
            exit;
        GLEntry.Description := ReverseReason;
        GLEntry."Diff. reversal posting date" := (GLEntry.Reversed) and (ReverseDate <> PostingDate)
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Reverse", 'OnReverseBankAccLedgEntryOnBeforeInsert', '', false, false)]
    local procedure SetOnReverseBankAccLedgEntryOnBeforeInsert_codeunit_17(var NewBankAccLedgEntry: Record "Bank Account Ledger Entry"; BankAccLedgEntry: Record "Bank Account Ledger Entry")
    begin
        NewBankAccLedgEntry."Diff. reversal posting date" := (NewBankAccLedgEntry.Reversed) and (ReverseDate <> PostingDate);
        if ReverseDate = 0D then
            exit;
        if (ReverseDate <> PostingDate) then
            NewBankAccLedgEntry."Posting Date" := ReverseDate;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Reverse", 'OnReverseCustLedgEntryOnBeforeInsertCustLedgEntry', '', false, false)]
    local procedure SetOnReverseCustLedgEntryOnBeforeInsertCustLedgEntry_codeunit_17(var NewCustLedgerEntry: Record "Cust. Ledger Entry"; CustLedgerEntry: Record "Cust. Ledger Entry")
    begin
        NewCustLedgerEntry."Diff. reversal posting date" := (NewCustLedgerEntry.Reversed) and (ReverseDate <> PostingDate);
        if ReverseDate = 0D then
            exit;
        if (ReverseDate <> PostingDate) then
            NewCustLedgerEntry."Posting Date" := ReverseDate;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Reverse", 'OnReverseVendLedgEntryOnBeforeInsertVendLedgEntry', '', false, false)]
    local procedure SetOnReverseVendLedgEntryOnBeforeInsertVendLedgEntry_codeunit_17(var NewVendLedgEntry: Record "Vendor Ledger Entry"; VendLedgEntry: Record "Vendor Ledger Entry")
    begin
        NewVendLedgEntry."Diff. reversal posting date" := (NewVendLedgEntry.Reversed) and (ReverseDate <> PostingDate);
        if ReverseDate = 0D then
            exit;
        if (ReverseDate <> PostingDate) then
            NewVendLedgEntry."Posting Date" := ReverseDate;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Reverse", 'OnReverseEmplLedgEntryOnBeforeInsertEmplLedgEntry', '', false, false)]
    local procedure SetOnReverseEmplLedgEntryOnBeforeInsertEmplLedgEntry_codeunit_17(var NewEmployeeLedgerEntry: Record "Employee Ledger Entry"; EmployeeLedgerEntry: Record "Employee Ledger Entry")
    begin
        NewEmployeeLedgerEntry."Diff. reversal posting date" := (NewEmployeeLedgerEntry.Reversed) and (ReverseDate <> PostingDate);
        if ReverseDate = 0D then
            exit;
        if (ReverseDate <> PostingDate) then
            NewEmployeeLedgerEntry."Posting Date" := ReverseDate;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Reverse", 'OnReverseCustLedgEntryOnBeforeInsertDtldCustLedgEntry', '', false, false)]
    local procedure SetOnReverseCustLedgEntryOnBeforeInsertDtldCustLedgEntry_codeunit17(var NewDtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry"; DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry")
    begin
        if ReverseDate = 0D then
            exit;
        if (ReverseDate <> PostingDate) then
            NewDtldCustLedgEntry."Posting Date" := ReverseDate;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Reverse", 'OnReverseVendLedgEntryOnBeforeInsertDtldVendLedgEntry', '', false, false)]
    local procedure SetOnReverseVendLedgEntryOnBeforeInsertDtldVendLedgEntry_codeunit17(var NewDtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry"; DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry")
    begin
        if ReverseDate = 0D then
            exit;
        if (ReverseDate <> PostingDate) then
            NewDtldVendLedgEntry."Posting Date" := ReverseDate;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Reverse", 'OnReverseEmplLedgEntryOnBeforeInsertDtldEmplLedgEntry', '', false, false)]
    local procedure SetOnReverseEmplLedgEntryOnBeforeInsertDtldEmplLedgEntry_codeunit17(var NewDetailedEmployeeLedgerEntry: Record "Detailed Employee Ledger Entry"; DetailedEmployeeLedgerEntry: Record "Detailed Employee Ledger Entry")
    begin
        if ReverseDate = 0D then
            exit;
        if (ReverseDate <> PostingDate) then
            NewDetailedEmployeeLedgerEntry."Posting Date" := ReverseDate;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Reversal Entry", 'OnBeforeCheckEntries', '', true, true)]
    procedure OnBeforeCheckEntriesULN(ReversalEntry: Record "Reversal Entry"; TableID: Integer; var SkipCheck: Boolean)
    var
        CustLE: Record "Cust. Ledger Entry";
        VendLE: Record "Vendor Ledger Entry";
        GLRegister: Record "G/L Register";
        Cust: Record Customer;
        Vend: Record Vendor;
    begin
        case TableID of
            21:
                begin
                    SkipCheck := true;
                    CustLE.Reset();
                    if ReversalEntry."Reversal Type" = ReversalEntry."Reversal Type"::Transaction then
                        CustLE.SetRange("Transaction No.", ReversalEntry."Transaction No.")
                    else
                        if ReversalEntry."Reversal Type" = ReversalEntry."Reversal Type"::Register then begin
                            GLRegister.Reset();
                            GLRegister.Get(ReversalEntry."G/L Register No.");
                            CustLE.SetRange("Entry No.", GLRegister."From Entry No.", GLRegister."To Entry No.");
                        end;
                    if CustLE.Find('-') then
                        repeat
                            Cust.Get(CustLE."Customer No.");
                            CheckPostingDate(
                              CustLE."Posting Date", CustLE.TableCaption, CustLE."Entry No.");
                            Cust.CheckBlockedCustOnJnls(Cust, CustLE."Document Type", false);
                            Cust.CheckBlockedCustOnJnls(Cust, CustLE."Document Type", false);

                            if CustLE.Reversed then
                                ReversalEntry.AlreadyReversedEntry(CustLE.TableCaption, CustLE."Entry No.");
                            CheckDtldCustLedgEntry(CustLE);
                        until CustLE.Next() = 0;

                end;
            25:
                begin
                    SkipCheck := true;
                    VendLE.Reset();
                    if ReversalEntry."Reversal Type" = ReversalEntry."Reversal Type"::Transaction then
                        VendLE.SetRange("Transaction No.", ReversalEntry."Transaction No.")
                    else
                        if ReversalEntry."Reversal Type" = ReversalEntry."Reversal Type"::Register then begin
                            GLRegister.Reset();
                            GLRegister.Get(ReversalEntry."G/L Register No.");
                            VendLE.SetRange("Entry No.", GLRegister."From Entry No.", GLRegister."To Entry No.");
                        end;
                    if VendLE.Find('-') then
                        repeat
                            Vend.Get(VendLE."Vendor No.");
                            CheckPostingDate(
                              VendLE."Posting Date", VendLE.TableCaption, VendLE."Entry No.");
                            Vend.CheckBlockedVendOnJnls(Vend, VendLE."Document Type", false);
                            if VendLE.Reversed then
                                ReversalEntry.AlreadyReversedEntry(VendLE.TableCaption, VendLE."Entry No.");
                            CheckDtldVendLedgEntry(VendLE);
                        until VendLE.Next() = 0;
                end;
        end;
    end;

    local procedure CheckPostingDate(PostingDate: Date; Caption: Text[50]; EntryNo: Integer)
    var
        GenJnlCheckLine: Codeunit "Gen. Jnl.-Check Line";
        Text001: Label 'You cannot reverse %1 No. %2 because the posting date is not within the allowed posting period.';
    begin
        if GenJnlCheckLine.DateNotAllowed(PostingDate) then
            Error(Text001, Caption, EntryNo);
        if PostingDate > MaxPostingDate then
            MaxPostingDate := PostingDate;
    end;

    local procedure CheckDtldCustLedgEntry(CustLedgEntry: Record "Cust. Ledger Entry")
    var
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
    begin
        DtldCustLedgEntry.SetCurrentKey("Cust. Ledger Entry No.", "Entry Type");
        DtldCustLedgEntry.SetRange("Cust. Ledger Entry No.", CustLedgEntry."Entry No.");
        DtldCustLedgEntry.SetFilter("Entry Type", '<>%1', DtldCustLedgEntry."Entry Type"::"Initial Entry");
        DtldCustLedgEntry.SetRange(Unapplied, false);
        if not DtldCustLedgEntry.IsEmpty then
            Error(ReversalErrorForChangedEntry(CustLedgEntry.TableCaption, CustLedgEntry."Entry No."));
        //OnAfterCheckDtldCustLedgEntry(DtldCustLedgEntry, CustLedgEntry);
    end;

    local procedure CheckDtldVendLedgEntry(VendLedgEntry: Record "Vendor Ledger Entry")
    var
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
    begin
        DtldVendLedgEntry.SetCurrentKey("Vendor Ledger Entry No.", "Entry Type");
        DtldVendLedgEntry.SetRange("Vendor Ledger Entry No.", VendLedgEntry."Entry No.");
        DtldVendLedgEntry.SetFilter("Entry Type", '<>%1', DtldVendLedgEntry."Entry Type"::"Initial Entry");
        DtldVendLedgEntry.SetRange(Unapplied, false);
        if not DtldVendLedgEntry.IsEmpty then
            Error(ReversalErrorForChangedEntry(VendLedgEntry.TableCaption, VendLedgEntry."Entry No."));
        //OnAfterCheckDtldVendLedgEntry(DtldVendLedgEntry, VendLedgEntry);
    end;

    procedure ReversalErrorForChangedEntry(TableName: Text[50]; EntryNo: Integer): Text[1024]
    var
        Text000: Label 'You cannot reverse %1 No. %2 because the entry is either applied to an entry or has been changed by a batch job.';
    begin
        exit(StrSubstNo(Text000, TableName, EntryNo));
    end;

    var
        STSetup: Record "Setup Localization";
        ReverseInformationPage: Page "Standard Dialog Page";
        ReverseDate: Date;
        PostingDate: Date;
        EnabledProcess: Boolean;
        ReverseReason: Text;
        ReverseDocumentNoFilter: Text;
        MaxPostingDate: Date;
}