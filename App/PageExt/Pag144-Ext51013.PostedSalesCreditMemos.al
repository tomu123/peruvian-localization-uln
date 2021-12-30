pageextension 51013 "Legal Doc. Pstd Sales CrMemos" extends "Posted Sales Credit Memos"
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
        }

    }

    actions
    {
        // Add changes to page actions here
        addlast(Cancel)
        {
            action(CorrectLegalDocAction)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Correct Ext.';
                ToolTip = 'Create and post a sales credit memo that reverses this posted sales invoice. This posted purchase credit memo will be canceled.';
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
                    LDCorrectPstdDoc.SalesCorrectCreditMemo(Rec);
                    Get(NewDocumentNo);
                    SelectLatestVersion();
                end;
            }

            action(CancellLegalDocAction)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cancell L.D.';
                ToolTip = 'Create and post a purchase invoice that reverses this posted purchase credit memo. This posted purchase credit memo will be canceled.';
                Image = Undo;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                Scope = "Repeater";
                trigger OnAction()
                begin
                    LDCorrectPstdDoc.SalesCancelCreditMemo(Rec);
                end;
            }
        }

        modify(CancelCrMemo)
        {
            Enabled = false;
            Visible = false;
        }
    }

    var
        LDCorrectPstdDoc: Codeunit "LD Correct Posted Documents";
}