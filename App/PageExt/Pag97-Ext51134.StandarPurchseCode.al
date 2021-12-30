pageextension 51134 "PR Purch. Quote Subform" extends "Purchase Quote Subform"
{
    layout
    {
        modify(Description)
        {
            Editable = True;//ShowDescription;
        }
        addafter(Description)
        {
            field("Description 2"; "Description 2")
            {
                ApplicationArea = All;
                Editable = True;//ShowDescription;
            }
        }
        addafter("Qty. Assigned")
        {
            field("Job No."; "Job No.")
            {
                ApplicationArea = All;
            }
            field("Job Task No."; "Job Task No.")
            {
                ApplicationArea = All;
            }
        }

        //Purchase Request
        addafter("No.")
        {
            field("Standard Purchases Code"; "Purchase Standard Code")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addafter(DocAttach)
        {
            action(GenericPurchase)
            {
                Caption = 'Generic Purchase', Comment = 'ESM="Compra genérica"';
                Image = PurchaseInvoice;

                trigger OnAction()
                begin
                    FillGenericPurchase();
                end;
            }
        }
    }

    var
        ShowDescription: Boolean;

    local procedure FillGenericPurchase()
    var
        PurchaseLine: Record "Purchase Line";
        GLAccount: Record "G/L Account";
        Text001: label 'Generic purchase lines are added, you want to continue';
        lclLineNo: Integer;
    begin
        if Confirm(Text001, true) then begin
            GLAccount.Reset;
            GLAccount.SetRange("PR Generic Purchase", true);
            if GLAccount.FindSet then begin
                repeat
                    PurchaseLine.Reset;
                    PurchaseLine.CopyFilters(Rec);
                    if PurchaseLine.FindLast() then
                        lclLineNo := PurchaseLine."Line No." + 10000
                    else
                        lclLineNo := 10000;

                    PurchaseLine.Reset;
                    PurchaseLine.CopyFilters(Rec);
                    if PurchaseLine.FindSet then begin
                        repeat
                            if PurchaseLine."No." = GLAccount."No." then
                                Error('Ya existe linea tipo cuenta compra genérica!');

                        until PurchaseLine.Next = 0;
                    end;

                    PurchaseLine.init;
                    PurchaseLine.Validate("Document Type", PurchaseLine."Document Type"::Quote);
                    PurchaseLine.Validate("Document No.", "Document No.");
                    PurchaseLine.Validate("Line No.", lclLineNo);
                    PurchaseLine.Validate(Type, PurchaseLine.Type::"G/L Account");
                    PurchaseLine.Validate("No.", GLAccount."No.");
                    PurchaseLine.Insert;
                until GLAccount.Next = 0;
            end;
            CurrPage.Update();
        end;

    end;

    trigger OnAfterGetRecord()
    var
        GLAccount: Record "G/L Account";
        PurchaseLine: Record "Purchase Line";
    begin
        ShowDescription := false;

        PurchaseLine.Reset;
        PurchaseLine.SetRange("Document Type", Rec."Document Type");
        PurchaseLine.SetRange("Line No.", Rec."Line No.");
        PurchaseLine.SetRange(Type, Type::"G/L Account");
        if PurchaseLine.FindSet then begin
            GLAccount.Reset;
            GLAccount.SetRange("No.", "No.");
            GLAccount.SetRange("PR Generic Purchase", true);
            if GLAccount.FindSet then
                ShowDescription := true;
        end;
    end;
}