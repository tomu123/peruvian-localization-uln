pageextension 51087 "Detrac. Posted Sales Invoice" extends "Posted Sales Invoice"
{
    Editable = false;
    layout
    {
        // Add changes to page layout here
        addafter("Shipping and Billing")
        {
            group(Detraction)
            {
                Caption = 'Detraction', Comment = 'ESM="Detracción"';
                field("Sales Detraction"; "Sales Detraction")
                {
                    ApplicationArea = All;
                }
                field("Operation Type Detrac"; "Operation Type Detrac")
                {
                    ApplicationArea = All;
                }
                field("Service Type Detrac"; "Service Type Detrac")
                {
                    ApplicationArea = All;
                }
                field("Payment Method Code Detrac"; "Payment Method Code Detrac")
                {
                    ApplicationArea = All;
                }
                field("Sales % Detraction"; "Sales % Detraction")
                {
                    ApplicationArea = All;
                }
                field("Sales Amt Detraction"; "Sales Amt Detraction")
                {
                    ApplicationArea = All;
                }
                field("Sales Amt Detraction (LCY)"; "Sales Amt Detraction (LCY)")
                {
                    ApplicationArea = All;
                }
            }
        }
        //Titulo gratuito
        addafter(Closed)
        {
            field("FT Free Title"; "FT Free Title")
            {
                ApplicationArea = All;
                Editable = FreeTitleEditable;
            }
        }
    }
    trigger OnOpenPage()
    begin
        LSetup.Get();
        FreeTitleEditable := LSetup."FT Free Title";
    end;

    var
        FreeTitleEditable: Boolean;
        LSetup: Record "Setup Localization";

}