pageextension 51261 "ST Source Code Setup" extends "Source Code Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("Cost Accounting")
        {
            group("Localizado")
            {
                field("Code Open"; "Code Open")
                {
                    Visible = true;
                    ApplicationArea = All;

                }
                field("Code Close"; "Code Close")
                {
                    Visible = true;
                    ApplicationArea = All;

                }
            }

        }

    }
}