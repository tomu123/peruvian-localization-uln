codeunit 51016 "FT Free Title Management"
{
    trigger OnRun()
    begin

    end;

    procedure FreeTitleInvoice(var pSalesHeader: Record "Sales Header")
    var
        Item: Record Item;
        GLAcc: Record "G/L Account";
        LineNo: Integer;
        MsgChange: Label '%1 changued to %2', Comment = 'ESM="%1 cargado a %2"';
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        GetLSetup();
        if not LSetup."FT Free Title" then
            exit;
        LineNo := 0;
        case pSalesHeader."FT Free Title" of
            true:
                begin
                    LineNo := GetLastLineNo(pSalesHeader);
                    SalesLine.Reset();
                    SalesLine.SetCurrentKey("Document Type", "Document No.", "Line No.");
                    SalesLine.SetRange("Document No.", pSalesHeader."No.");
                    SalesLine.SetRange("Document Type", pSalesHeader."Document Type");
                    SalesLine.SetFilter(Quantity, '>%1', 0);
                    if SalesLine.FindFirst() then
                        repeat
                            LineNo += 10000;
                            SalesLine.Validate("Gen. Bus. Posting Group", LSetup."FT Gen. Bus. Posting Group");
                            SalesLine.Modify();
                            GPSetup.Get(SalesLine."Gen. Bus. Posting Group", SalesLine."Gen. Prod. Posting Group");
                            GPSetup.TestField("Sales Account");
                            VATPostingSetup.Reset();
                            VATPostingSetup.Get(SalesLine."VAT Bus. Posting Group", SalesLine."VAT Prod. Posting Group");
                            SalesLine2.Init();
                            SalesLine2."Document No." := pSalesHeader."No.";
                            SalesLine2."Document Type" := pSalesHeader."Document Type";
                            SalesLine2."Line No." := LineNo;
                            SalesLine2.Validate(Type, SalesLine2.Type::"G/L Account");
                            if SalesLine.Type = SalesLine.Type::"G/L Account" then
                                SalesLine2.Validate("No.", SalesLine."No.")
                            else
                                SalesLine2.Validate("No.", GPSetup."Sales Account");
                            SalesLine2.Validate(Quantity, -1);
                            if VATPostingSetup."VAT %" = 18 then
                                SalesLine2.Validate("VAT Prod. Posting Group", LSetup."FT VAT Prod. Posting Group")

                            else
                                SalesLine2.Validate("VAT Prod. Posting Group", SalesLine."VAT Prod. Posting Group");
                            SalesLine2.Validate("Unit Price", SalesLine."Line Amount");
                            SalesLine2."FT Free Title Line" := true;
                            SalesLine2.Insert();
                        until SalesLine.Next() = 0;
                    Message(MsgChange, LSetup.FieldCaption("FT Gen. Bus. Posting Group"), LSetup."FT Gen. Bus. Posting Group");
                end;
            false:
                begin
                    Customer.Get(pSalesHeader."Sell-to Customer No.");
                    pSalesHeader."Customer Posting Group" := Customer."Customer Posting Group";
                    SalesLine.Reset();
                    SalesLine.SetRange("Document Type", pSalesHeader."Document Type");
                    SalesLine.SetRange("Document No.", pSalesHeader."No.");
                    if SalesLine.FindFirst() then
                        repeat
                            SalesLine.Validate("Gen. Bus. Posting Group", Customer."Gen. Bus. Posting Group");
                            case SalesLine.Type of
                                SalesLine.Type::Item:
                                    begin
                                        Item.Get(SalesLine."No.");
                                        SalesLine.Validate("VAT Prod. Posting Group", Item."VAT Prod. Posting Group");
                                    end;
                                SalesLine.Type::"G/L Account":
                                    begin
                                        GLAcc.Get(SalesLine."No.");
                                        SalesLine.Validate("VAT Prod. Posting Group", GLAcc."VAT Prod. Posting Group");
                                    end;
                            end;
                            SalesLine.Modify();
                            SalesLine2.Reset();
                            SalesLine2.SetRange("Document Type", SalesLine."Document Type");
                            SalesLine2.SetRange("Document No.", SalesLine."Document No.");
                            SalesLine2.SetRange("FT Free Title Line", true);
                            SalesLine2.DeleteAll();
                        until SalesLine.Next() = 0;
                    Message(MsgChange, Customer.FieldCaption("Gen. Bus. Posting Group"), Customer."Gen. Bus. Posting Group");
                end;
        end;
    end;

    local procedure GetLastLineNo(var pSalesHeader: Record "Sales Header"): Integer
    begin
        SalesLine.Reset();
        SalesLine.SetCurrentKey("Document Type", "Document No.", "Line No.");
        SalesLine.SetRange("Document No.", pSalesHeader."No.");
        SalesLine.SetRange("Document Type", pSalesHeader."Document Type");
        if SalesLine.Find('+') then
            exit(SalesLine."Line No.");
    end;

    local procedure GetLSetup()
    begin
        LSetup.Get();
        if not LSetup."FT Free Title" then
            exit;
        LSetup.TestField("FT Gen. Bus. Posting Group");
        LSetup.TestField("FT VAT Prod. Posting Group");
    end;

    var
        LSetup: Record "Setup Localization";
        GPSetup: Record "General Posting Setup";
        Customer: Record Customer;
        SalesLine: Record "Sales Line";
        SalesLine2: Record "Sales Line";
}