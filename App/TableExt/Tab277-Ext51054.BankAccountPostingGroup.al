tableextension 51054 "Setup Bank Acc. Posting Group" extends "Bank Account Posting Group"
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
        field(51001; Description; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description';
        }

    }

    var
        myInt: Integer;
}