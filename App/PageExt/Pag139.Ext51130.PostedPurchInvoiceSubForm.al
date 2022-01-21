pageextension 51130 "ST Posted Purch. Inv. Subform" extends "Posted Purch. Invoice Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter("Job No.")
        {
            field("Purchase Standard Code"; "Purchase Standard Code")
            {
                ApplicationArea = All;
            }
            field("VAT Prod. Posting Group"; "VAT Prod. Posting Group")
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