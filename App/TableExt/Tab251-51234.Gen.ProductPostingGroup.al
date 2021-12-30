tableextension 51234 "ST Gen. Product Posting Group" extends "Gen. Product Posting Group"
{
    fields
    {
        // Add changes to table fields here 51000..51010
        field(51000; "Free Title"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Free Title', Comment = 'ESM="Título Gratuito Compra"';

        }
    }

    var
        myInt: Integer;
}