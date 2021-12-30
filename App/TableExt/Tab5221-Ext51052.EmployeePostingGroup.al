tableextension 51052 "Setup Employee Posting Group" extends "Employee Posting Group"
{
    fields
    {
        // Add changes to table fields here 51000..51005
        field(51010; "Description"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description', Comment = 'ESM="Descripción"';
        }
        field(51011; "Currency Exch. Type"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Currency Exch. Type', Comment = 'ESM="Tipo Cambio Ajuste"';
            OptionMembers = Active,Passive;
            OptionCaption = 'Active,Pasive';
        }
        field(51012; "Currency Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Currency Code', Comment = 'ESM="Cód. Divisa"';
            TableRelation = Currency;
        }

        //Payment Schedule
        field(51006; "PS Not Show"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Not Show Pay. Sche.', Comment = 'ESM="No mostrar C. P."';
        }
    }

    var
        myInt: Integer;
}