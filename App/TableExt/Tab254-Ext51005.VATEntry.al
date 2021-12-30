tableextension 51005 "Legal Doc. VAT Entry" extends "VAT Entry"
{
    fields
    {
        //Add fields 51000..51001,51004..51010
        field(51000; "Legal Document"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Legal Document', Comment = 'ESM="Documento Legal"';
            TableRelation = "Legal Document"."Legal No." where("Option Type" = const("SUNAT Table"), "Type Code" = const('10'));
            ValidateTableRelation = false;
        }

        field(51001; "Legal Status"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Legal Status', Comment = 'ESM="Estado legal"';
            OptionMembers = Success,Anulled,OutFlow;
            OptionCaption = 'Success,Anulled,OutFlow', Comment = 'ESM="Normal,Anulado,Extornado"';
        }
        field(51004; "Ext/Anul. User Id."; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Ext/Anul. User Id.', Comment = 'ESM="Ext/Anul. Id. Usuario"';
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(51003; "Importation No."; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Importation No.', Comment = 'ESM="N° Importación"';
        }
        field(51002; "Correlative CUO"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Correlative CUO', Comment = 'ESM="CUO Correlativa"';
        }
    }
}