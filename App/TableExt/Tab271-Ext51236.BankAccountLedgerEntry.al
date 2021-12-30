tableextension 51236 "ST Bank Acc. Ledger Entry" extends "Bank Account Ledger Entry"
{
    fields
    {
        // Add changes to table fields here
        field(51022; "Diff. reversal posting date"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Diff. reversal posting date', Comment = 'ESM="Reversión con fecha diferida"';
        }
        field(57002; "Global Dimension FCT"; Code[20])
        {
            Caption = 'Global Dimension FCT', Comment = 'ESM="FCT"';
        }
        field(57003; "Global Dimension FE"; Code[20])
        {
            Caption = 'Global Dimension FE', Comment = 'ESM="FE"';
        }
    }

    var
        myInt: Integer;
}