pageextension 51262 "ST Currencies" extends Currencies
{
    layout
    {
        // Add changes to page layout here

    }

    actions
    {
        // Add changes to page actions here
        modify("Adjust Exchange Rate")
        {
            Visible = false;
            Enabled = false;
        }
        addafter("Adjust Exchange Rate")
        {
            action("ST Adjust Exchange Rate")
            {
                ApplicationArea = Suite;
                Caption = 'Atria Ajustar el tipo de cambio';
                Image = AdjustExchangeRates;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Report "ST Adjust Exchange Rates";
            }

        }
    }



    var
        myInt: Integer;
}