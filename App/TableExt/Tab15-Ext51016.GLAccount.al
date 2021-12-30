tableextension 51016 "Analityc G/L Account" extends "G/L Account"
{
    fields
    {
        // Add changes to table fields here
        field(51000; "Analitycs"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        //Request Purchase
        field(51004; "PR Generic Purchase"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Generic Purchase', Comment = 'ESM="Compra genérica"';

        }
    }

    var
        myInt: Integer;
}