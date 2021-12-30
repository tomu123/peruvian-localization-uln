pageextension 51194 "PR Approval User Setup" extends "Approval User Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter(Substitute)
        {
            field("PR Automatic Delegate Active"; "PR Automatic Delegate Active")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("Notification Setup")
        {
            action(AllDelegate)
            {
                ApplicationArea = All;
                Caption = 'All Delegate', Comment = 'ESM="Delegar todos"';
                Image = Delegate;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = codeunit "PR Purchase Validate";
            }
        }
    }

    var
        myInt: Integer;
}