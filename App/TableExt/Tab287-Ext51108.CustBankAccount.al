tableextension 51108 "ST Customer Bank Account" extends "Customer Bank Account"
{
    fields
    {
        // Add changes to table fields here
        field(51000; "Bank Account Type"; Enum "ST Bank Account Type")
        {
            DataClassification = ToBeClassified;
            Caption = 'Bank Account Type', Comment = 'ESM="Tipo Cuenta Bancaria"';
        }
        field(51001; "Check Manager"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Check Manager', Comment = 'ESM="Cheque Gerencia"';
        }
        field(51002; "Reference Bank Acc. No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Reference Bank', Comment = 'ESM="Banco Referencia"';
            TableRelation = "Bank Account";
            trigger OnValidate()
            begin
                if "Reference Bank Acc. No." = '' then
                    exit;
                BankAccount.Get("Reference Bank Acc. No.");
                "Currency Code" := BankAccount."Currency Code";
            end;
        }
        field(51003; "Cust. Name/Business Name"; code[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Business Name', Comment = 'ESM="Razón Social / Nombre"';
            Editable = false;
        }
        field(51004; "Bank Account CCI"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Bank Account CCI', Comment = 'ESM="N° Cuenta CCI"';
        }
        field(51006; "Bank Type Check"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Bank Type Check', Comment = 'ESM="Tipo Banco Cheque"';
        }
        //Legal Document 
        field(51010; "Legal Document"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Legal Document', Comment = 'ESM="Documento Legal"';
            TableRelation = "Legal Document"."Legal No." where("Option Type" = const("SUNAT Table"), "Type Code" = const('03'));
        }
    }

    var
        BankAccount: Record "Bank Account";
}