tableextension 51058 "Import Item Ledger Entry" extends "Item Ledger Entry"
{
    fields
    {
        field(51001; "Importation No."; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Importation No.';
        }
        field(51002; "Closed Import"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Closed Import';
        }
        field(51003; "Nationalization"; Option)
        {
            Caption = 'Nationalization';
            OptionCaption = ' ,Yes,No';
            OptionMembers = " ",Yes,No;
            DataClassification = ToBeClassified;

        }
    }
}