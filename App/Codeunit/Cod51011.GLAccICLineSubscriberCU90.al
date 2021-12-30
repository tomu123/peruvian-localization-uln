
codeunit 51011 "GLAccICLine Subscriber"
{
    //SingleInstance = true;
    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnInsertICGenJnlLineOnBeforeICGenJnlLineInsert', '', false, false)]
    local procedure MyProcedure(var TempICGenJournalLine: Record "Gen. Journal Line" temporary; PurchaseHeader: Record "Purchase Header"; PurchaseLine: Record "Purchase Line"; CommitIsSuppressed: Boolean)
    begin
        TempICGenJournalLine."Importation No." := PurchaseLine."Importation No.";
        //Message('Mensaje de Prueba.');
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromPurchHeader', '', true, true)]
    procedure SetCopyGenJnlLineFromPurchHeader(PurchaseHeader: Record "Purchase Header"; var GenJournalLine: Record "Gen. Journal Line")
    var
        PurchLine: Record "Purchase Line";
        Codeunit22: Codeunit 22;
    begin
        if GenJournalLine."Importation No." <> '' then
            exit;
        PurchLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchLine.SetRange("Document No.", PurchaseHeader."No.");
        PurchLine.SetFilter("Importation No.", '<>%1', '');
        if PurchLine.FindFirst() then
            GenJournalLine."Importation No." := PurchLine."Importation No.";
    end;

    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", 'OnAfterCopyGLEntryFromGenJnlLine', '', True, True)]
    procedure SetCopyGLEntryFromGenJnlLine(var GLEntry: Record "G/L Entry"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        GLEntry."Importation No." := GenJournalLine."Importation No.";
    end;

    //OnAfterInvPostBufferPreparePurchase(var PurchaseLine: Record "Purchase Line"; var InvoicePostBuffer: Record "Invoice Post. Buffer")

    [EventSubscriber(ObjectType::Table, Database::"Invoice Post. Buffer", 'OnAfterInvPostBufferPreparePurchase', '', true, true)]
    local procedure SetOnAfterInvPostBufferPreparePurchase(var PurchaseLine: Record "Purchase Line"; var InvoicePostBuffer: Record "Invoice Post. Buffer")
    begin
        InvoicePostBuffer."Importation No." := PurchaseLine."Importation No.";
    end;
    //OnAfterCopyGenJnlLineFromInvPostBuffer(InvoicePostBuffer: Record "Invoice Post. Buffer"; var GenJournalLine: Record "Gen. Journal Line")
    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromInvPostBuffer', '', true, true)]
    local procedure SetOnAfterCopyGenJnlLineFromInvPostBuffer(InvoicePostBuffer: Record "Invoice Post. Buffer"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."Importation No." := InvoicePostBuffer."Importation No.";
    end;
    //OnAfterCopyItemJnlLineFromPurchLine(var ItemJnlLine: Record "Item Journal Line"; PurchLine: Record "Purchase Line")
    [EventSubscriber(ObjectType::Table, database::"Item Journal Line", 'OnAfterCopyItemJnlLineFromPurchLine', '', true, true)]
    local procedure SetOnAfterCopyItemJnlLineFromPurchLine(var ItemJnlLine: Record "Item Journal Line"; PurchLine: Record "Purchase Line")
    begin
        ItemJnlLine."Importation No." := PurchLine."Importation No.";
    end;
    //OnBeforeInsertValueEntry(var ValueEntry: Record "Value Entry"; ItemJournalLine: Record "Item Journal Line"; var ItemLedgerEntry: Record "Item Ledger Entry"; var ValueEntryNo: Integer; var InventoryPostingToGL: Codeunit "Inventory Posting To G/L"; CalledFromAdjustment: Boolean)
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeInsertValueEntry', '', true, true)]
    local procedure SetOnBeforeInsertValueEntry(var ValueEntry: Record "Value Entry"; ItemJournalLine: Record "Item Journal Line"; var ItemLedgerEntry: Record "Item Ledger Entry"; var ValueEntryNo: Integer; var InventoryPostingToGL: Codeunit "Inventory Posting To G/L"; CalledFromAdjustment: Boolean)
    begin
        ValueEntry."Importation No." := ItemJournalLine."Importation No."
    end;
    //OnBeforeInsertItemLedgEntry(var ItemLedgerEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; TransferItem: Boolean)
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeInsertItemLedgEntry', '', true, true)]
    local procedure SetOnBeforeInsertItemLedgEntry(var ItemLedgerEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; TransferItem: Boolean)
    begin
        ItemLedgerEntry."Importation No." := ItemJournalLine."Importation No.";

    end;

    var
        Codeunit80: Codeunit 90;
        record81: Record 81;
        Codeunit22: Codeunit 22;
        Codeunit6227: Codeunit 6227;

}