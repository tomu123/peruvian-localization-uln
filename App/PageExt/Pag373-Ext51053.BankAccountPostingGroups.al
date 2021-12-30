pageextension 51053 "Setup Bank Acc. Posting Groups" extends "Bank Account Posting Groups"
{
    layout
    {
        addafter(Code)
        {
            field(Description; Description)
            {
                ApplicationArea = All;
            }
        }
        addafter("G/L Account No.")
        {
            field("Currency Exch. Type"; "Currency Exch. Type")
            {
                ApplicationArea = All;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        Rec.Description := gSetupLocalization.fnGetAccountDescription("G/L Bank Account No.");
    end;

    var
        gSetupLocalization: Codeunit "Setup Localization";
}