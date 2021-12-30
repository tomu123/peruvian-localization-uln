tableextension 51055 "Setup Customer Posting Group" extends "Customer Posting Group"
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
        field(51002; "Promissory Note Type"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Promissory Note Type';
            OptionMembers = " ","Free charge",Wallet,"Warranty charge";
            OptionCaption = ' ,Free charge,Wallet,Warranty charge';
        }
        field(51003; "Say Cronograma"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Say Cronograma', Comment = 'ESM="Ver Cronograma"';
        }
    }

    var
        myInt: Integer;
}