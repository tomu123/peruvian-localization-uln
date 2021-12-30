pageextension 51050 "Setup Employee Posting Groups" extends "Employee Posting Groups"
{
    layout
    {
        // Add changes to page layout here
        addafter("Payables Account")
        {
            field(Description; Description)
            {
                ApplicationArea = All;
            }
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
        addafter("Payables Account")
        {
            field("PS Not Show"; "PS Not Show")
            {
                ApplicationArea = All;
                ToolTip = 'Not show payment schedule', Comment = 'ESM="No mostrar en cronograma de pagos"';
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        Rec.Description := gSetupLocalization.fnGetAccountDescription("Payables Account");
    end;

    var
        gSetupLocalization: Codeunit "Setup Localization";
}