pageextension 51056 "AER Curr. Exch. Rates" extends "Currency Exchange Rates"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addfirst(Creation)
        {
            action("Update Currencies")
            {
                ApplicationArea = All;
                Caption = 'Update Currencies', Comment = 'ESM="Obtener tipo cambio"';
                Image = CurrencyExchangeRates;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    CurrencyTypeMgt: Codeunit "Consulta TC Mgt.";
                begin
                    Rec.TestField("Currency Code", 'USD');
                    Clear(CurrencyTypeMgt);
                    CurrencyTypeMgt.SetParameters(Rec."Currency Code", 0D);
                    CurrencyTypeMgt.SetStartDate();
                    CurrencyTypeMgt.GetCurrencyAmount()
                end;
            }
            action(Testdasd)
            {
                ApplicationArea = All;
                Caption = 'Probar File', Comment = 'ESM="Obtener tipo cambio"';
                Visible = false;
                Image = CurrencyExchangeRates;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    //TempBlobTest: Record TempBlob;
                    lcPath: Text;
                begin
                    //TempBlobTest.Blob.Import('C:\ULN\Percy\AllReportes.txt');
                end;
            }
        }

    }

    var
        myInt: Integer;
}