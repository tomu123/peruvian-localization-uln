pageextension 51116 "PS Apply Customer Entries" extends "Apply Customer Entries"
{
    procedure fnExternalCustomerQueryClose(CustLedgerEntry: Record "Cust. Ledger Entry")
    begin
        IF CustLedgerEntry."Amount to Apply" = 0 THEN
            CustLedgerEntry."Amount to Apply" := "Remaining Amount";

        CODEUNIT.RUN(CODEUNIT::"Cust. Entry-Edit", CustLedgerEntry);

        //BEGIN ULN::JLM 002 ++ Cust. Entry-Edit
        GenJnlLine."Posting Group" := CustLedgerEntry."Customer Posting Group";
        //END ULN::JLM 002 ++
    end;

    procedure fnExternalOpen()
    begin
        IF CalcType = CalcType::Direct THEN BEGIN
            Cust.GET("Customer No.");
            ApplnCurrencyCode := Cust."Currency Code";
            FindApplyingEntry;
        END;

        AppliesToIDVisible := ApplnType <> ApplnType::"Applies-to Doc. No.";

        GLSetup.GET;

        IF CalcType = CalcType::GenJnlLine THEN
            CalcApplnAmount;
        PostingDone := FALSE;
    end;

    procedure fnExternalOpen(pOption: Integer)
    begin
        CalcType := pOption;
        IF CalcType = CalcType::Direct THEN BEGIN
            Cust.GET("Customer No.");
            ApplnCurrencyCode := Cust."Currency Code";
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
            CustEntryApplID := USERID;
            IF CustEntryApplID = '' THEN
                CustEntryApplID := '***';

            CustLedgEntry.SETCURRENTKEY("Customer No.", "Applies-to ID", Open);
            CustLedgEntry.SETRANGE("Customer No.", "Customer No.");
            CustLedgEntry.SETRANGE("Applies-to ID", CustEntryApplID);
            CustLedgEntry.SETRANGE(Open, TRUE);
            CustLedgEntry.SETRANGE("Applying Entry", TRUE);
            IF CustLedgEntry.FINDFIRST THEN BEGIN
                CustLedgEntry.CALCFIELDS(Amount, "Remaining Amount");
                ApplyingCustLedgEntry := CustLedgEntry;
                SETFILTER("Entry No.", '<>%1', CustLedgEntry."Entry No.");
                ApplyingAmount := CustLedgEntry."Remaining Amount";
                ApplnDate := CustLedgEntry."Posting Date";
                ApplnCurrencyCode := CustLedgEntry."Currency Code";
            END;
            CalcApplnAmount;
        END;
    end;

    var
        GenJnlLine: Record "Gen. Journal Line";
        CalcType: Option Direct,GenJnlLine,SalesHeader,ServHeader;
        AppliesToIDVisible: Boolean;
        ApplnType: Option " ","Applies-to Doc. No.","Applies-to ID";
        PostingDone: Boolean;
        Cust: Record Customer;
        GLSetup: Record "General Ledger Setup";
        ApplnCurrencyCode: Code[10];
        CustLedgEntry: Record "Cust. Ledger Entry";
        ApplyingAmount: Decimal;
        ApplnDate: Date;
        ApplyingCustLedgEntry: Record "Cust. Ledger Entry" temporary;
        CustEntryApplID: Code[50];
}