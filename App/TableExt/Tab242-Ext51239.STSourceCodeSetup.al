tableextension 51239 "ST Source Code Setup" extends "Source Code Setup"
{
    fields
    {
        field(51000; "Code Open"; Text[30])
        {
            Caption = 'Code Open', Comment = 'ESM="Código de Apertura"';
            DataClassification = ToBeClassified;
            TableRelation = "Source Code";
        }
        field(51001; "Code Close"; Text[30])
        {
            Caption = 'Code Close', Comment = 'ESM="Código de Cierre"';
            DataClassification = ToBeClassified;
            TableRelation = "Source Code";
        }
    }

}