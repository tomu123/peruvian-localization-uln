pageextension 51187 "Mov. Entry. Employee PG" extends 234
{
    layout
    {
        // Add changes to page layout here
        addafter("Currency Code")
        {
            field("Employee Posting Group"; "Employee Posting Group")
            {

            }
            field("Entry No."; "Entry No.")
            {

            }

        }
        modify("Document Type")
        {
            Visible = false;
        }
    }


    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}