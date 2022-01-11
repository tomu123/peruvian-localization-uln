pageextension 51212 "ST Posted Purchase Credit Memo" extends "Posted Purchase Credit Memo"
{
    Editable = false;
    layout
    {
        // Add changes to page layout here
        addafter("Posting Date")
        {
            field("Accountant receipt date"; "Accountant receipt date")
            {
                ApplicationArea = All;
            }
        }
    }
}