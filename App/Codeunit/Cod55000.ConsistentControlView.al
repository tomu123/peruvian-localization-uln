codeunit 55000 "Consistent control"
{
    SingleInstance = true;

    trigger OnRun()
    begin
        OnMyRun();
    end;

    var
        STSetup: Record "Setup Localization";
        TempGLEntry: Record "G/L Entry" temporary;
        StoreToTemp: Boolean;
        MyIsTransactionConsistent: Boolean;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterSettingIsTransactionConsistent', '', false, false)]
    local procedure SetOnAfterSettingIsTransactionConsistent_12_Codeunit(GenJournalLine: Record "Gen. Journal Line"; var IsTransactionConsistent: Boolean)
    begin
        STSetup.Get();
        if not STSetup."ST Show Error Consistent" then
            exit;
        MyIsTransactionConsistent := IsTransactionConsistent;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInsertGlobalGLEntry', '', false, false)]
    local procedure SetOnAfterInsertGlobalGLEntry_12_Codeunit(var GLEntry: Record "G/L Entry"; var TempGLEntryBuf: Record "G/L Entry"; var NextEntryNo: Integer)
    begin
        STSetup.Get();
        if not STSetup."ST Show Error Consistent" then
            exit;
        InsertGLEntry(GLEntry);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterFinalizePostingOnBeforeCommit', '', false, false)]
    local procedure SetOnAfterFinalizePostingOnBeforeCommit_80_Codeunit(var SalesHeader: Record "Sales Header"; var SalesShipmentHeader: Record "Sales Shipment Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var ReturnReceiptHeader: Record "Return Receipt Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; WhseShip: Boolean; WhseReceive: Boolean)
    begin
        STSetup.Get();
        if not STSetup."ST Show Error Consistent" then
            exit;
        OnMyRun();
    end;

    local procedure OnMyRun()
    begin
        if not StoreToTemp then
            StoreToTemp := true
        else
            Page.Run(0, TempGLEntry);
    end;

    local procedure InsertGLEntry(GLEntry: Record "G/L Entry");
    begin
        STSetup.Get();
        if not STSetup."ST Show Error Consistent" then
            exit;
        StoreToTemp := true;
        if StoreToTemp then begin
            TempGLEntry := GLEntry;
            if not TempGLEntry.Insert() then begin
                TempGLEntry.DeleteAll();
                TempGLEntry.Insert();
            end;
        end;
    end;
}