tableextension 51223 "ST Bank Acc. Reconciliation" extends "Bank Acc. Reconciliation"
{
    fields
    { }

    procedure ImportBankStatementConcilation()
    var
        DataExch: Record "Data Exch.";
        ProcessBankAccRecLines: Codeunit "Mgtm Conciliation";
    begin
        //ULN::PC    002 Begin Conciliación ++++
        if BankAccountCouldBeUsedForImportConcilation then begin
            DataExch.Init();
            ProcessBankAccRecLines.ImportBankStatementConciliation(Rec, DataExch);
        end;
        //ULN::PC    002 Begin Conciliación ----
    end;

    local procedure BankAccountCouldBeUsedForImportConcilation(): Boolean
    var
        BankAccount: Record "Bank Account";
    begin
        //ULN::PC    002 Begin Conciliación +++++
        BankAccount.Get("Bank Account No.");
        if BankAccount."Import Format Statement" <> '' then
            exit(true);

        if BankAccount.IsLinkedToBankStatementServiceProvider then
            exit(true);

        if not Confirm(MustHaveValueQst, true, BankAccount.FieldCaption("Import Format Statement")) then
            exit(false);

        if PAGE.RunModal(PAGE::"Payment Bank Account Card", BankAccount) = ACTION::LookupOK then
            if BankAccount."Import Format Statement" <> '' then
                exit(true);

        exit(false);
        //ULN::PC    002 Begin Conciliación ----
    end;

    var
        MustHaveValueQst: Label 'The bank account must have a value in %1. Do you want to open the bank account card?', Comment = 'ESM="La cuenta bancaria debe tener un valor en %1. ¿Quieres abrir la tarjeta de cuenta bancaria?"';

}