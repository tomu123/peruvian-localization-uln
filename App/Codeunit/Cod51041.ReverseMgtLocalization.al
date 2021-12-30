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

    var
        STSetup: Record "Setup Localization";
        ReverseInformationPage: Page "Standard Dialog Page";
        ReverseDate: Date;
        PostingDate: Date;
        EnabledProcess: Boolean;
        ReverseReason: Text;
        ReverseDocumentNoFilter: Text;
}