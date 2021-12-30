pageextension 51115 "PS Apply Vendor Entries" extends "Apply Vendor Entries"
{
    procedure fnExternalQueryClose(VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin

    end;

    procedure fnExternalOpen()
    begin
        IF CalcType = CalcType::Direct THEN BEGIN
            Vend.GET("Vendor No.");
            ApplnCurrencyCode := Vend."Currency Code";
            FindApplyingEntry;
        END;

        AppliesToIDVisible := ApplnType <> ApplnType::"Applies-to Doc. No.";

        GLSetup.GET;

        IF CalcType = CalcType::GenJnlLine THEN
            CalcApplnAmount;
        PostingDone := FALSE;
    end;

    procedure FindApplyingEntry()
    begin
        IF CalcType = CalcType::Direct THEN BEGIN
            VendEntryApplID := USERID;
            IF VendEntryApplID = '' THEN
                VendEntryApplID := '***';

            VendLedgEntry.SETCURRENTKEY("Vendor No.", "Applies-to ID", Open);
            VendLedgEntry.SETRANGE("Vendor No.", "Vendor No.");
            IF AppliesToID = '' THEN
                VendLedgEntry.SETRANGE("Applies-to ID", VendEntryApplID)
            ELSE
                VendLedgEntry.SETRANGE("Applies-to ID", AppliesToID);
            VendLedgEntry.SETRANGE(Open, TRUE);
            VendLedgEntry.SETRANGE("Applying Entry", TRUE);
            IF VendLedgEntry.FINDFIRST THEN BEGIN
                VendLedgEntry.CALCFIELDS(Amount, "Remaining Amount");
                ApplyingVendLedgEntry := VendLedgEntry;
                SETFILTER("Entry No.", '<>%1', VendLedgEntry."Entry No.");
                ApplyingAmount := VendLedgEntry."Remaining Amount";
                ApplnDate := VendLedgEntry."Posting Date";
                ApplnCurrencyCode := VendLedgEntry."Currency Code";
            END;
            CalcApplnAmount;
        END;
    end;

    var
        VendLedgEntry: Record "Vendor Ledger Entry";
        GenJnlLine: Record "Gen. Journal Line";
        CalcType: Option Direct,GenJnlLine,PurchHeader;
        Vend: Record Vendor;
        PostingDone: Boolean;
        AppliesToIDVisible: Boolean;
        ApplnType: Option " ","Applies-to Doc. No.","Applies-to ID";
        ApplnCurrencyCode: Code[10];
        GLSetup: Record "General Ledger Setup";
        VendEntryApplID: Code[50];
        ApplyingVendLedgEntry: Record "Vendor Ledger Entry" temporary;
        AppliesToID: Code[50];
        ApplyingAmount: Decimal;
        ApplnDate: Date;
}