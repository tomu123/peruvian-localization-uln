tableextension 51053 "Setup Vendor Posting Group" extends "Vendor Posting Group"
{
    fields
    {
        // Add changes to table fields here
        field(51000; "Currency Exch. Type"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Currency Exch. Type';
            OptionMembers = Active,Passive;
            OptionCaption = 'Active,Pasive';
        }
        field(51001; "Currency Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Currency Code';
            TableRelation = Currency;
        }

        //Payment Schedule
        field(51011; "PS Not Show"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Not Show Pay. Sche.', Comment = 'ESM="No mostrar C. P."';
        }
    }

    var
        myInt: Integer;
}