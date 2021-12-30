pageextension 51255 "ST Countries/Regions" extends "Countries/Regions"
{
    layout
    {
        // Add changes to page layout here
        addafter("ISO Code")
        {
            field("Cod. Sunat"; "Cod. Sunat")
            {
                Visible = true;
                ApplicationArea = All;

            }
        }

    }
}