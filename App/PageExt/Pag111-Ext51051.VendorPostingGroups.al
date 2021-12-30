pageextension 51051 "Setup Vendor Posting Groups" extends "Vendor Posting Groups"
{
    layout
    {
        // Add changes to page layout here
        addafter("Payment Tolerance Credit Acc.")
        {
            field("Currency Exch. Type"; "Currency Exch. Type")
            {
                ApplicationArea = All;
            }
            field("Currency Code"; "Currency Code")
            {
                ApplicationArea = All;
            }
        }

        //Payment Schedule
        addafter("Payment Tolerance Credit Acc.")
        {
            field("PS Not Show"; "PS Not Show")
            {
                ApplicationArea = All;
                ToolTip = 'Not show payment schedule', Comment = 'ESM="No mostrar en cronograma de pagos"';
            }
        }
    }
}