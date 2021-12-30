tableextension 51079 "ST Vendor Bank Account" extends "Vendor Bank Account"
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
            Caption = 'Check Manager', Comment = 'ESM="Cheque de gerencia"';
        }
        field(51002; "Reference Bank Acc. No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Reference Bank', Comment = 'ESM="Banco pagador"';
            TableRelation = "Bank Account";
            trigger OnValidate()
            begin
                if "Reference Bank Acc. No." = '' then
                    exit;
                BankAccount.Get("Reference Bank Acc. No.");
                "Currency Code" := BankAccount."Currency Code";
            end;
        }
        field(51003; "Vend. Name/Business Name"; code[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vend. Name/Business Name', Comment = 'ESM="Razón Social/Nombre"';
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
        //Documento Legal
        field(51010; "Legal Document"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Legal Document', Comment = 'ESM="Document Legal"';
            TableRelation = "Legal Document"."Legal No." where("Option Type" = const("SUNAT Table"), "Type Code" = const('03'));
        }
        field(51012; "Fiduciary"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Fiduciary', Comment = 'ESM="Fiduciario"';
        }
        field(51013; "Type Fiduciary"; Option)
        {
            Caption = 'Type Fiduciary', Comment = 'ESM="Tipo Fiduciario"';
            OptionCaption = 'Bank Fiduciary,Vendor Fiduciary', Comment = 'ESM="Banco Fiduciario,Proveedor Fiduciario"';
            OptionMembers = "Bank Fiduciary","Vendor Fiduciary";
        }
    }

    var
        BankAccount: Record "Bank Account";
}