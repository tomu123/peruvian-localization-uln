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
            group(Aplicacion)
            {
                Visible = true;
                Caption = 'Application';

                field("Applies-to Doc. Type2"; "Applies-to Doc. Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Applies-to Doc. No.2"; "Applies-to Doc. No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Manual Document Ref."; "Manual Document Ref.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                // field("Electronic Doc. Ref"; "Electronic Doc. Ref")
                // {
                //     ApplicationArea = All;
                //     Editable = false;
                // }
                field("Applies-to Doc. No. Ref."; "Applies-to Doc. No. Ref.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Legal Document Ref."; "Legal Document Ref.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Applies-to Serie Ref."; "Applies-to Serie Ref.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Applies-to Number Ref."; "Applies-to Number Ref.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Applies-to Document Date Ref."; "Applies-to Document Date Ref.")
                {
                    ApplicationArea = All;
                    Editable = false;
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