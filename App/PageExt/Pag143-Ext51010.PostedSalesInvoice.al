pageextension 51010 "Legal Doc. Pstd Sales Inv." extends "Posted Sales Invoices"
{
    layout
    {
        // Add changes to page layout here
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
            field("Setup Source Code to User"; "Setup Source Code to User")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field("Active Supply No."; "Active Supply No.")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field("User ID"; "User ID")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addlast(Correct)
        {

            action(CorrectLegalDocAction)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Correct Ext.', Comment = 'ESM="Extornar"';
                ToolTip = 'Reverse this posted invoice and automatically create a new invoice with the same information that you can correct before posting. This posted invoice will automatically be canceled.';
                Image = Undo;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                PromotedOnly = true;
                Scope = "Repeater";
                trigger OnAction()
                var
                    NewDocumentNo: Code[20];
                begin
                    NewDocumentNo := Rec."No.";
                    LDCorrectPstdDoc.SalesCorrectInvoice(Rec);
                    // Get(NewDocumentNo);
                    SelectLatestVersion();
                end;
            }

            action(CancellLegalDocAction)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cancel', Comment = 'ESM="Anular"';
                ToolTip = 'Reverse this posted invoice and automatically create a new invoice with the same information that you can correct before posting. This posted invoice will automatically be canceled.';
                Image = Undo;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                PromotedOnly = true;
                Scope = "Repeater";
                trigger OnAction()
                begin
                    LDCorrectPstdDoc.SalesCancelInvoice(Rec);
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
    var
        myInt: Integer;
    begin
        FilterGroup(2);
        SetFilter("Internal Consumption", '%1', false);
        FilterGroup(0);
    end;

    var
        LDCorrectPstdDoc: Codeunit "LD Correct Posted Documents";
}