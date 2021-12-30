pageextension 51198 "LU Source Codes" extends "Source Codes"
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {
            field("Input / output"; "Input / output")
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