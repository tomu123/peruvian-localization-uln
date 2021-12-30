pageextension 51004 "Legal Doc. VAT Entries" extends "VAT Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter("Document No.")
        {
            field("Legal Document"; "Legal Document")
            {
                ApplicationArea = All;
            }

            field("Legal Status"; "Legal Status")
            {
                ApplicationArea = All;
            }
        }
        addafter("Internal Ref. No.")
        {
            field("Correlative CUO"; "Correlative CUO")
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