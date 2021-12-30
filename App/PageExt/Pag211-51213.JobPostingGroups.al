pageextension 51213 "ST Job Posting Groups" extends "Job Posting Groups"
{
    layout
    {
        // Add changes to page layout here
        addafter("Recognized Sales Account")
        {
            field("ST Destination Prod. 79"; "ST Destination Prod. 79")
            {
                ApplicationArea = All;
            }
            field("ST Destination Prod. 92"; "ST Destination Prod. 92")
            {
                ApplicationArea = All;
            }
            field("ST Application Cost PT"; "ST Application Cost PT")
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