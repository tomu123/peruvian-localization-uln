pageextension 51244 "ST Bank Account List " extends "Bank Account List"
{ //ULN::PC    002 Function Add fnGetExtractAmount
    layout
    {
        addafter("Currency Code")
        {
            field("Balance Extract The Bank"; fnGetExtractAmount(Rec."No."))
            {
                Caption = 'Balance Extract The Bank', Comment = 'ESM="Saldo Extracto bancario"';

                ApplicationArea = All;

            }
            field("Balance Extr.Bank Closed"; "Balance Extr.Bank Closed")
            {
                ApplicationArea = All;
            }
            field("Balance Extr.Bank Open"; "Balance Extr.Bank Open")
            {
                ApplicationArea = All;
            }
            field("Count Extract The Bank"; fnGetExtracCount(Rec."No."))
            {
                Caption = 'Count Extract The Bank', Comment = 'ESM="Mov. Cerrados del Extracto bancario"';
                Editable = false;
                ApplicationArea = All;
                trigger OnDrillDown()
                var
                    lclExtractTheBank: Record "Extract The Bank";
                    lclpageExtractTheBank: page "Extract The Bank List";
                begin
                    Clear(lclpageExtractTheBank);
                    lclExtractTheBank.Reset();
                    lclExtractTheBank.SetRange("Bank Account No.", Rec."No.");
                    if lclExtractTheBank.FindSet() then begin
                    end;

                    lclpageExtractTheBank.fnSetBank(Rec."No.");
                    lclpageExtractTheBank.SetTableView(lclExtractTheBank);
                    lclpageExtractTheBank.RunModal();

                end;

            }
        }
        addlast(Control1)
        {
            field(Balance; Balance)
            {
                ApplicationArea = All;
            }
            field("Balance (LCY)"; "Balance (LCY)")
            {
                ApplicationArea = All;

            }
            field("Balance at Date"; "Balance at Date")
            {
                ApplicationArea = All;
            }
            field("Balance at Date (LCY)"; "Balance at Date (LCY)")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter("&Bank Acc.")
        {
            action("Extract the Bank")
            {
                ApplicationArea = All;
                Caption = 'Extract the Bank', Comment = 'ESM="Extracto del banco"';
                Image = Report;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    lclExtractTheBank: Record "Extract The Bank";
                    lclpageExtractTheBank: page "Extract The Bank List";
                begin
                    Clear(lclpageExtractTheBank);
                    lclExtractTheBank.Reset();
                    lclExtractTheBank.SetRange("Bank Account No.", Rec."No.");
                    if lclExtractTheBank.FindSet() then begin
                    end;

                    lclpageExtractTheBank.fnSetBank(Rec."No.");
                    lclpageExtractTheBank.SetTableView(lclExtractTheBank);
                    lclpageExtractTheBank.RunModal();

                end;

            }
        }
    }

    trigger OnAfterGetRecord()
    begin

    end;

    var

}