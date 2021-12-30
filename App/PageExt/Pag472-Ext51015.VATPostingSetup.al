pageextension 51015 "Acc. Book VAT Posting Stp List" extends "VAT Posting Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("Tax Category")
        {
            field("Purchase Record Type"; "Purchase Record Type")
            {
                ApplicationArea = All;
            }
            field("Sales Record Type"; "Sales Record Type")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}