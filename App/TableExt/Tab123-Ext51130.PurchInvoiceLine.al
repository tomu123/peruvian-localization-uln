tableextension 51130 "ST Purch. Invoice Line" extends "Purch. Inv. Line"
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