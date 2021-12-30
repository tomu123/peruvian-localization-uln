pageextension 51171 "IMP Purch. Receipt Lines" extends "Purch. Receipt Lines"
{
    layout
    {
        // Add changes to page layout here
        addafter("Unit of Measure Code")
        {
            field("Importation No."; "Importation No.")
            {
                ApplicationArea = All;
            }
        }
        modify("Order No.")
        {
            Visible = true;
        }
    }

    actions
    {
        // Add changes to page actions here
    }

}