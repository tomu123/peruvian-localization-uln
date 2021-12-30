pageextension 51085 "Detrac. Posted Purch. Invoices" extends "Posted Purchase Invoices"
{
    layout
    {
        // Add changes to page layout here
        modify("Posting Date")
        {
            Visible = true;
        }
        addafter(Corrective)
        {
            field("Legal Document"; "Legal Document")
            {
                ApplicationArea = Basic, Suite;
            }

            field("Legal Status"; "Legal Status")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Purch. Detraction"; "Purch. Detraction")
            {
                ApplicationArea = All;
            }
        }
        addafter("Buy-from Vendor Name")
        {
            field("Posting Text"; "Posting Text")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        modify(Correct)
        {
            Visible = false;
            Enabled = false;
        }
        modify(CreateCreditMemo)
        {
            Visible = false;
            Enabled = false;
        }
        addlast(Correct)
        {

            action(CorrectLegalDocAction)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Correct Ext.', Comment = 'ESM="Extornar"';
                ToolTip = 'Reverse this posted invoice and automatically create a new invoice with the same information that you can correct before posting. This posted invoice will automatically be canceled.';
                Image = Undo;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                Scope = "Repeater";
                trigger OnAction()
                var
                    NewDocumentNo: Code[20];
                begin
                    NewDocumentNo := Rec."No.";
                    LDCorrectPstdDoc.PurchCorrectInvoice(Rec);
                    //Get(NewDocumentNo);
                    SelectLatestVersion();
                end;
            }

            action(CancellLegalDocAction)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cancell', Comment = 'ESM="Cancelar"';
                ToolTip = 'Reverse this posted invoice and automatically create a new invoice with the same information that you can correct before posting. This posted invoice will automatically be canceled.';
                Image = Undo;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                Scope = "Repeater";
                Visible = false;
                Enabled = false;
                trigger OnAction()
                begin
                    //LegalDocMgt.PurchCancellInvoice(Rec);
                end;
            }
        }

        modify(CorrectInvoice)
        {
            Enabled = false;
            Visible = false;
        }

        modify(CancelInvoice)
        {
            Enabled = false;
            Visible = false;
        }
    }

    trigger OnOpenPage()
    begin
        FilterGroup(4);
        if not LookupMode then
            SetFilter("Legal Document", '<>%1', '02');
        FilterGroup(0);
    end;

    var
        LDCorrectPstdDoc: Codeunit "LD Correct Posted Documents";
}