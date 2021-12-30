pageextension 51265 "ST Fixed Asset List" extends "Fixed Asset List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        modify(CalculateDepreciation)
        {
            Enabled = false;
            Visible = false;
        }
        addafter("Recurring Fixed Asset Journal")
        {

            action(STCalculateDepreciation)
            {
                ApplicationArea = FixedAssets;
                Caption = 'Calculate Depreciation', Comment = 'ESM="Calcular Amortización"';
                Ellipsis = true;
                Image = CalculateDepreciation;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Calculate depreciation according to conditions that you specify. If the related depreciation book is set up to integrate with the general ledger, then the calculated entries are transferred to the fixed asset general ledger journal. Otherwise, the calculated entries are transferred to the fixed asset journal. You can then review the entries and post the journal.';

                trigger OnAction()
                begin
                    REPORT.RunModal(REPORT::"ST Calculate Depreciation", true, false, Rec);
                end;
            }
        }
    }

    var
        myInt: Integer;
}