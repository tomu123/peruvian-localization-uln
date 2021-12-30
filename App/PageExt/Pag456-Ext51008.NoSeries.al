pageextension 51008 "Legal Doc. No Series" extends "No. Series"
{
    layout
    {
        // Add changes to page layout here
        addafter("Date Order")
        {
            field("Operation Type"; "Operation Type")
            {
                ApplicationArea = All;
            }
            field("Legal Document"; "Legal Document")
            {
                ApplicationArea = All;
            }

            field("Legal Status"; "Legal Status")
            {
                ApplicationArea = All;
            }
            field("Internal Operation"; "Internal Operation")
            {
                ApplicationArea = All;
            }
        }
    }

    var
        myInt: Integer;
}