tableextension 51112 "Setup Purch. Cr. Memo Hdr." extends "Purch. Cr. Memo Hdr."
{
    fields
    {
        // Add changes to table fields here 51024..51025,51050..51059
        //Legal Document Begin
        field(51000; "Legal Document"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Legal Document', Comment = 'ESM="Documento Legal"';
        }
        field(51001; "Legal Status"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Legal Status', Comment = 'ESM="Estado legal"';
            //OptionMembers = Success,Anulled,OutFlow;//'ULN:PC 18.01.21
            // OptionCaption = 'Success,Anulled,OutFlow', Comment = 'ESM="Normal,Anulado,Extornado"';//'ULN:PC 18.01.21
            OptionMembers = Success,OutFlow;
            OptionCaption = 'Success,OutFlow', Comment = 'ESM="Normal,Extornado"';
        }
        field(51002; "Legal Document Ref."; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Legal Document Ref.', Comment = 'ESM="Documento legal Ref."';
        }
        field(51011; "VAT Registration Type"; Code[2])
        {
            DataClassification = ToBeClassified;
            Caption = 'VAT Registration Type', Comment = 'ESM="Tipo Doc. Identidad"';
            TableRelation = "Legal Document"."Legal No." where("Option Type" = const("SUNAT Table"), "Type Code" = const('02'));
            ValidateTableRelation = false;
        }
        field(51012; "Legal Property Type"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Legal Property Type', Comment = 'ESM="Tipo de bien"';
            TableRelation = "Legal Document"."Legal No." where("Option Type" = const("SUNAT Table"), "Type Code" = const('30'));
            ValidateTableRelation = false;
        }
        field(51030; "Manual Document Ref."; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Manual Document Ref.', Comment = 'ESM="Doc. Ref. Manual"';
        }
        field(51031; "Electronic Doc. Ref"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Electronic Doc. Ref', Comment = 'ESM="Doc. ELectrónico Ref."';
        }
        field(51032; "Applies-to Doc. No. Ref."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Applies-to Doc. No. Ref', Comment = 'ESM="Liq. por N° Documento Ref."';
            TableRelation = if ("Manual Document Ref." = Const(false)) "Purch. Inv. Header"."No." where("Legal Status" = const(Success), "Legal Document" = field("Legal Document Ref."), "Buy-from Vendor No." = field("Buy-from Vendor No."));
            ValidateTableRelation = false;
        }
        field(51033; "Applies-to Serie Ref."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Applies-to Serie Ref', Comment = 'ESM="Liq. por Serie Ref."';
        }
        field(51034; "Applies-to Number Ref."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Applies-to Number Ref.', Comment = 'ESM="Liq. por numero Ref."';
        }
        field(51035; "Applies-to Document Date Ref."; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Applies-to Document Date Ref.', Comment = 'ESM="Liq. Fecha Emisión Ref."';
        }
        //Legal Document End
        field(51050; "Setup Source Code"; Enum "ST Source Code Type")
        {
            DataClassification = ToBeClassified;
            Caption = 'Source Code ULN', Comment = 'ESM="Cód. Origen ULN"';
            //TableRelation = "Master Data".Code where("Type Table" = const('STPSOURCECODE'));
        }
        field(51051; "Posting Text"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Posting Text', Comment = 'ESM="Texto registro"';
        }
        field(51055; "Accountant receipt date"; date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Accountant receipt date', Comment = 'ESM="Fecha recepción contabilidad"';
            Editable = false;
        }
        field(51024; "Payment Bank Account No."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Vendor Bank Account".Code where("Vendor No." = field("Pay-to Vendor No."));
            Caption = 'Payment Bank Account No.', Comment = 'ESM="N° banco de pago"';
        }
    }
}