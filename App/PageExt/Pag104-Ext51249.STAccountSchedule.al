pageextension 51250 "ST Account Schedule" extends "Account Schedule"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {
            field("Cod Financial Status"; "Cod Financial Status")
            {
                ApplicationArea = All;
            }
            field(Orientation; Orientation)
            {
                ApplicationArea = All;
            }
        }


    }
}