pageextension 51055 "Setup Cust. Posting Gr. Card" extends "Customer Posting Group Card"
{
    layout
    {
        // Add changes to page layout here
        addafter(General)
        {
            group(Localization)
            {
                Caption = 'Setup Localization';
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
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    trigger OnAfterGetCurrRecord()
    begin
        Rec.Description := gSetupLocalization.fnGetAccountDescription("Receivables Account");
    end;

    var
        gSetupLocalization: Codeunit "Setup Localization";
}