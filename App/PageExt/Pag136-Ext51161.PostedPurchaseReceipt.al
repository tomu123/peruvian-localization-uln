pageextension 51161 "LD Posted Purchase Receipt" extends "Posted Purchase Receipt"
{
    Editable = false;
    layout
    {
        // Add changes to page layout here
        addafter("Vendor Order No.")
        {
            field("Legal Document"; "Legal Document")
            {
                ApplicationArea = All;
            }
        }
    }
}