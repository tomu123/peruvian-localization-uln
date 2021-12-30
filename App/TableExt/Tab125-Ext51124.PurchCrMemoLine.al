tableextension 51124 "Purch. Cr Memo Standar Code" extends "Purch. Cr. Memo Line"
{
    fields
    {
        field(51008; "Purchase Standard Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Purch. Standar Code', Comment = 'ESM="Cód. Compra estándar"';
            Editable = false;
        }
        field(51001; "Importation No."; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Importation No.', Comment = 'ESM="N° Importación"';
        }
    }
}