pageextension 51054 "Setup Customer Posting Groups" extends "Customer Posting Groups"
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
            field("Promissory Note Type"; "Promissory Note Type")
            {
                ApplicationArea = All;
            }
            field("Say Cronograma"; "Say Cronograma")
            {
                ApplicationArea = All;
            }
        }
    }
}