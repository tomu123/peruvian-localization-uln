pageextension 51016 "Acc. Book VAT Posting Stp Card" extends "VAT Posting Setup Card"
{
    layout
    {
        // Add changes to page layout here
        addafter(General)
        {
            group(AccountantBooks)
            {
                Caption = 'Accountant Books';
                field("Purchase Record Type"; "Purchase Record Type")
                {
                    ApplicationArea = All;
                    Importance = Standard;
                }
                field("Sales Record Type"; "Sales Record Type")
                {
                    ApplicationArea = All;
                    Importance = Standard;
                }
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