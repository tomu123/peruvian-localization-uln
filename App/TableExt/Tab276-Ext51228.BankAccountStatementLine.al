tableextension 51228 "ST Bank Account Statement Line" extends "Bank Account Statement Line"
{
    fields
    {
        // Add changes to table fields here 51000..51010
        field(51000; "Import Extract The Bank"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Imported from bank statement', Comment = 'ESM="Importado desde extracto de banco"';

        }
        field(51001; "EB Statement Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Statement Line No.', Comment = 'ESM="Nº lín. Extracto de cta. banco"';

        }
        field(51002; "Description 2"; Text[100])
        {
            Caption = 'Description Atria', Comment = 'ESM="Descripción Atria"';
        }
        field(50003; "Entry Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ULNLPE.11:PLE';
            OptionMembers = Cheque,"Cheque Pendiente",Deposito,"Deposito Pendiente",Ajuste;
        }
        field(50004; "Source Code"; Code[10])
        {
            Caption = 'Source Code', Comment = 'ESM="Cód. origen"';
            DataClassification = ToBeClassified;
            Description = 'ULNLPE.11:PLE';
            TableRelation = "Source Code";
        }
        field(50005; "Source Type"; Option)
        {
            Caption = 'Source Type', Comment = 'ESM="Procedencia Tipo"';
            DataClassification = ToBeClassified;
            OptionCaption = 'Mov. banco,Mov. cheque,Diferencia', Comment = 'ESM="Mov. banco,Mov. cheque,Diferencia"';
            OptionMembers = "Bank Account Ledger Entry","Check Ledger Entry";
        }
    }
}